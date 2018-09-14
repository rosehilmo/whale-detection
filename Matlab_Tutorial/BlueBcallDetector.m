%spectrogram cross-correlation: 
%Detecting blue whale calls
%Rose Wade

close all
clear all

%getfile=uigetfile('*.wav')

getfile='J28A BHZ.20120221T000001.0132.wav'

datein=[2012,02,21,02,00,00]; %MMDDYYYYHH

DayCorr=[];

time=datenum(datein);

for j=1:24
clf
SpecLength=60*5;


samprate=50;


tlim=[time time+SpecLength/(24*60*60)];


rngstart=datestr(tlim(1));
rngend=datestr(tlim(2));
figrng=[rngstart ' -- ' rngend(13:end)];


[data,fs]=audioread([getfile]);
finddots = regexp(getfile,'\.');
schar = finddots(1);
tstart = datenum([getfile(schar+7:schar+8) '-' getfile(schar+5:schar+6) '-' getfile(schar+1:schar+4) getfile(schar+10:end-4)],'dd-mm-yyyyHHMMSS.FFF');
sampint = 1/fs;
nsamp = length(data);
times = tstart:sampint/86400:tstart + ((nsamp-1)*sampint/86400);
data = data-mean(data); data = data';

p.times = times;
p.data = data;
p.fs = fs;

tStart=find(p.times>=tlim(1),1); %tStart is time lower limit 'time'
tEnd=find(p.times<tlim(2),1,'last'); %tEnd is time upper limit 1 hr after 'time'

call.time=p.times(tStart:tEnd); %creates new matrices between limits
call.data=p.data(tStart:tEnd);

% %filtering parameters
% filtParam.type = 'high';
% filtParam.cut = 5;
% filtParam.order = 4;
% filtParam.phase = 'zero';
% samprate=p.fs;
% 
% [datafilt]=trace_filter(call.data(:),filtParam,samprate); %filters data
% 
% 

%   plot butterworth bandpass filter signal
%filtering parameters
filtParam.type = 'high';
filtParam.cut = 8;
filtParam.order =2;
filtParam.phase = 'zero';
samprate=p.fs;

%[datafilt]=trace_filter(call.data(:),filtParam,samprate); %filters data

[b,a]=butter(4,0.3,'high');
datafilt=filter(b,a,call.data(:));

set(0,'currentfigure',figure(18)); %makes figure 1 the location of the spectrogram
clf(figure(18));

%plot wavelet denoised signal on top
ax(1)=subplot(311);                            %for some reason matlab was not
plot(call.time,datafilt,'ko','markersize',.01);  %plotting the line correctly
axis tight;                                 %plotting first with markers fixed it
hold on;
plot(call.time,datafilt,'k-');
set(ax(1),'xticklabel',[]);
set(ax(1),'xtick',[]);
title(['Blue whale B call cross-correlation ' figrng ' ' getfile(1:5)]);

%plot spectrogram belowfile:///usr/local/MATLAB/R2015b/help/signal/ref/hann.html#zmw57dd0e65538
ax(2)=subplot(312);
  [ S,F,T,P ] = spectrogram(datafilt,2*samprate,round(1.8*samprate),2.^ceil(log2(2*samprate)),...
        samprate);


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

call.S=S;
call.F=F;

call.T=T;
hold on

%%
if exist('BlueKernel') == 0
[BlueKernel]=makeBlueKernel(samprate,samprate/(2*length(F)-1),SpecLength/(length(T)-1));
end

padding1=zeros(size(BlueKernel));
Spad1=[padding1 Pow-medmat padding1];
kSize1=size(BlueKernel);
sSize1=size(Spad1);
Size1=size(S);



for j=1:sSize1(2)-kSize1(2)+1
    
    corVal1(j)=sum(sum(BlueKernel.*Spad1(:,j:j+kSize1(2)-1)));
  
end


cropWin1=(length(corVal1)-Size1(2))/2;
corVal1a=corVal1(cropWin1+1:end-cropWin1);



corValtotal=corVal1a;
corValtotal=abs(corValtotal);

% inds=find(corValtotal < 0);
% corValtotal(inds)=0;

DayCorr=[DayCorr corValtotal];

figure(18)
ax(3)=subplot(313)
plot(T,corValtotal);
hold on
plot([min(T) max(T)],[1000 1000])
xlabel('seconds')
ylabel('Xcorrelation value')
axis tight
pause;


time=time+5/(24*60);
end



