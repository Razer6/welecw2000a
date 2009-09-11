function [ success ] = C_coeff_gen(filename, dstdir, type, name, vector, append, additional_lines)
% function [ success ] = C_coeff_gen(filename, dstdir, type, name, vector, additional_lines)
%
% Author: Alexander Lindert
% License: LGPL
%
% Creates a C file from a Vector
%
% filename ... without eg. .c or .h suffix
% dstdir ... destination path without / at the end, '.' for current dir
% type   ... C variable type
% name   ... C variable name
% vector ... coefficients
% append ... append on given file {0,1} file copy must be in current dir!
% additional_lines ... 2 diamensional string vector FIXME: or cell array
% values in the C array are rounded
format long;
echo off
target = [sprintf('%s.c',filename); sprintf('%s.h',filename)];

for x = 1:length(target(:,1))

if append == 0
	hFile = fopen(target(x,:),'w');
	fprintf(hFile,'/*/-----------------------------------------------------------------------\n');
	fprintf(hFile,'//-- Matlab Script created coefficients file\n');
	fprintf(hFile,'//-- Matlab Script Author Alexander Lindert \n');
	fprintf(hFile,'//----------------------------------------------------------------------*/\n');
else
	hFile = fopen(target(x,:),'a');
end

if nargin == 7 && max(size(additional_lines)) > 1
	for j = 1:length(additional_lines(:,1))
		fprintf(hFile,'%s\n',additional_lines(j,:));
	end
end

Size = size(vector);
for i = length(Size):-1:1
	if Size(i) == 1
		Size(i) = [];
	end
end

if x == 1
	fprintf(hFile,'#pragma WARNING OFF\n');
else
	fprintf(hFile,'extern ');
end

fprintf(hFile,'const %s  %s',type,name);
for j = 1:length(Size)
	fprintf(hFile,'[%d]',Size(j))
end

if x == 1 

fprintf(hFile, ' =\n');

for j = 1:length(Size)
	fprintf(hFile,'{',Size(j))
end

switch length(Size)
case {1}
	for i = 1:Size(1)
		fprintf(hFile,' %d',round(vector(i)));
		if i ~= Size(1)
			fprintf(hFile,',');
		end
	end
	
case {2}
	for j = 1:Size(1)
		for i = 1:Size(2)
			fprintf(hFile,' %d',round(vector(j,i)));
			if i ~= Size(2)
				fprintf(hFile,',');
			end
		end
		if j ~= Size(1)
			fprintf(hFile,'}, \n{');
		end
	end
case {3}
	disp('warning not testet\n');
	for k = 1:Size(2)
		for i = 1:Size(2)
			for j = 1:Size(3)
				fprintf(hFile,' %d',round(squeeze(vector(k,i,j))));
				if j ~= Size(3)
					fprintf(hFile,',');
				end
			end
			if i ~= Size(2)
				fprintf(hFile,'}, \n{');
			end
		end
		if k ~= Size(1)
			fprintf(hFile,'},{');
		end
	end
otherwise
	disp('diamension not implemented\n');
end

for j = 1:length(Size)
	fprintf(hFile,'}',Size(j))
end  

fprintf(hFile,';\n#pragma WARNING ON\n');

else
fprintf(hFile,';\n');
end

fclose(hFile);
%keyboard;

system(sprintf('cp ./%s %s/%s', target(x,:), dstdir, target(x,:)));
echo on
end
