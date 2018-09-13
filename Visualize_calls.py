# Python review: More exercises

#Vizualize blue whales calls recorded on an ocean bottom seismometer in both 
#the time and frequency domains.

wavefile_name = 'newStrongCalls.wav'
import wave
import scipy
import os
import scipy.io.wavfile as siow
import numpy as np
import matplotlib.pyplot as plt
import scipy.signal as sig
import wget

os.chdir('/Users/wader/Geohackweek/Wade_Project522/whale-detection')

[samp, data] = siow.read(wavefile_name, mmap=False)

datalength = data.size
times = np.arange(datalength)/samp

plt.figure(1, figsize=(9, 3))
plt.subplot(211)
plt.plot(times[10:],data[10:])
plt.axis([0, 300, min(data[10:]), max(data[10:])])
plt.xlabel('Seconds')
plt.ylabel('Amplitude')

[f, t, Sxx] = sig.spectrogram(data, samp, 'hann',samp*2,samp*1)
plt.subplot(212)
plt.pcolormesh(t, f, Sxx)
plt.ylabel('Frequency [Hz]')
plt.xlabel('Time [sec]')
plt.plot()

