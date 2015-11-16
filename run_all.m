function run(dataset, method)
    datadir   = fullfile('data', dataset);

    if nargin < 2
        method = 'bilinear';
    end

    list      = dir(datadir);
    isfile    = ~[list.isdir];
    filenames = {list(isfile).name}; 
    for f = 1:length(filenames)
        if strcmp(filenames{f}, '.DS_Store')
            continue
        end
        fprintf('Running %s\n', filenames{f});
        run(dataset,filenames{f},method);
    end

end % function run
