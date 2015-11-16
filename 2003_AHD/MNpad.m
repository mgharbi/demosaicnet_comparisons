function [Y] = MNPad(X,n)

if n>0
    m=min(size(X,1),size(X,2))-1;
    if n>m
        Y = MNPad(X,m);
        Y = MNPad(Y,n-m);
    else 
        Y = [X(n+1:-1:2,n+1:-1:2,:)       X(n+1:-1:2,:,:)        X(n+1:-1:2,end-1:-1:end-n,:)
            X(:,n+1:-1:2,:)               X                      X(:,end-1:-1:end-n,:)
            X(end-1:-1:end-n,n+1:-1:2,:)  X(end-1:-1:end-n,:,:)  X(end-1:-1:end-n,end-1:-1:end-n,:)];
    end
end

if n<0
    n=-n;
    Y = X(n+1:end-n,n+1:end-n,:);
end