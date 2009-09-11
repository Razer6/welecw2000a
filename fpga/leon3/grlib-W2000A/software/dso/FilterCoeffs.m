
filename = 'Filter_I8';
dstdir = './';

phases = 8
coeff_phase = 6
coeffs = phases*coeff_phase

Tx = [fix(-coeffs/2):1:fix((coeffs-1)/2)]/(phases);
PFir = sinc(Tx).*(kaiser(coeffs,4)')*32760;
%PFir1 = zeros(1,length(PFir));
%for i = 1:length(PFir)
%	PFir1(i) = PFir(length(PFir)+1-i);
%end

PFir = reshape(PFir,phases,coeff_phase);
l1 = sprintf('#include  "types.h"            ');
size(l1)
l2 = sprintf('#define  POLYPHASES           %d',phases);
size(l2)
l3 = sprintf('#define  POLYPHASE_COEFFS     %d',coeff_phase);
size(l3)
l4 = sprintf('#define  FILTER_COEFFS       %d',coeffs);
size(l4)
l5 = sprintf('#define  DOWNSHIFT           %d',16);
size(l5)

defines = [l1; l2; l3; l4; l5];
	
C_coeff_gen(filename,dstdir, 'int32_t', filename, PFir, 0, defines);


