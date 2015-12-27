function run(dataset,  noise)
    if ischar(noise)
        noise = str2num(noise);
    end

    datadir   = fullfile('data', dataset);
    list      = dir(datadir);
    isfile    = ~[list.isdir];
    filenames = {list(isfile).name}; 
    for f = 1:length(filenames)
        if strcmp(filenames{f}, '.DS_Store')
            continue
        end
        fprintf('Running %s\n', filenames{f});

        imname = filenames{f};

        I = imread(fullfile('data', dataset, imname));
        I = im2double(I);

        O = imnoise(I,'gaussian',0,noise*noise);
        
        outdir = fullfile('data', [dataset, '_', num2str(noise)]);
        if ~exist(outdir,'dir')
            mkdir(outdir);
        end
        outpath = fullfile(outdir, [imname, '.png']);

        imwrite(O, outpath);
    end

end
