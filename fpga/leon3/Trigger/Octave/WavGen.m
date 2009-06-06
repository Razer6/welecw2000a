% This file generates first a wave file with one sinus wave which increases it's frequency.
% The second file is a uart stream with dead transfer times.
% for all files:
% ch1 ... no noise
% ch2 ... very low noise
% ch3 ... normal noise
% ch4 ... high noise

t  = 0.5;
tf = 0.01;
fs = 1e6;
lf = 1e2;
hf = 2e5;
ts = 1 / fs;

T = [0:t*fs-1].*(lf/fs);
X = sin(2*pi*T).*0.7;
len = length(X);
LowF = [X' X'+rand(len,1)*0.001 X'+rand(len,1)*0.05 ...
 X'+rand(len,1)*0.2];
wavwrite(LowF,fs,16,'LowF.wav');

T = [0:t*fs-1].*(hf/fs);
X = sin(2*pi*T).*0.7;
len = length(X);
HighF = [X' X'+rand(len,1)*0.001 X'+rand(len,1)*0.05 ...
 X'+rand(len,1)*0.2];
wavwrite(HighF,fs,16,'HighF.wav');

T = [0:t*fs-1].*0.0001;
T2 = (T.*4).^1.4;
Y = sin(2*pi*T2).*0.7;

plot(Y(1:10000));
figure
plot(Y(990000:end));
len = length(Y);
wobble = [Y' Y'+rand(len,1)*0.001 Y'+rand(len,1)*0.05 ...
 Y'+rand(len,1)*0.2];

wavwrite(wobble,fs,16,'Wobble.wav');

L = -ones(1,100).*.7;
H = ones(1,100).*.7;
Z = [ L H L H H H L L H H H H H L H L L L L L L L L L L L L H L H L H ];
% Adding glitches
framelen = length(Z);
offset1 = 1100;
offset2 = 2000;
Z(offset1) = -Z(offset1);
Z(offset2) = -Z(offset2);
plot(Z);

Z = [ Z Z Z Z Z Z Z Z Z Z Z ];
Z = [ Z Z Z Z Z Z Z Z Z Z Z ]; % repeating 121 times see glitch report!
len = length(Z);

data = [Z' Z' + rand(len,1)*0.001 Z' + rand(len,1)*0.05 ...
 Z' + rand(len,1)*0.2];
wavwrite(data,fs,16,'data.wav');
