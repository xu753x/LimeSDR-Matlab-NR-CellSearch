if loadFromLms
    addpath('../_library') % add path with LimeSuite library

    % Initialize parameters
    TotalTime   = 0.04;       % Time of observation, s
    Fc          = 2.52495e9;   % Carrier Frequency, Hz   CMCC N78 SSB frequency
    %Fc          = 3.40896e9;   % Carrier Frequency, Hz  CUCC N78 SSB frequency
    Fs          = 30.72e6;      % Frequency of sampling frequency, Hz
    Ts          = 0.005;      % Signal duration, s
    %Fsig        = 0.5e0;    % Frequency of desired signal, Hz
    %Fdev        = 1e5;      % Frequency of deviation, Hz
    %Fif         = 2e5;      % Intermediate frequency, Hz
    %Asig        = 1;        % Amplitude of signal, V
    BW          = Fs;      % Bandwidth of the signal, Hz (5-40MHz and 50-130Mhz)
    Gain        = 35;       % Receiver Gain, dB

    % (1) Open a device handle:
    dev = limeSDR(); % Open device
    
    % (2) Setup device parameters. These may be changed while the device is actively streaming.
    dev.rx0.frequency   = Fc;
    dev.rx0.samplerate  = Fs;
    dev.rx0.bandwidth   = BW;
    dev.rx0.gain        = Gain;
    dev.rx0.antenna     = 1;     % 2 LNA_L,   1 LNA_H

    Fs_dev      = dev.rx0.samplerate;  % in SPS
    Fc_dev      = dev.rx0.frequency;
    BW_dev      = dev.rx0.bandwidth;
    Ant_dev     = dev.rx0.antenna;
    Gain_dev    = dev.rx0.gain;
    ChipTemp    = dev.chiptemp;
    fprintf('Rx Device sampling frequency: %3.1fHz, Initial sampling frequency: %3.1fHz\n', Fs_dev, Fs);
    fprintf('Rx Device carrier frequency: %3.1fHz, Initial carrier frequency: %3.1fHz\n', Fc_dev, Fc);
    fprintf('Rx Device bandwidth: %3.1fHz, Initial bandwith: %3.1fHz\n', BW_dev, BW);
    fprintf('Rx Device antenna: %d \n', Ant_dev);
    fprintf('Rx Device gain: %3.1fdB, Initial gain: %3.1fdB\n', Gain_dev, Gain);
    fprintf('Rx Device temperature: %3.1fC\n', ChipTemp);

    % (4) Create empty array for the received signal
    bufferRx    = complex(zeros(TotalTime*Fs,1));
    
    % (5) Enable stream parameters. These may NOT be changed while the device is streaming.
    dev.rx0.enable;
    
    % (6) Calibrate RX channel
    dev.rx0.calibrate;
    
    % (7) Start the module
    dev.start();
    fprintf('Start of LimeSDR\n');
    
    % (8) Receive samples on RX0 channel
    indRx = 1;  % index of the last received sample
    for idxLoop = 1:round(TotalTime/Ts)
        tic;
        [samples, ~, samplesLength]             = dev.receive(Fs*Ts,0);
        bufferRx(indRx:indRx+samplesLength-1)   = samples;
        indRx           = indRx + samplesLength;
        status          = dev.rx0.status;
        fprintf('Received samples: %d\n', samplesLength);
        fprintf('Fifo size: %d link rate %d\n', status.fifoFilledCount,status.linkRate);
        fprintf('underrun: %d overrun %d droppedPackets %d\n', status.underrun,status.overrun,status.droppedPackets);
    end
    pause(1)
    
    % (9) Cleanup and shutdown by stopping the RX stream and having MATLAB delete the handle object.
    dev.stop();
    clear dev;
    fprintf('Stop of LimeSDR\n');
    
    % (10) Plot spectrogram (Signal Processing Toolbox is required)
    %tic
    %figure(1)
    %spectrogram(bufferRx,2^12,2^10,2^12,'centered','yaxis')
    %fprintf('Time for visualisation: %g\n', toc);

    rxSampleRate = Fs;
    osf = 1;
    clear rxWaveform;
    %rxWaveform = resample(bufferRx,Fs,Fs*osf);
    rxWaveform = bufferRx;
end %end of loadFromLms