
clear all;
close all;

load M2;
load M4;
load M10;

M2o = M2;
M4o = M4;
M10o = M10;

% Size should be 2^n
len = length(M2) + length(M4) + length(M10);
z = ceil(len/8);

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

Firs = [M2 M4 M10];
Firs = Firs./sum((Firs));
Firs = Firs.*2^(11-1);
plot(Firs);
CreatePackage('aInputValues','FastFirCoeff',Firs);
