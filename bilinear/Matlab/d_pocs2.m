%
% d_pocs -> Demosaicing Using Alternating Projections
%		d_pocs simulates the projections onto convex sets (POCS) based demosaicing algorithm. 
%
%		[out_pocs, t] = d_pocs2(X, N_iter)
%		X 					-> Bayer sampled mosaic
%		N_iter				-> Number of iterations
%		out_pocs			-> Interpolated image using the POCS algorithm
%       t                   -> Running time (in seconds)


% For details, please refer to the paper:
%  	Color plane interpolation using alternating projections 
%		Gunturk, B.K.; Altunbasak, Y.; Mersereau, R.M. 
%		Image Processing, IEEE Transactions on , Volume: 11 Issue: 9 , Sept 2002 
%		Page(s): 997 -1013
%
%
% Bahadir K. Gunturk
% Department of Electrical and Computer Engineering
% Louisiana State University
% Email: bahadir@ece.lsu.edu
% URL  : http://www.ece.lsu.edu/~bahadir

% Modified by Yue M. Lu
% 02-27-2009
% (See d_pocs.m in DemosaicingUsingPOCS for the original version.)
%
% Modifications:
%
% 1. Add the recording of the running time (t)
% 2. Streamlined certain parts of the original code to make it run faster


function [out_pocs, t] = d_pocs2(X, N_iter)

% G R
% B G

tic

%%%%% Initial interpolation of the color channels
RGB = double(interp_edgeG(X));

%%%%% Initial Red, green, and blue channel assignments
R = RGB(:,:,1); 
G = RGB(:,:,2); 
B = RGB(:,:,3); 

%%%%% Filters that will be used in subband decomposition 
h0 = [1 2 1]/4;
h1 = [1 -2 1]/4;
g0 = [-1 2 6 2 -1]/8;
g1 = [1 2 -6 2 1]/8;

%%%% Update Green channel
Rd = X(1:2:end,2:2:end); 
Bd = X(2:2:end,1:2:end);
Gd_R = RGB(1:2:end,2:2:end,2);
Gd_B = RGB(2:2:end,1:2:end,2);
%
[CA_Rr,CH_Rr,CV_Rr,CD_Rr] = rdwt2(Rd,h0,h1);
[CA_Gr,CH_Gr,CV_Gr,CD_Gr] = rdwt2(Gd_R,h0,h1); 
[CA_Bb,CH_Bb,CV_Bb,CD_Bb] = rdwt2(Bd,h0,h1);
[CA_Gb,CH_Gb,CV_Gb,CD_Gb] = rdwt2(Gd_B,h0,h1); 
%
Gd_R = ridwt2(CA_Gr, CH_Rr, CV_Rr, CD_Rr, g0,g1);
Gd_B = ridwt2(CA_Gb, CH_Bb, CV_Bb, CD_Bb, g0,g1);
%
G(1:2:end,2:2:end) = Gd_R;  
G(2:2:end,1:2:end) = Gd_B;

G(G < 0) = 0;
G(G > 255) = 255;

%%%%% Alternating projections algorithm starts here
[CA_G,CH_G,CV_G,CD_G] = rdwt2(G,h0,h1);

for iter=1:N_iter, % iterate
           
   %%%%% DETAIL PROJECTION
   
   %%%%% Decompose into subbands 
   [CA_R,CH_R,CV_R,CD_R] = rdwt2(R,h0,h1);
   
   [CA_B,CH_B,CV_B,CD_B] = rdwt2(B,h0,h1);

   %%%%% Update detail subbands of R and B  
   %%%
   %%%%% Reconstruct back from subbands
   R = ridwt2(CA_R, CH_G, CV_G, CD_G, g0, g1);
   B = ridwt2(CA_B, CH_G, CV_G, CD_G, g0, g1);
   
   
   %%%%% OBSERVATION PROJECTION
   
   %%%%% Make sure that R and B channels obey the data 
   R(1:2:end,2:2:end) = X(1:2:end,2:2:end); 
   B(2:2:end,1:2:end) = X(2:2:end,1:2:end); 
   
      
end;


%%%%% Output the image...
out_pocs(:,:,1) = R;
out_pocs(:,:,2) = G;
out_pocs(:,:,3) = B;

out_pocs(out_pocs < 0) = 0;
out_pocs(out_pocs > 255) = 255;

t = toc;


%%%%% NOTES
% ---------
% 1. Convolution of the channels with the filters may create artifacts along the borders. 
%    I recommend to replace the borders with the bilinearly interpolated
%    (or another interpolation) data.
%
% ---------
%% 2. Second-level decomposition can be done as follows: 
% %%%%% Second-level decomposition 
% hh0 = dyadup(h0,2);
% hh1 = dyadup(h1,2);
% gg0 = dyadup(g0,2);
% gg1 = dyadup(g1,2);
% %
% [CAA_R, CHH_R, CVV_R, CDD_R] = rdwt2(CA_R, hh0, hh1);
% [CAA_G, CHH_G, CVV_G, CDD_G] = rdwt2(CA_G, hh0, hh1);
% [CAA_B, CHH_B, CVV_B, CDD_B] = rdwt2(CA_B, hh0, hh1);
% %
% CA_R = ridwt2(CAA_R, CHH_G, CVV_G, CDD_G, gg0, gg1);
% CA_G = ridwt2(CAA_G, CHH_G, CVV_G, CDD_G, gg0, gg1);
% CA_B = ridwt2(CAA_B, CHH_G, CVV_G, CDD_G, gg0, gg1);
% %
% ---------

