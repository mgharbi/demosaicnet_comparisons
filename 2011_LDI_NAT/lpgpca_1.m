function I=lpgpca_1(I,CB,w)

%%pca-based NAT, w*w vector block
%%I: input block n*m

[n,m]=size(I);
N=n-w+1;
M=m-w+1;
L=N*M;

X=zeros(w*w,L);

%%%
CB=CB';
CB=CB(:);
CB=repmat(CB,1,L);

k=0;
for i=1:w
   for j=1:w
      k=k+1;
      T=I(i:n-w+i,j:m-w+j);
      T=T(:);
      X(k,:)=T';
   end
end

%%%grouping
E=abs(X-CB).^2;
mE=mean(E);
[val,ind]=sort(mE);

%%%%%%%%
kk=100;
X=X(:,ind(1:kk));

%%estimate the noise level
v2=0;
for i=1:25
    ex=X(i,:)-X(13,:);
    v2=v2+mean(ex.^2);
end
v2=0.03*v2/24;

[Y, P, V, mX]=getpca(X);

for i=1:25
   y=Y(i,:);
   py=mean(y.^2)+0.01;
   mpv=max(0,py-v2);
   c=mpv/py;
   Y(i,:)=c*Y(i,:);
end

X=(P'*Y+mX);

r=(w*w+1)/2;
I=X(r,1);
return;