function [Y]=MNrgb2lab(X)
% ****************************************************
% * Adaptive Homogeneity-Directed Demosaic Algorithm *
% ****************************************************
%   Designed by:  Keigo Hirakawa
%                 khirakawa1@udayton.edu
%
%   Y = MNrgb2lab(X)
%         X    RGB image
%         Y    LAB image, Y(:,:,1)=L, Y(:,:,2)=a, Y(:,:,3)=b
%
%   This algorithm was developed according to Hirakawa's master's 
%   thesis.
%

a = [
    3.40479 -1.537150 -0.498535
    -0.969256 1.875992 0.041556
    0.055648 -0.204043 1.057311];
ai = inv(a); % color space conversion into XYZ

p = ai*[reshape(X(:,:,1),1,size(X,1)*size(X,2));reshape(X(:,:,2),1,size(X,1)*size(X,2));reshape(X(:,:,3),1,size(X,1)*size(X,2))];

% color space conversion into LAB
Y = zeros(size(X));
Y(:,:,1)=116*f(reshape(p(2,:),size(X,1),size(X,2))/255)-16;
Y(:,:,2)=500*(f(reshape(p(1,:),size(X,1),size(X,2))/255)-f(reshape(p(2,:),size(X,1),size(X,2))/255));
Y(:,:,3)=200*(f(reshape(p(2,:),size(X,1),size(X,2))/255)-f(reshape(p(3,:),size(X,1),size(X,2))/255));

% internal function
function d=f(t)
d = t.^(1/3);
d(t<=0.008856)=7.787*t(t<=0.008856)+16/116;
