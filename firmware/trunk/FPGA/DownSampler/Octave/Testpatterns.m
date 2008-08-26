clear all;
close all;

fs = 1e9;
% frequence, amplitude
Aliasing = [220e6, 0.3; 6e6, 0.6];
Sinus = [6e6, 0.6];
lf = [1e6, 0.8];
noise = 0.2;
bits = 9;
t = 2e-6;

LF = SinGen(fs,t, lf);
S =  SinGen(fs,t, Sinus);
A =  SinGen(fs,t, Aliasing);

InputValues = [LF S A];
InputValues = InputValues + noise.*rand(1,length(InputValues));
InputValues = InputValues/(max(InputValues)+0.02);
InputValues = InputValues.*2^(bits-2);

plot(InputValues);
CreatePackage('aInputValues','InputValues',InputValues);
