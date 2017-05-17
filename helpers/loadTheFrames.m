function X = loadTheFrames(folder)

    disp('Importing the frames into a matrix')
    

    s = dir(fullfile(folder, '*.png'));
    file_list = {s.name}';
    no_of_files = length(file_list);
    disp([' - found ', num2str(no_of_files), ' image files'])
    
    width = 96; % TODO! Now fixed
    height = 96; % TODO! Now fixed
    X = zeros(height,width,no_of_files);
    
    for ind = 1 : length(file_list)
        X(:,:,ind) = imread(fullfile(folder, file_list{ind}));
    end