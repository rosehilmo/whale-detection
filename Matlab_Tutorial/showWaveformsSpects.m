clear all


[pickfiles pickfolders]=uigetfile('*.wav');

data=audioread([pickfolders pickfiles]);

fs=50;

times=[0:1/50:length(data)/50];

times=times(1:end-1);

figure
ax(1)=subplot(211)
plot(times,data,'k-')
axis tight
xlabel('seconds');
ylabel('amplitude')
title('Blue Whale B Calls, waveform')

ax(2)=subplot(212)
[ S,F,T,P ] = spectrogram(data,2*fs,round(1.8*fs),2.^ceil(log2(2*fs)),fs);


Pow = 20*log10(P);
medP = median(Pow,2);
medmat = repmat(medP,1,length(T));

imagesc(T,F,Pow-medmat)
axis xy;
%axis image;
caxis([0 30]);
%ylim([10 25]);
set(ax(2),'XMinorTick','on');
set(ax(2),'TickDir','out');
colormap winter;
title('Blue Whale B Calls, spectrogram')
xlabel('seconds')
ylabel('frequency')
