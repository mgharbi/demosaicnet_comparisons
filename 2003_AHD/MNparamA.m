function [eL,eC] = MNparamA(X,Y)
% ****************************************************
% * Adaptive Homogeneity-Directed Demosaic Algorithm *
% ****************************************************
%   Designed by:  Keigo Hirakawa
%                 khirakawa1@udayton.edu
%
%   [epsilonL,epsilonC] = MNparamA(X,Y)
%         X        horizontally interpolated image
%         Y        vertically interpolated image
%
%   MNparamA extracts epsilonL and epsilonC parameter from 
%   the scene.
%
%   This algorithm was developed according to Hirakawa's master's 
%   thesis.
%

%  epsilon = min(max(left,right),max(top,bottm))

eL = min(max(abs(conv2(X(:,:,1),[1,-1,0],'same')),abs(conv2(X(:,:,1),[0,-1,1],'same'))),max(abs(conv2(Y(:,:,1),[0;-1;1],'same')),abs(conv2(Y(:,:,1),[1;-1;0],'same'))));
eC = min(max(conv2(X(:,:,2),[1,-1,0],'same').^2+conv2(X(:,:,3),[1,-1,0],'same').^2,conv2(X(:,:,2),[0,-1,1],'same').^2+conv2(X(:,:,3),[0,-1,1],'same').^2),max(conv2(Y(:,:,2),[0;-1;1],'same').^2+conv2(Y(:,:,3),[0;-1;1],'same').^2,conv2(Y(:,:,2),[1;-1;0],'same').^2+conv2(Y(:,:,3),[1;-1;0],'same').^2));

eL = eL;
eC = eC.^0.5;