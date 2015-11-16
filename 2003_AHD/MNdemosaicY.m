function [Y] = MNdemosaicY(X,gamma)
% ****************************************************
% * Adaptive Homogeneity-Directed Demosaic Algorithm *
% ****************************************************
%   Designed by:  Keigo Hirakawa
%                 khirakawa1@udayton.edu
%
%   MNdemosaicY interplates images in the vertical direction.
%   It is based on works by Adams.
%
%   This algorithm was developed according to Hirakawa's master's 
%   thesis.
%

% MNdemosaicY works exactly as MNemosaicX, just transposed.

R = X(:,:,1);
G = X(:,:,2);
B = X(:,:,3);

X = zeros([size(R') 3]);
X(:,:,1) = B'; % transpose
X(:,:,2) = G';
X(:,:,3) = R';

clear R G B;
X = MNdemosaicX(X,gamma); % apply MNdemosaicX

B = X(:,:,1);
G = X(:,:,2);
R = X(:,:,3);

Y = zeros([size(R') 3]);
Y(:,:,1) = R'; % transpose back
Y(:,:,2) = G';
Y(:,:,3) = B';
