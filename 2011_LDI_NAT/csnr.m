function snr=csnr(A,B)

[n,m,c]=size(A);

if c==1
   e=A-B;
   pe=mean(mean(e.^2));
   snr=10*log10(255^2/pe);

else
   
e=A-B;

er(:,:)=e(:,:,1);
eg(:,:)=e(:,:,2);
eb(:,:)=e(:,:,3);
%%%%compute psnr%%%%%%%%%%%%%%%%%%%%
pe=mean(mean(er.^2));
snr(1)=10*log10(255^2/pe);
pe=mean(mean(eg.^2));
snr(2)=10*log10(255^2/pe);
pe=mean(mean(eb.^2));
snr(3)=10*log10(255^2/pe);
end

return;