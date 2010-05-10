function [ success ] = SetScope(s)
% Interface to the Open Source Scope!
% Author: Alexander Lindert
% samplesize ... in bits
% fs        ... sampling frequence
% aacstart  ... filterstages enable start 0 => 1GS/s to 100 MS/s, 1 =>
%               100MS/s => 10 MS/s
% aacend    ... filterstages enable start
% ch        ... vector of channels for the trigger 
all = sprintf('WaveRecorder -p %s -u %s -b %d -n %d',s.protocol, s.uart,s.baudrate,s.channels);
cmd = sprintf('%s -c TriggerInput --SampleSize=%d --Fs=%d --AACStart=%d --AACEnd=%d --CH1=%d --CH2=%d --CH3=%d --CH4=%d', ...
    all, s.bits, s.fs, s.aacstart, s.aacend, s.ch(1), s.ch(2), s.ch(3), s.ch(4));               
disp(cmd); 
succ = system(cmd);
cmd = sprintf('%s -c Trigger --TrType=%d --TrPrSamples=%d --TrCh=%d --TrLowRef=%d --TrHighRef=%d --TrLowSt=%d --TrHighSt=%d', ...
    all, s.TrType, s.TrPrSamples, s.TrCh, s.TrLowRef, s.TrHighRef, s.TrLowSt, s.TrHighSt);               
disp(cmd); 
succ = system(cmd);
cmd = sprintf('%s -c AnalogSettings --AnGainCh1=%d --AnGainCh2=%d --AnGainCh3=%d --AnGainCh4=%d --An_OffCh1=%d --An_OffCh2=%d --An_OffCh3=%d --An_OffCh4=%d --An_Offset2=%d --AnSrc2Ch1=%s --AnSrc2Ch2=%s --AnSrc2Ch3=%s --AnSrc2Ch4=%s', ...
    all, s.AnGainCh(1), s.AnGainCh(2), s.AnGainCh(3), s.AnGainCh(4), s.An_OffCh(1), s.An_OffCh(2), s.An_OffCh(3), s.An_OffCh(4), s.An_Offset2, s.AnSrc2Ch1, s.AnSrc2Ch2, s.AnSrc2Ch3, s.AnSrc2Ch4);               
disp(cmd); 
succ = system(cmd);
cmd = sprintf('%s -c Capture --SampleSize=%d --Fs=%d --CapWaitTime=%d --CapSize=%d --WavForcefs=%d --WFile=%s', ...
all, s.bits, s.fs, s.CapWaitTime, s.CapSize, s.WavForcefs, s.WaveFile);               
disp(cmd); 
succ = system(cmd);
end