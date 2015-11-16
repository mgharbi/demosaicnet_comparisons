function I = NLM_R(R,w,W)

%%R: initially interpolated Red image
%%I: NL processed image

[n,m]=size(R);
I=R;

%%%1. first row: 
for i=W+1:2:n-W
    for j=W+1:2:m-W
        Tc=R(i-w:i+w,j-w:j+w);%%the central block
        TN=R(i-W:i+W,j-W:j+W);%%the neighborhood block
        g=NLM_Pro_a(Tc,TN,2*w+1,2*W+1);
        I(i,j)=g;
    end
end

%%%2. second row: 
for i=W+2:2:n-W-1
    for j=W+1:m-W
        Tc=R(i-w:i+w,j-w:j+w);%%the central block
        TN=R(i-W:i+W,j-W:j+W);%%the neighborhood block
        g=NLM_Pro_a(Tc,TN,2*w+1,2*W+1);
        I(i,j)=g;
    end
end


return

