function [H] = MNballset(delta)
% ****************************************************
% * Adaptive Homogeneity-Directed Demosaic Algorithm *
% ****************************************************
%   Designed by:  Keigo Hirakawa
%                 khirakawa1@udayton.edu
%
%   [H] = MNballset(delta)
%           delta   size of the ball set
%           H       NxNxm matrix, where H(:,:,i) is a convolution
%                   filter representing the pixel location
%
%   MNballset returns a set of convolution filters describing 
%   the relative locations in the elements of the ball set.
%
%   This algorithm was developed according to Hirakawa's master's 
%   thesis.
%

index = ceil(delta);
H = zeros([index*2+1 index*2+1 (index*2+1)^2]); % initialize

k = 1;
for i=-index:index
    for j=-index:index
        if (norm([i;j])<=delta)
            H(index+1+i,index+1+j,k)= 1; % included
            k = k+1;
        end
    end
end
H = H(:,:,1:(k-1));
