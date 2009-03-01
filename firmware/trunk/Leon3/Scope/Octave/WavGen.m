% This file generates the input for each BhvADC in the full scope simulation
% CH1: sine wave with noise
% Ch2: digital data with heavy noise

t  = 0.0005; % wave time
tf = 0.01;
fs = 1e9;  % 1Gs data
lf = 1e5;
ts = 1 / fs;
adcs = 4;
T = [0:t*fs-1].*(lf/fs);
X = T;
X = sin(2*pi*T).*0.7; 
X = X + rand(length(T),1)'.*0.05;

Y = reshape(X,length(T)/adcs,adcs);
for i = [1:adcs]
	wavwrite(Y(:,i),fs,16,sprintf('Ch1ADC%d.wav',i));
end

bittime = 7;
bits = rand(length(T)/bittime,1).*.7;
X2 = repmat(X,bittime,1);
Y2 = X2(:);
Y2 = Y2 + rand(length(Y2), 1).*0.25;
Y2 = reshape(Y2,length(Y2)/adcs,adcs);
for i = [1:adcs]
	wavwrite(Y2(:,i),fs,16,sprintf('Ch2ADC%d.wav',i));
end



