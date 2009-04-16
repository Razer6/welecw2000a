clear s;
s.uart = 'com7';
s.baudrate = 115200;
s.channels = 2;
s.bits = 16;
s.fs = 10000;
s.aacstart = 0;
s.aacend = 0;
s.ch = [0 1 2 3];
s.TrType = 0;
s.TrPrSamples = 3;
s.TrCh = 0;
s.TrLowRef = -16;
s.TrHighRef = 16;
s.TrLowSt = 1;
s.TrHighSt = 1;
s.AnGainCh = [ 10000 10000 10000 10000 ];
s.An_OffCh = [ 100 100 100 100 ];
s.An_Offset2 = -100;
s.AnSrc2Ch1 = 'open';
s.AnSrc2Ch2 = 'open';
s.AnSrc2Ch3 = 'open';
s.AnSrc2Ch4 = 'open';
s.CapWaitTime = 10000;
s.CapSize = 2^15;
s.WavForcefs = 0;
s.WaveFile = 'recorded.wav';

%SetScope(uart,baud,'TriggerInput',channels,bits,10000,0,4,[0 1 2 3])
SetScope(s)
