# %% [markdown]
# ## Some technical notes about audio parameters
# 
# - `sample width`: Number of bytes used to store a sample
# - `channels`: Numbers of channels, 1 (mono) or 2 (stereo)
# - 
# 

# %%
import numpy as np
from scipy.io import wavfile
import wave
import pyaudio
from matplotlib import pyplot as plt


a_avancar, a_esquerda, a_direita, a_parar, a_recuar = (np.empty(10) for _ in range(5))

p = pyaudio.PyAudio()

plt.plot()


for command in ('avancar', 'direita', 'esquerda', 'parar', 'recuar'):
    for n in range(1,11):
        # Fs, s = wavfile.read(f'./Audio_files_TCC_Jefferson/comando_{command}_{n:0>2d}.wav')
        s = wave.open(f'./Audio_files_TCC_Jefferson/comando_{command}_{n:0>2d}.wav', 'rb')
        # number of samples
        # N = s.shape[0]


