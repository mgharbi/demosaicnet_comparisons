function [R,G,B] = MNartifact(R,G,B,iteration)
% ****************************************************
% * Adaptive Homogeneity-Directed Demosaic Algorithm *
% ****************************************************
%   Designed by:  Keigo Hirakawa
%                 khirakawa1@udayton.edu
%
%   [R,G,B] = MNartifact(R,G,B,iteration)
%         R         red image
%         G         green image
%         B         blue image
%         iteration number of iteration to run the G-R/B 
%                   correction stage
%
%   MNartifact reduces interpolation (color) artifacts
%
%   This algorithm was developed according to Hirakawa's master's 
%   thesis.
%

% adjust R/B, then adjust G
for i=1:iteration
    R = G+median(cat(3,conv2(R-G,[1 0 0;0 0 0;0 0 0],'same'),conv2(R-G,[0 1 0;0 0 0;0 0 0],'same'),conv2(R-G,[0 0 1;0 0 0;0 0 0],'same'),conv2(R-G,[0 0 0;1 0 0;0 0 0],'same'),conv2(R-G,[0 0 0;0 0 1;0 0 0],'same'),conv2(R-G,[0 0 0;0 0 0;1 0 0],'same'),conv2(R-G,[0 0 0;0 0 0;0 1 0],'same'),conv2(R-G,[0 0 0;0 0 0;0 0 1],'same')),3);
    B = G+median(cat(3,conv2(B-G,[1 0 0;0 0 0;0 0 0],'same'),conv2(B-G,[0 1 0;0 0 0;0 0 0],'same'),conv2(B-G,[0 0 1;0 0 0;0 0 0],'same'),conv2(B-G,[0 0 0;1 0 0;0 0 0],'same'),conv2(B-G,[0 0 0;0 0 1;0 0 0],'same'),conv2(B-G,[0 0 0;0 0 0;1 0 0],'same'),conv2(B-G,[0 0 0;0 0 0;0 1 0],'same'),conv2(B-G,[0 0 0;0 0 0;0 0 1],'same')),3); 
    Gr = R+median(cat(3,conv2(G-R,[0 1 0;0 0 0;0 0 0],'same'),conv2(G-R,[0 0 0;1 0 0;0 0 0],'same'),conv2(G-R,[0 0 0;0 0 1;0 0 0],'same'),conv2(G-R,[0 0 0;0 0 0;0 1 0],'same')),3);
    Gb = B+median(cat(3,conv2(G-B,[0 1 0;0 0 0;0 0 0],'same'),conv2(G-B,[0 0 0;1 0 0;0 0 0],'same'),conv2(G-B,[0 0 0;0 0 1;0 0 0],'same'),conv2(G-B,[0 0 0;0 0 0;0 1 0],'same')),3);
    G = (Gr+Gb)/2;
end
