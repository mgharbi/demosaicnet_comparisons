function [K] = MNhomogeneity(X,delta,epsilonL,epsilonC)
% ****************************************************
% * Adaptive Homogeneity-Directed Demosaic Algorithm *
% ****************************************************
%   Designed by:  Keigo Hirakawa
%                 khirakawa1@udayton.edu
%
%   K = MNhomogeneity(X,delta,epsilonL,epsilonC)
%         X        LAB color image
%         delta    ball size
%         epsilonL level set tolerance
%         epsilonC color set tolerance
%         K        homogeneity map
%
%   MNhomogeneity returns the homogeneity map of the image X.  The
%   parameters epsilonL, epsilonC may be a single value or
%   adaptive.
%
%   This algorithm was developed according to Hirakawa's master's 
%   thesis.
%

index = ceil(delta);
H = MNballset(delta);

epsilonC_sq = epsilonC.^2;
K = zeros([size(X,1) size(X,2)]);

for i=1:size(H,3)
    L   = abs(conv2(X(:,:,1),H(:,:,i),'same')-X(:,:,1))<=epsilonL;                                                       % level set
    C   = ((conv2(X(:,:,2),H(:,:,i),'same')-X(:,:,2)).^2+(conv2(X(:,:,3),H(:,:,i),'same')-X(:,:,3)).^2) <= epsilonC_sq;  % color set
    U   = C & L;                                                                                                         % metric neighborhood
    K   = K + U;                                                                                                         % homogeneity    
end



