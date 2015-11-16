function I = NL_G(G,w,W)

%%G: initially interpolated Green image
%%I: NL processed image

%%w: (2w+1)*(2w+1) is the block size
%%W: (2W+1)*(2W+1) is the searching range

[n,m]=size(G);
I=G;

%%%1. R positions: 
for i=W+1:2:n-W
    for j=W+2:2:m-W-1
        Tc=G(i-w:i+w,j-w:j+w);%%the central block
        TN=G(i-W:i+W,j-W:j+W);%%the neighborhood block
        g=NLM_Pro_a(Tc,TN,2*w+1,2*W+1);
        I(i,j)=g;
    end
end

%%%2. B positions: 
for i=W+2:2:n-W-1
    for j=W+1:2:m-W
        Tc=G(i-w:i+w,j-w:j+w);%%the central block
        TN=G(i-W:i+W,j-W:j+W);%%the neighborhood block
        g=NLM_Pro_a(Tc,TN,2*w+1,2*W+1);
        I(i,j)=g;
    end
end


return

