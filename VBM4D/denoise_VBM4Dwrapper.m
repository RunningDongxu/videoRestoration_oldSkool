function [y_est, sigmaEst, PSNR, SSIM] = denoise_VBM4Dwrapper(y)

    % The software implements the BM4D denoising algorithm described in the papers:
    %
    % M. Maggioni, V. Katkovnik, K. Egiazarian, A. Foi, "A Nonlocal Transform-Domain Filter 
    % for Volumetric Data Denoising and Reconstruction", IEEE Trans. Image Process.,
    % vol. 22, no. 1, pp. 119-133, January 2013. doi:10.1109/TIP.2012.2210725
    %
    % M. Maggioni, A. Foi, "Nonlocal Transform-Domain Denoising of Volumetric Data With 
    % Groupwise Adaptive Variance Estimation", Proc. SPIE Electronic Imaging 2012, 
    % San Francisco, CA, USA, Jan. 2012
    %
    % --------------------------------------------------------------------------------------------
    %
    % authors:               Matteo Maggioni
    %                        Alessandro Foi
    %
    % web page:              http://www.cs.tut.fi/~foi/GCF-BM3D
    %
    % contact:               firstname.lastname@tut.fi
    %
    % --------------------------------------------------------------------------------------------
    % Copyright (c) 2010-2015 Tampere University of Technology.
    % All rights reserved.
    % This work should be used for nonprofit purposes only.
    % --------------------------------------------------------------------------------------------
    %
    % Disclaimer
    % ----------
    %
    % Any unauthorized use of these routines for industrial or profit-oriented activities is
    % expressively prohibited. By downloading and/or using any of these files, you implicitly
    % agree to all the terms of the TUT limited license (included in the file Legal_Notice.txt).
    % --------------------------------------------------------------------------------------------
    %

    

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Modifiable parameters
    file_name = '';      % Video file name. If empty, a prompt dialog will appear
    sigma     = 25;      % Noise standard deviation. it should be in the same 
                         % intensity range of the video
    profile = 'lc';      % V-BM4D parameter profile
                         %  'lc' --> low complexity
                         %  'np' --> normal profile
    do_wiener = 1;       % Wiener filtering
                         %   1 --> enable Wiener filtering
                         %   0 --> disable Wiener filtering
    sharpen = 1;         % Sharpening
                         %   1 --> disable sharpening
                         %  >1 --> enable sharpening
    deflicker = 1;       % Deflickering
                         %   1 --> disable deflickering
                         %  <1 --> enable deflickering
    verbose = 1;         % Verbose mode

    est_noise = 1;       % Enable noise estimation
    
    % Petteri
    visualizeOn       = 0;

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %       MODIFY BELOW THIS POINT ONLY IF YOU KNOW WHAT YOU ARE DOING       %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    disp('VBM4D VIdeo Denoising')
    
    % Set sigma to -1 to enable noise estimation
    if est_noise
        sigma = -1;
    end


    % perform filtering
    disp('Denoising started')
    [y_est, sigma_est] = bm4d(y, distribution, (~estimate_sigma)*sigma, profile, do_wiener, verbose);
    sigmaEst = nanmean(sigma_est(:));
    
    % objective result
    ind = y>0;
    PSNR = 10*log10(1/mean((y(ind)-y_est(ind)).^2));
    SSIM = ssim_index3d(y*255,y_est*255,[1 1 1],ind);
    fprintf('Denoising completed: PSNR %.2fdB / SSIM %.2f \n', PSNR, SSIM)

    % plot historgram of the estimated standard deviation
    if estimate_sigma
        map = ones(size(y));
        eta = sigma*map;
        if visualizeOn
            helper.visualizeEstMap( y, sigma_est, eta );
        end
    end

    % show cross-sections
    if visualizeOn
        helper.visualizeXsect( y, y, y_est );
    end

    % save experiments workspace
    if save_mat
        save([y,'_sigma',num2str(sigma*100),'.mat'],...
            'y','z','y_est','sigma_est','sigma','PSNR')
    end
