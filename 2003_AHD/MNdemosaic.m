function [Y] = MNdemosaic(X,delta)
% ****************************************************
% * Adaptive Homogeneity-Directed Demosaic Algorithm *
% ****************************************************
%   Designed by:  Keigo Hirakawa
%                 khirakawa1@udayton.edu
%
%   Y = MNdemosaic(X,delta)
%         X        RGB mosaic image, ranges 0~255
%         delta    ball set size
%
%   Files: MNdemosaic    main algorithm
%          MNrgb2lab     color space conversion
%          MNdemosaicX   horizontal interpolator
%          MNdemosaicY   vertical interpolator
%          MNartifact    reduce interpolation artifacts
%          MNparamA      adaptive parameter calculation
%          MNballset     returns convolution filters defining ball set
%          MNhomogeneity homogeneity map calculation
%
%   This algorithm was developed according to Hirakawa's master's 
%   thesis.
%

% internal variables
%iterations = 0;    % number of post-processing iterations
iterations = 2;    % number of post-processing iterations
gamma      = 1;    % level of red/blue pixels influencing green
                   
fprintf(1,'****************************************************\n');
fprintf(1,'* Adaptive Homogeneity-Directed Demosaic Algorithm *\n');
fprintf(1,'****************************************************\n');
fprintf(1,'      Designed by Keigo Hirakawa, September 2002    \n\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'filtering...                        ');

X = MNpad(X,10);
Yx = MNdemosaicX(X,gamma); % horizontal interpolation
Yy = MNdemosaicY(X,gamma); % vertical interpolation

clear X
fprintf(1,'done!\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'Lab convert...                      ');

YxLAB = MNrgb2lab(Yx); % convert into LAB
YyLAB = MNrgb2lab(Yy); % convert into LAB

fprintf(1,'done!\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'calculating parameters...           ');

[epsilonL,epsilonC] = MNparamA(YxLAB,YyLAB);         % adaptive parameter

fprintf(1,'done!\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'calculating homogeneity...          ');

[Hx] = MNhomogeneity(YxLAB,delta,epsilonL,epsilonC); % homogeneity
[Hy] = MNhomogeneity(YyLAB,delta,epsilonL,epsilonC);

Hx = conv2(Hx,ones([3 3]),'same');                   % spatial averaging
Hy = conv2(Hy,ones([3 3]),'same');

clear epsilonL epsilonC YxLAB YyLAB;
fprintf(1,'done!\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'selecting direction...              ');

% set output initially to Yx 
R  = Yx(:,:,1); G  = Yx(:,:,2); B  = Yx(:,:,3);
Ry = Yy(:,:,1); Gy = Yy(:,:,2); By = Yy(:,:,3);

% set output to Yy if Hy>=Hx
R(Hy>=Hx) = Ry(Hy>=Hx);
G(Hy>=Hx) = Gy(Hy>=Hx);
B(Hy>=Hx) = By(Hy>=Hx);

clear Hx Hy Ry Gy By Yx Yy
fprintf(1,'done!\n');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf(1,'reducing interpolation artifacts... ');

[R,G,B]=MNartifact(R,G,B,iterations); % find R and B values

Y = zeros([size(R) 3]);
Y(:,:,1) = R;
Y(:,:,2) = G;
Y(:,:,3) = B;

Y = clip(Y,0,255);
Y = MNpad(Y,-10);

clear R G B;
fprintf(1,'done!\n\n');

% internal function
function [Y] = clip(X,lo,hi)
Y = X;
Y(X<lo)=lo;
Y(X>hi)=hi;
