%function [ output_args ] = CreateBitStream( input_args )
%Dieses Script erzeugt eine UART kompatible Bitfolge aus angegebenen
%Zeichen, setzt die Bitfolge in zwei Frequenzen um und speichert das
%Ergebnis in einer Wav Datei
%   Detailed explanation goes here

clear all 
close all

% ***************** Systemparameter *****************
snr = 100;                % db
fs = 44.117e3;          % Abtastfrequenz
baudrate = 200;
Ts = 1/fs;              % Abtastzeit
fu = 7237.9453125000 ;  % Frequenz für die '0'
fo = 12063.2421875000;  % Frequenz für die '1'
%N = 30                 % Anzahl der Sendesymbole
N_symb = round(fs/baudrate);   % Anzahl der Samples pro Sendebit
T_symb = Ts*N_symb;     % Symboldauer
WavFileName = 'Test';
AudioBitW = 16;
IdleBits  = 2;
Resend = 20;             % Wie oft soll der input ins wave geschrieben werden.
input = ['A' 'B' 'C' 'D' 'E' 'F' 10 13];
%input = ['A' 'B' 'C' 10 13];   %10 13 für Zeilenumbruch

% ****************** sender ***********************
data = ones(1,IdleBits);
for m = 1:Resend
    for i = 1:length(input)
        tmp  = dec2bin(input(i),8);         %8 Bit erzwingen
        %Reihenfolge umdrehn, zuerst LSB:
        for L = 1:8
           tmp2(L)= bin2dec(tmp(8+1-L));
        end
        data = [data 0 tmp2 ones(1,IdleBits)]; %Alte Daten + Startbit + CharBits + IdleBits
    end
end

data_transmit = data;
N = length(data_transmit);
% ****************** DDS ***********************
% Precision of DDS:
DDSPrecison = 0.05;
% Erzeugung zweier freilaufender Oszillatorschwingungen
t = 0:Ts:N*T_symb-Ts;
NPoints = length(t);
%oszillator_1 = cos(2*pi*fu*t)+rand(1,NPoints)*DDSPrecison-DDSPrecison/2;
%oszillator_2 = cos(2*pi*fo*t)+rand(1,NPoints)*DDSPrecison-DDSPrecison/2;
oszillator_1 = cos(2*pi*fu*t);
oszillator_2 = cos(2*pi*fo*t);

% Erzeugung des Sendesignals
s = [];
datasignal = [];
for k = 1:N
    if data_transmit(k) == 0
        s = [s, oszillator_1((k-1)*N_symb+1:k*N_symb)];
        datasignal = [datasignal zeros(1,N_symb)];
    else
        s = [s, oszillator_2((k-1)*N_symb+1:k*N_symb)];
        datasignal = [datasignal ones(1,N_symb)];
    end
end
% **** Noise basierend auf der SNR dem Signal hinzufügen ****

% adjacent channel interferer
Psignal = sum(s.^2)/length(s);
noise = 2*randn(1,length(s))-1;      % not loaded from rx.mat here

Pnoise = sum(noise.^2)/length(noise);
NoiseScale = sqrt(Psignal/10^(snr/10)/Pnoise);
noise = noise * NoiseScale;
sn = s + noise;
%%%% quantize %%%%%
%s = quant2c(s,AudioBitW,'r'); %wavewrite includes quantize
wavwrite(sn,fs,AudioBitW,WavFileName);  
disp('Testfile written!')









