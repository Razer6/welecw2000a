function [ vector ] = SinGen(fs, t, Table)
% fs ... sampling frequence
% t  ... sampling time
% Table ... [ sin frequence, amplitude; sin frequence, amplitude; ...]

T = [1:(fs*t)]*2*pi/fs;
vector = zeros(1,length(T));

for i = 1:length(Table(:,1))
    vector = vector + sin(T*Table(i,1))*Table(i,2);
end