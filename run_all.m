function run(dataset, method, noise)
    datadir   = fullfile('data', dataset);

    if nargin < 2
        method = 'bilinear';
    end

    if nargin < 3
        noise = 0;
    end
    noise = str2num(noise);

    list      = dir(datadir);
    isfile    = ~[list.isdir];
    filenames = {list(isfile).name}; 
    for f = 1:length(filenames)
        if strcmp(filenames{f}, '.DS_Store')
            continue
        end
        fprintf('Running %s\n', filenames{f});
        run(dataset,filenames{f},method, noise);
    end

end % function run
