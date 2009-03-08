
%clear all;
%close all;

load M2;
load M4;
load M10;

M2o = M2;
M4o = M4;
M10o = M10;

M2 = M2./sum(M2);
M4 = M4./sum(M4);
M10 = M10./sum(M10);

R2  = [1:length(M2)]';
R4  = [1:length(M4)]';
R10 = [1:length(M10)]';
R2  = R2./sum(R2);
R4  = R4./sum(R4);
R10 = R10./sum(R10);

R2 = reshape(R2,2,length(R2)/2);
R4 = reshape(R4,4,length(R4)/4);
R10 = reshape(R10,10,length(R10)/10);
R10 = [R10 zeros(length(R10(:,1)),3)];

R2 = R2';
R4 = R4';
R10 = R10';

R2 = R2(:)';
R4 = R4(:)';
R10 = R10(:)';

% Size should be 2^n
len = length(M2) + length(M4) + length(M10);

M2 = reshape(M2,2,length(M2)/2);
M4 = reshape(M4,4,length(M4)/4);
M10 = reshape(M10,10,length(M10)/10);
M10 = [M10 zeros(length(M10(:,1)),3)];

M2 = M2';
M4 = M4';
M10 = M10';

M2 = M2(:)';
M4 = M4(:)';
M10 = M10(:)';

% only 5 multiliers are used!
%M10 = reshape(M10,5,length(M10)/5);
%M10 = [M10; zeros(3,length(M10(1,:)))];
%M10 = M10(:)';

R = [R2 R4 R10];
RNormal = R.*2^(18-1);
CreatePackage('aInputValues','FirCoeff',RNormal);
system('del RampCoeff-p.vhd');
system('ren FirCoeff-p.vhd RampCoeff-p.vhd');
RFast = R.*2^(10-1);
CreatePackage('aInputValues','FastFirCoeff',RFast);
system('del FastRampCoeff-p.vhd');
system('ren FastFirCoeff-p.vhd FastRampCoeff-p.vhd');

Firs = [M2 M4 M10];
NormalFirs = Firs.*2^(18-1);
CreatePackage('aInputValues','FirCoeff',NormalFirs);
FastFirs = Firs.*2^(10-1);
plot(FastFirs);
CreatePackage('aInputValues','FastFirCoeff',FastFirs);
