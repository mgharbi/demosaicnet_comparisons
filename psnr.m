function p = psnr(I,O,maxval, border)
    p = (I-O).^2;
    p = p(border:end-border, border:end-border);
    p = mean(p(:));
    p = 10*log10(maxval*maxval/p);
end % psnr
