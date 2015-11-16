function M = make_mosaic(I)
    %  Obtaining the CFA measurement according to the Bayer pattern
    % 
    %  INPUT
    %    I: a full-color image of size m-by-n-by-3
    %
    %  OUTPUT
    %    M: the CFA measurement of size m-by-n.
    %
    %  NOTE
    %    We assume the following arrangement of the Bayer CFA. Starting from
    %    the upper-left corner, we have
    %    
    %    g r g r ...
    %    b g b g ...


    % Copy green
    M = I(:,:,2);

    % Copy red
    M(1:2:end, 2:2:end) = I(1:2:end, 2:2:end, 1);

    % Copy blue
    M(2:2:end, 1:2:end) = I(2:2:end, 1:2:end, 3);
end

