function run(dataset, imname, method)
    % I = imread(fullfile('data','mosaic','McMasterPPM', imname));
    I = imread(fullfile('data', dataset, imname));
    I = im2double(I);
    if nargin < 3
        method = 'bilinear';
    end

    M = make_mosaic(I);

    tic;
    switch method
        case 'bilinear'
            O = bilinear_demosaic(M);
        case 'ahd'
            addpath('2003_AHD')
            O = MNdemosaic(mosaic(I),3);
        case 'dlmmse'
            addpath('2005_DLMMSE');
            I = I;
            O = dlmmse(M*255);
            O = O/255.0;
        case 'ldi_nat'
            addpath('2011_LDI_NAT');
            O = nat_cdm(M);
        case 'flexisp'
            O = flexisp_cdm(I);
    end
    % XXX: Only green:
    % I = I(:,:,2);
    % O = O(:,:,2);
    time = toc;
    p = psnr(I,O,1.0, 5);
    fprintf('Demosaic %s, with "%s": %.1fdB in %.0fms\n', imname, method, p, 1000*time);

    % O = uint8(O);
    fname = [method, sprintf('_%.1fdB_%.0fms.ppm', p, time*1000)];

    [~, imname, ext] = fileparts(imname);

    outdir = fullfile('output', method, dataset);
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end
    outpath = fullfile(outdir, [imname, '.png']);
    imwrite(O, outpath);

    csvpath = fullfile(outdir, [imname, '.csv']);
    csvwrite(csvpath, [p, time*1000]);
    
    % fname = [method, sprintf('_%.1fdB_%.0fms.png', p, time*1000)];
end % run
