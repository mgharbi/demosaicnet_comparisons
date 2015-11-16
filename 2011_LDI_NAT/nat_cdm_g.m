function G=nat_cdm_g(A)

[N,M,ch]=size(A);

%%%%%%%%%%%% recover G channel %%%%%%%%%%%%%%
G=A;

%%% initial interpolation

%%% at a red pixel
for i=5:2:N-4
   for j=6:2:M-5
      %%calculate G-R along 4 directions
      d_n=A(i-1,j)-(A(i-2,j)+A(i,j))/2;%%north
      d_s=A(i+1,j)-(A(i+2,j)+A(i,j))/2;%%south
      d_w=A(i,j-1)-(A(i,j-2)+A(i,j))/2;%%west
      d_e=A(i,j+1)-(A(i,j+2)+A(i,j))/2;%%east
      
      %%calculate the gradient     
      g_n=abs(A(i-2,j)-A(i,j))+abs(A(i-1,j)-A(i+1,j))+abs(A(i-2,j-1)-A(i,j-1))/2+abs(A(i-2,j+1)-A(i,j+1))/2+0.1;%%north
      g_s=abs(A(i+2,j)-A(i,j))+abs(A(i-1,j)-A(i+1,j))+abs(A(i+2,j-1)-A(i,j-1))/2+abs(A(i+2,j+1)-A(i,j+1))/2+0.1;%%south
      g_w=abs(A(i,j-2)-A(i,j))+abs(A(i,j-1)-A(i,j+1))+abs(A(i-1,j-2)-A(i-1,j))/2+abs(A(i+1,j-2)-A(i+1,j))/2+0.1;%%west
      g_e=abs(A(i,j+2)-A(i,j))+abs(A(i,j-1)-A(i,j+1))+abs(A(i-1,j+2)-A(i-1,j))/2+abs(A(i+1,j+2)-A(i+1,j))/2+0.1;%%east

      %%weighting along vertical and horizontal direction
      g=[g_n g_s g_w g_e];
      w=1./g;
      w=w/sum(w);
      
      d=[d_n d_s d_w d_e];
      d=sum(d.*w);
      
      %% interpolate G %%%
      G(i,j)=A(i,j)+d;
   end
end
%%% at a blue pixel
for i=6:2:N-5
   for j=5:2:M-4
      %%calculate G-B along 4 directions
      d_n=A(i-1,j)-(A(i-2,j)+A(i,j))/2;%%north
      d_s=A(i+1,j)-(A(i+2,j)+A(i,j))/2;%%south
      d_w=A(i,j-1)-(A(i,j-2)+A(i,j))/2;%%west
      d_e=A(i,j+1)-(A(i,j+2)+A(i,j))/2;%%east
      
      %%calculate the gradient    
      g_n=abs(A(i-2,j)-A(i,j))+abs(A(i-1,j)-A(i+1,j))+abs(A(i-2,j-1)-A(i,j-1))/2+abs(A(i-2,j+1)-A(i,j+1))/2+0.1;%%north
      g_s=abs(A(i+2,j)-A(i,j))+abs(A(i-1,j)-A(i+1,j))+abs(A(i+2,j-1)-A(i,j-1))/2+abs(A(i+2,j+1)-A(i,j+1))/2+0.1;%%south
      g_w=abs(A(i,j-2)-A(i,j))+abs(A(i,j-1)-A(i,j+1))+abs(A(i-1,j-2)-A(i-1,j))/2+abs(A(i+1,j-2)-A(i+1,j))/2+0.1;%%west
      g_e=abs(A(i,j+2)-A(i,j))+abs(A(i,j-1)-A(i,j+1))+abs(A(i-1,j+2)-A(i-1,j))/2+abs(A(i+1,j+2)-A(i+1,j))/2+0.1;%%east

      %%weighting along vertical and horizontal direction
      g=[g_n g_s g_w g_e];
      w=1./g;
      w=w/sum(w);
      
      d=[d_n d_s d_w d_e];
      d=sum(d.*w);
      
      %% interpolate G %%%
      G(i,j)=A(i,j)+d;
  end
end

%%%non-local processing
G=NAT_G_pca_2(G);

