function I=nat_cdm(A)

%%%%% The demosaicing of input data A
%%%     A--The input mosaic image, Bayer Pattern as follows
%%%     G(0,0) R G R...
%%%     B      G B G...
%%%   If A is a full color image, it will be downsampled according to Bayer pattern

[N,M,ch]=size(A);
if ch==3
    B=zeros(N,M);
    B(1:2:N,1:2:M)=A(1:2:N,1:2:M,2);
    B(2:2:N,2:2:M)=A(2:2:N,2:2:M,2);
    B(1:2:N,2:2:M)=A(1:2:N,2:2:M,1);
    B(2:2:N,1:2:M)=A(2:2:N,1:2:M,3);
    A=B;
    clear B;
end

%%%%%%%%%%%% recover G channel %%%%%%%%%%%%%%
G=nat_cdm_g(A);

%%%%%%%%%% recover R and B %%%%%%%%%%
R=A; B=A;
%%%1. at a red pixel, recover B
for i=5:2:N-4
   for j=6:2:M-5
       %%calculate B-G along 4 directions
       d_tl=B(i-1,j-1)-G(i-1,j-1);%%top left
       d_tr=B(i-1,j+1)-G(i-1,j+1);%%top right
       d_bl=B(i+1,j-1)-G(i+1,j-1);%%bottom left
       d_br=B(i+1,j+1)-G(i+1,j+1);%%bottom right
       %%calculate the gradient
       g_tl=abs(R(i-2,j-2)-R(i,j))+abs(B(i-1,j-1)-B(i+1,j+1))+0.1+abs(G(i-1,j-1)-G(i,j));%%top left
       g_tr=abs(R(i-2,j+2)-R(i,j))+abs(B(i-1,j+1)-B(i+1,j-1))+0.1+abs(G(i-1,j+1)-G(i,j));%%top right
       g_bl=abs(R(i+2,j-2)-R(i,j))+abs(B(i+1,j-1)-B(i-1,j+1))+0.1+abs(G(i+1,j-1)-G(i,j));%%bottom left
       g_br=abs(R(i+2,j+2)-R(i,j))+abs(B(i+1,j+1)-B(i-1,j-1))+0.1+abs(G(i+1,j+1)-G(i,j));%%bottom right
       %%weighting
       g=[g_tl g_tr g_bl g_br];
       w=1./g;
       w=w/sum(w);
       
       d=[d_tl d_tr d_bl d_br];
       d=sum(d.*w);
       
       %% interpolate B %%%
       B(i,j)=G(i,j)+d;
   end
end

%%%2. at a blue pixel, recover R
for i=6:2:N-5
   for j=5:2:M-4
       %%calculate R-G along 4 directions
       d_tl=R(i-1,j-1)-G(i-1,j-1);%%top left
       d_tr=R(i-1,j+1)-G(i-1,j+1);%%top right
       d_bl=R(i+1,j-1)-G(i+1,j-1);%%bottom left
       d_br=R(i+1,j+1)-G(i+1,j+1);%%bottom right
       %%calculate the gradient
       g_tl=abs(B(i-2,j-2)-B(i,j))+abs(R(i-1,j-1)-R(i+1,j+1))+0.1+abs(G(i-1,j-1)-G(i,j));%%top left
       g_tr=abs(B(i-2,j+2)-B(i,j))+abs(R(i-1,j+1)-R(i+1,j-1))+0.1+abs(G(i-1,j+1)-G(i,j));%%top right
       g_bl=abs(B(i+2,j-2)-B(i,j))+abs(R(i+1,j-1)-R(i-1,j+1))+0.1+abs(G(i+1,j-1)-G(i,j));%%bottom left
       g_br=abs(B(i+2,j+2)-B(i,j))+abs(R(i+1,j+1)-R(i-1,j-1))+0.1+abs(G(i+1,j+1)-G(i,j));%%bottom right
       %%weighting
       g=[g_tl g_tr g_bl g_br];
       w=1./g;
       w=w/sum(w);
       
       d=[d_tl d_tr d_bl d_br];
       d=sum(d.*w);
       
       %% interpolate R %%%
       R(i,j)=G(i,j)+d;
   end
end

%%%3. at a green pixel, recover R and B

for i=3:2:N-2
    for j=3:2:M-2
        %%calculate R-G and B-G
        dr_n=R(i-1,j)-G(i-1,j);%north
        dr_s=R(i+1,j)-G(i+1,j);%south
        dr_w=R(i,j-1)-G(i,j-1);%west
        dr_e=R(i,j+1)-G(i,j+1);%east
        
        db_n=B(i-1,j)-G(i-1,j);%north
        db_s=B(i+1,j)-G(i+1,j);%south
        db_w=B(i,j-1)-G(i,j-1);%west
        db_e=B(i,j+1)-G(i,j+1);%east
        
        %%calculate the gradient
                
        g_n=abs(A(i-2,j)-A(i,j))+abs(A(i-1,j)-A(i+1,j))+abs(A(i-2,j-1)-A(i,j-1))/2+abs(A(i-2,j+1)-A(i,j+1))/2+0.1;%%north
        g_s=abs(A(i+2,j)-A(i,j))+abs(A(i-1,j)-A(i+1,j))+abs(A(i+2,j-1)-A(i,j-1))/2+abs(A(i+2,j+1)-A(i,j+1))/2+0.1;%%south
        g_w=abs(A(i,j-2)-A(i,j))+abs(A(i,j-1)-A(i,j+1))+abs(A(i-1,j-2)-A(i-1,j))/2+abs(A(i+1,j-2)-A(i+1,j))/2+0.1;%%west
        g_e=abs(A(i,j+2)-A(i,j))+abs(A(i,j-1)-A(i,j+1))+abs(A(i-1,j+2)-A(i-1,j))/2+abs(A(i+1,j+2)-A(i+1,j))/2+0.1;%%east

        %%average
        g=[g_n g_s g_w g_e];
        w=1./g;
        w=w/sum(w);
        
        %%interpolate R and B
        dr=[dr_n dr_s dr_w dr_e];
        dr=sum(dr.*w);
        R(i,j)=G(i,j)+dr;
        
        db=[db_n db_s db_w db_e];
        db=sum(db.*w);
        B(i,j)=G(i,j)+db;
    end
end

for i=4:2:N-3
    for j=4:2:M-3
        %%calculate R-G and B-G
        dr_n=R(i-1,j)-G(i-1,j);%north
        dr_s=R(i+1,j)-G(i+1,j);%south
        dr_w=R(i,j-1)-G(i,j-1);%west
        dr_e=R(i,j+1)-G(i,j+1);%east
        
        db_n=B(i-1,j)-G(i-1,j);%north
        db_s=B(i+1,j)-G(i+1,j);%south
        db_w=B(i,j-1)-G(i,j-1);%west
        db_e=B(i,j+1)-G(i,j+1);%east
        
        %%calculate the gradient

        g_n=abs(A(i-2,j)-A(i,j))+abs(A(i-1,j)-A(i+1,j))+abs(A(i-2,j-1)-A(i,j-1))/2+abs(A(i-2,j+1)-A(i,j+1))/2+0.1;%%north
        g_s=abs(A(i+2,j)-A(i,j))+abs(A(i-1,j)-A(i+1,j))+abs(A(i+2,j-1)-A(i,j-1))/2+abs(A(i+2,j+1)-A(i,j+1))/2+0.1;%%south
        g_w=abs(A(i,j-2)-A(i,j))+abs(A(i,j-1)-A(i,j+1))+abs(A(i-1,j-2)-A(i-1,j))/2+abs(A(i+1,j-2)-A(i+1,j))/2+0.1;%%west
        g_e=abs(A(i,j+2)-A(i,j))+abs(A(i,j-1)-A(i,j+1))+abs(A(i-1,j+2)-A(i-1,j))/2+abs(A(i+1,j+2)-A(i+1,j))/2+0.1;%%east

        %%average
        g=[g_n g_s g_w g_e];
        w=1./g;
        w=w/sum(w);
        
        %%interpolate R and B
        dr=[dr_n dr_s dr_w dr_e];
        dr=sum(dr.*w);
        R(i,j)=G(i,j)+dr;
        
        db=[db_n db_s db_w db_e];
        db=sum(db.*w);
        B(i,j)=G(i,j)+db;
    end
end

R=NAT_R_pca_2(R);
B=NAT_B_pca_2(B);

I(:,:,3)=B;
I(:,:,1)=R;
I(:,:,2)=G;
