function G = NAT_G_pca_2(G)

%%input: initially interpolated Green image
%%output: NAT processed image

[n,m]=size(G);

W=16;
k=15;
b=2;

%%%1. R positions: 
for i=W+1:2:n-W
    for j=W+2:2:m-W-1
      Block=G(i-k:i+k,j-k:j+k);%(2k+1)*(2k+1)
      CB=G(i-b:i+b,j-b:j+b);%central block (2b+1)*(2b+1)
      g=lpgpca_1(Block,CB,2*b+1);
      G(i,j)=g;
    end
end

%%%2. B positions: 
for i=W+2:2:n-W-1
    for j=W+1:2:m-W
      Block=G(i-k:i+k,j-k:j+k);%(2k+1)*(2k+1)
      CB=G(i-b:i+b,j-b:j+b);%central block (2b+1)*(2b+1)
      g=lpgpca_1(Block,CB,2*b+1);
      G(i,j)=g;
    end
end

return