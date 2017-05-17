function visualize_results(input, den_lin, den_log, ...
                           den_lin_sm, den_log_sm, ...
                           input_edges, den_lin_edges, den_log_edges, ...
                           den_lin_sm_edges, den_log_sm_edges, ...
                           input_CLAHE, den_lin_CLAHE, den_log_CLAHE, ...
                           den_lin_sm_CLAHE, den_log_sm_CLAHE, ...
                           frame_of_interest, noiseModel, saveOn, output_dir)
                       
    close all
    
    if strcmp(noiseModel, 'Additive')
        denoised = den_lin;
        sm = den_lin_sm;
        edges = den_lin_edges;
        edges_sm = den_lin_sm_edges;
        CLAHE = den_lin_CLAHE;
        CLAHE_sm = den_lin_sm_CLAHE;
    elseif strcmp(noiseModel, 'Multiplicative')
        denoised = den_log;
        sm = den_log_sm;
        edges = den_log_edges;
        edges_sm = den_log_sm_edges;
        CLAHE = den_log_CLAHE;
        CLAHE_sm = den_log_sm_CLAHE;
    else
        error(['noiseModel: "', noisemodel, '" not supported'])
    end
    
    % Input 10 images + 5 CLAHEs that could be computed on-line as well
        
    % Subplot layout
    rows = 4;
    cols = 6;
    ind = 0;
    
    scrsz = get(0,'ScreenSize');
    fig = figure('Color', 'w', 'Name', 'Denoising Test');
        set(fig, 'Position', [0.1*scrsz(3) 0.1*scrsz(4) 0.8*scrsz(3) 0.8*scrsz(4)])

    % ROW 1
    
    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(input(:,:,frame_of_interest), [])
    tit(ind) = title(['Input, frame #', num2str(frame_of_interest)]);

    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(denoised(:,:,frame_of_interest), [])
    tit(ind) = title([noiseModel, 'Denoising']);

    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(sm(:,:,frame_of_interest), [])
    tit(ind) = title([noiseModel, 'Denoising + LO']);
    
    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(input_edges(:,:,frame_of_interest), [])
    tit(ind) = title('Edges: Input');

    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(edges(:,:,frame_of_interest), [])
    tit(ind) = title(['Edges: Denoising']);

    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(edges_sm(:,:,frame_of_interest), [])
    tit(ind) = title('Edges: Denoising + LO');
    
    % ROW 2 : Difference
    
    ind = ind+1;
    subplot(rows,cols,ind)
    axis off
    tit(ind) = title(' ');
    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(input(:,:,frame_of_interest) - denoised(:,:,frame_of_interest), [])
    tit(ind) = title('Denoising Residual');
    
    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(denoised(:,:,frame_of_interest) - sm(:,:,frame_of_interest), [])
    tit(ind) = title('L0 Residual');
    
    ind = ind+1;
    subplot(rows,cols,ind)
    axis off
    tit(ind) = title(' ');
    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(input_edges(:,:,frame_of_interest) - edges(:,:,frame_of_interest), [])
    tit(ind) = title('Denoised Edge Residual');
    
    ind = ind+1;
    subplot(rows,cols,ind)
    imshow(edges(:,:,frame_of_interest) - edges_sm(:,:,frame_of_interest), [])
    tit(ind) = title('L0 Edge Residual');
    
    % ROWS 3-4 : Clahe
    ind = ind+1;
    subplot(rows,cols,[ind ind+1 ind+cols ind+cols+1])
    imshow(input_CLAHE(:,:,frame_of_interest), [])
    tit(ind) = title('Input CLAHE');
    
    ind = ind+2;
    subplot(rows,cols,[ind ind+1 ind+cols ind+cols+1])
    imshow(denoised(:,:,frame_of_interest), [])
    tit(ind-1) = title('Denoised');
    
    ind = ind+2;
    subplot(rows,cols,[ind ind+1 ind+cols ind+cols+1])
    imshow(CLAHE_sm(:,:,frame_of_interest), [])
    tit(ind-2) = title('Denoised+L0 CLAHE');
    
    % Style
    set(tit, 'FontSize', 6)
    
    if frame_of_interest < 10
        frameIndex = ['000000', num2str(frame_of_interest)];
    elseif frame_of_interest < 100
        frameIndex = ['00000', num2str(frame_of_interest)];
    elseif frame_of_interest < 1000
        frameIndex = ['0000', num2str(frame_of_interest)];
    elseif frame_of_interest < 10000
        frameIndex = ['000', num2str(frame_of_interest)];
    elseif frame_of_interest < 100000
        frameIndex = ['00', num2str(frame_of_interest)];
    elseif frame_of_interest < 1000000
        frameIndex = ['0', num2str(frame_of_interest)];
    else
        frameIndex = ['', num2str(frame_of_interest)];
    end
    
    if saveOn == 1
        filename = ['denoised_video_frame_', frameIndex];
        saveas(fig, fullfile(output_dir, filename), 'png')
        close all
    end