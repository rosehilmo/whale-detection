%%%%%%%%this code creates a synthetic blue whale call spectrogram to use in
%%%%%%%%spectrogram cross correlation to automatically detect blue whale
%%%%%%%%calls

function [BlueKernel]=makeKernel(fs,freq,window);

%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

f0=15.7;
f1=14.4;
bndwth=.5;
dur=10;

%%%%%%%%END%PARAMETERS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


t=[0:window:dur];
fvec=[0:freq:fs/2].';


Kdist1seg=[];
Xdist=[];
for j=1:length(t);
    
    
x=fvec-(f0+(t(j)./dur).*(f1-f0));
Kval=(1-(x.^2)./(bndwth.^2)).*exp(-(x.^2)./(2.*bndwth.^2));

Kdist1seg=[Kdist1seg Kval];
Xdist=[Xdist x];
end

Kdist1=Kdist1seg;



BlueKernel=Kdist1;



figure(1)

imagesc([0 dur],[fs/2 0],flipud(BlueKernel))

ax=gca
ax.YDir='normal'
xlabel('seconds')
ylabel('Frequency (Hz)')
axis image;
colorbar
title('Blue Whale Kernel')
%save('/burr1/CI/matlab/CrossCorrelator/BlueKernel.mat','BlueKernel')
end

