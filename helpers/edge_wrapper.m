function edges = edge_wrapper(I, method)

    edges = zeros(size(I));

    if strcmp(method, 'canny')
        for i = 1 : size(I,3)
            edges(:,:,i) = edge(I(:,:,i), method);
        end
    else
        error(['Method "', method, '" not supported'])
    end
     