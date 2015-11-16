%% Demo of LDI-NAT algorithm for CDM
% L. Zhang, X. Wu, A. Buades, and X. Li, 
% "Color Demosaicking by Local Directional Interpolation and Non-local Adaptive Thresholding," 
% in Journal of Electronic Imaging, 2011.

%% The code is not optimized so that it runs a little slow. 

clear;
I=imread('1.tif','tif');
I=double(I);
[n,m,c]=size(I);

figure(1),clf;
imshow(I/255);

A=zeros(n,m);
A=I(:,:,2);
A(1:2:n,2:2:m)=I(1:2:n,2:2:m,1);
A(2:2:n,1:2:m)=I(2:2:n,1:2:m,3);

%%% CDM by the LDI-NAT algorithm %%%
G=nat_cdm(A);
snr_nat=csnr(G(21:n-20,21:m-20,:),I(21:n-20,21:m-20,:))

figure(2),clf;
imshow(G/255);

%%% CDM by the LDI-NLM algorithm %%%
G=nlm_cdm(A);
snr_nlm=csnr(G(21:n-20,21:m-20,:),I(21:n-20,21:m-20,:))

figure(3),clf;
imshow(G/255);
