function [denoised_video] = denoise_test(input_video)

    %% HOUSEKEEPING

        addpath(fullfile('.', 'BM4D'))
        addpath(fullfile('.', 'VBM4D'))  
        addpath(fullfile('.', 'L0smoothing'))
        addpath(fullfile('.', 'helpers'))
        
        % For visualization of filtering
        frame_of_interest = 56; 

        if nargin == 0
            current_dir = pwd;
            input_video = fullfile('testData', 'retinal_video.mp4');
            frame_dir = fullfile(current_dir, 'testData', 'frames');
            output_dir = fullfile(current_dir, 'testData', 'output');
        end

        % X = read_video(input_video); % Matlab could not read
        X = loadTheFrames(frame_dir);
    
    %% ACTUAL DENOISING 
    
        [Y_BM4D, sigmaEst, PSNR, SSIM] = denoise_BM4Dwrapper(X, 0); 
        [Y_BM4D_log, sigmaEst_log, PSNR_log, SSIM_log] = denoise_BM4Dwrapper(X, 1);
        
    %% POST-PROCESSING
    
        % Edge-aware smoothing, we do "L0-smoothing" here
        
        % with log-transform
        % [Y_BM4D_log_sm, ~, ~, ~] = enhance_logSmooothingFilter(Y_BM4D_log, 0.0001, );
        lambda = 10; % the bigger, the more smoothing
                     % Note, not very data-adaptive at all, and this
                     % depends heavily on your input data
        kappa = 2;
        
        disp('Edge-aware smoothing for post-processing')
        Y_BM4D_sm = L0Smoothing_stack(Y_BM4D, lambda, kappa);
        Y_BM4D_log_sm = L0Smoothing_stack(Y_BM4D_log, lambda, kappa);
        
    
    %% EDGE DETECTION
        
        % How the processing affects the edge detection process
        disp('Computing edges')
        input_edges = edge_wrapper(X,'canny');
        den_lin_edges = edge_wrapper(Y_BM4D,'canny');
        den_log_edges = edge_wrapper(Y_BM4D_log,'canny');
        den_lin_sm_edges = edge_wrapper(Y_BM4D_sm,'canny');
        den_log_sm_edges = edge_wrapper(Y_BM4D_log_sm,'canny');
        
    %% Compyte CLAHEs
    
        clipLimit = 0.02; % the larger, more stronger effect
        disp('Computing CLAHE')
        input_CLAHE = CLAHE_wrapper(X, clipLimit);
        den_lin_CLAHE = CLAHE_wrapper(Y_BM4D, clipLimit);
        den_log_CLAHE = CLAHE_wrapper(Y_BM4D_log, clipLimit);
        den_lin_sm_CLAHE = CLAHE_wrapper(Y_BM4D_sm, clipLimit);
        den_log_sm_CLAHE = CLAHE_wrapper(Y_BM4D_log_sm, clipLimit);
    
    %% VISUALIZE the SINGLE-FRAME
    
        visualize_results(X, Y_BM4D, Y_BM4D_log, ...
                           Y_BM4D_sm, Y_BM4D_log_sm, ...
                           input_edges, den_lin_edges, den_log_edges, ...
                           den_lin_sm_edges, den_log_sm_edges, ...
                           input_CLAHE, den_lin_CLAHE, den_log_CLAHE, ...
                           den_lin_sm_CLAHE, den_log_sm_CLAHE, ...
                           frame_of_interest, 'Additive', 1, output_dir)
                       
   %% VISUALIZE the whole video frame-by-frame
       
        for frame = 57 : size(X,3)
            
            visualize_results(X, Y_BM4D, Y_BM4D_log, ...
                               Y_BM4D_sm, Y_BM4D_log_sm, ...
                               input_edges, den_lin_edges, den_log_edges, ...
                               den_lin_sm_edges, den_log_sm_edges, ...
                               input_CLAHE, den_lin_CLAHE, den_log_CLAHE, ...
                               den_lin_sm_CLAHE, den_log_sm_CLAHE, ...
                               frame, 'Additive', 1, output_dir)
                           
        end