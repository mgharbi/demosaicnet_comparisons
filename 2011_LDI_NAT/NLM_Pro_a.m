function g = NLM_Pro_a(Tc,TN,w,W)

%%%Non-local enhancement

%%%1. Format the data

N=W-w+1;
L=N*N;

%%%%%
X=zeros(w*w,L);
Tc=Tc';Tc=Tc(:);
Tc=repmat(Tc,1,L);
%%%%%

k=0;
for i=1:w
   for j=1:w
      k=k+1;
      t=TN(i:W-w+i,j:W-w+j);
      t=t(:);
      X(k,:)=t';
   end
end

%%%2. NL neighbors grouping
E=abs(X-Tc).^1; mE=mean(E);
[val,ind]=sort(mE);

%%%%%%%%
th=10;
ind1=find(val<th);
n1=length(ind1);
max=20;
min=10;
if n1>max
   X=X(:,ind(1:max));
   mE=mE(ind(1:max));
elseif n1<min
   X=X(:,ind(1:min));
   mE=mE(ind(1:min));
else
   X=X(:,ind(1:n1));
   mE=mE(ind(1:n1));
end

%mE

%%%3. Enhancement by fusion
sigma=2.5;
f=exp(-mE/sigma);

r=(w*w+1)/2;
X=X(r,:);
f=f/sum(f);
g=sum(X.*f);
return;
