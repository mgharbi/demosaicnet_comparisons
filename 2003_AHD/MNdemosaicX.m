function [Y] = MNdemosaicX(X,gamma)
% ****************************************************
% * Adaptive Homogeneity-Directed Demosaic Algorithm *
% ****************************************************
%   Designed by:  Keigo Hirakawa
%                 khirakawa1@udayton.edu
%
%   Y = MNdemosaicX(X,gamma)
%         X        RGB mosaic image, ranges 0~255
%         gamma    limits the level of contribution from R and B
%                  to interpolate G.  Default is 1.
%
%   MNdemosaicX interplates images in the horizontal direction.
%   It is based on works by Adams.
%
%   This algorithm was developed according to Hirakawa's master's 
%   thesis.
%

Y   = zeros(size(X));
X   = sum(X,3);

% masks for Bayer pattern
Mr  = zeros(size(X)); Mr(1:2:end,2:2:end) = 1;   % 0:not red,  1:red
Mb  = zeros(size(X)); Mb(2:2:end,1:2:end) = 1;   % 0:not blue, 1:blue
Mg1 = zeros(size(X)); Mg1(1:2:end,1:2:end) = 1;  % 0: not G1,  1:G1
Mg2 = zeros(size(X)); Mg2(2:2:end,2:2:end) = 1;  % 0: not G2,  1:G2

% green
Hg = [0 1/2 0 1/2 0] + [-1/4  0 1/2 0 -1/4]*gamma;
G = (Mg1+Mg2).*X + (Mb+Mr).*conv2(X,Hg,'same');

% red/blue
Hr = [1/4 1/2 1/4; 1/2 1 1/2; 1/4 1/2 1/4];
R = G+conv2(Mr.*(X-G),Hr,'same');
B = G+conv2(Mb.*(X-G),Hr,'same');

Y(:,:,1) = R;
Y(:,:,2) = G;
Y(:,:,3) = B;

Y = clip(Y,0,255);

% internal function
function [Y] = clip(X,lo,hi)
Y = X;
Y(X<lo)=lo;
Y(X>hi)=hi;