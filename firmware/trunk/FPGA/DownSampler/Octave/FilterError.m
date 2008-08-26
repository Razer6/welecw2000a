function [ FgIdeal FgReal FgError ] = FilterError( NormFIRFilter, BitWidth);

FirIdeal = NormFIRFilter*2^(BitWidth-1);
FirReal  = round(FirIdeal);
FirError = FirIdeal -FirReal;

FirIdeal = NormFIRFilter;
FirReal  = FirReal/2^(BitWidth-1);
FirError = FirError/2^(BitWidth-1); 

FgIdeal = 20*log10(abs(fft(FirIdeal)) + eps);
FgReal  = 20*log10(abs(fft(FirReal )) + eps);
FgError = 20*log10(abs(fft(FirError)) + eps);

Max = (length(FgIdeal)-1)/2
F = [-Max:Max];

figure(1),clf
plot(F(2:end-1),fftshift(FgIdeal(2:end-1))), grid on;
figure(2),clf
plot(F(2:end-1),fftshift(FgReal(2:end-1))), grid on;
figure(3),clf
plot(F(2:end-1),fftshift(FgError(2:end-1))), grid on;



