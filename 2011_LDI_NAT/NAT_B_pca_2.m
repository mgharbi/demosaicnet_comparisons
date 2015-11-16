function B = NAT_B_pca_2(B)

[n,m]=size(B);
W=16;
k=15;
b=2;

%%%1. first row: 
for i=W+1:2:n-W
    for j=W+1:m-W
      Block=B(i-k:i+k,j-k:j+k);%(2k+1)*(2k+1)
      CB=B(i-b:i+b,j-b:j+b);%central block (2b+1)*(2b+1)
      g=lpgpca_1(Block,CB,2*b+1);
      B(i,j)=g;
    end
end

%%%2. second row: 
for i=W+2:2:n-W-1
    for j=W+1:2:m-W
      Block=B(i-k:i+k,j-k:j+k);%(2k+1)*(2k+1)
      CB=B(i-b:i+b,j-b:j+b);%central block (2b+1)*(2b+1)
      g=lpgpca_1(Block,CB,2*b+1);
      B(i,j)=g;
    end
end


return

