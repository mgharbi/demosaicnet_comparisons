function [Y]=MNmosaic(X)

if size(X,3) == 3
    
    Y=zeros(size(X));
    
    Y(1:2:end,2:2:end,1)=X(1:2:end,2:2:end,1); % Red
    Y(1:2:end,1:2:end,2)=X(1:2:end,1:2:end,2); % Green
    Y(2:2:end,2:2:end,2)=X(2:2:end,2:2:end,2); % Green
    Y(2:2:end,1:2:end,3)=X(2:2:end,1:2:end,3); % Blue
    
else

    Y = zeros([size(X) 3]);
    
    Y(1:2:end,2:2:end,1)=X(1:2:end,2:2:end); % Red
    Y(1:2:end,1:2:end,2)=X(1:2:end,1:2:end); % Green
    Y(2:2:end,2:2:end,2)=X(2:2:end,2:2:end); % Green
    Y(2:2:end,1:2:end,3)=X(2:2:end,1:2:end); % Blue
    
end
