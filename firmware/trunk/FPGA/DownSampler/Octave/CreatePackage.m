function [ success ] = CreatePackage( type, name, vector)
% creates a VHDL package with a constat array from a vector
% Author: Alexander Lindert
%  type       ... VHDL typ 
%  name       ... array name
%  vector     ... single dimensional array
% TODO        ... more dimensions

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %    GNU Lesser General Public License Version 3
 %    =============================================
 %    Copyright 2005 by Sun Microsystems, Inc.
 %    901 San Antonio Road, Palo Alto, CA 94303, USA
 %
 %    This library is free software; you can redistribute it and/or
 %    modify it under the terms of the GNU Lesser General Public
 %    License version 3, as published by the Free Software Foundation.
 %
 %    This library is distributed in the hope that it will be useful,
 %    but WITHOUT ANY WARRANTY; without even the implied warranty of
 %    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 %    Lesser General Public License for more details.
 %
 %    You should have received a copy of the GNU Lesser General Public
 %    License along with this library; if not, write to the Free Software
 %    Foundation, Inc., 59 Temple Place, Suite 330, Boston,
 %    MA  02111-1307  USA
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename = sprintf('%s-p.vhd',name);
system(sprintf('rm %s', filename));
hFile = fopen(filename,'w');

fprintf(hFile,'------------------------------------------------------------------------\n');
fprintf(hFile,'-- Script created table file\n');
fprintf(hFile,'------------------------------------------------------------------------\n');
fprintf(hFile,'library ieee;\n');
fprintf(hFile,'use ieee.std_logic_1164.all;\n');
fprintf(hFile,'use ieee.numeric_std.all;\n');
%fprintf(hFile,'use work.Fractional.all;\n');
%fprintf(hFile,'use work.Global.all;\n\n');
fprintf(hFile,'package p%s is\n',name);
fprintf(hFile,'constant c%s : %s',name,type);
VectorSize = length(vector);
Dimension = length(VectorSize);
VectorPos = ones(1,VectorSize);

if Dimension == 1
    fprintf(hFile,'(0 to %d-1) := (',VectorSize);
    for i = 1:VectorSize
        fprintf(hFile,' %d',round(vector(i)));
        if i ~= VectorSize
            fprintf(hFile,',');
        end
    end
    fprintf(hFile,')');
end
fprintf(hFile,';\nend;\n');
fclose(hFile);



