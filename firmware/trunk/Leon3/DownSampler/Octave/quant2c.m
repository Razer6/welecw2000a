function [xq]=quant2c(x,B,TMode)
% tow's complement quantizer with range [-1,1[
% x     : input signal
% B     : word length (# of bits)
% TMode : truncation mode 
%         - truncation (rounding towards minus inifinity) 'f' 
%         - rounding to neares quantization level 'r' (round)
% xq    : quantized signal
% quant2c.m * February 2001 * mw
LSB = 2^(-(B-1));
% clipping (saturation)
xq = min(1-LSB,x);
xq = max(-1,xq);
% quantizer
if TMode=='tc' %%%%f
  xq = floor(xq/LSB)*LSB;
else
  xq = round(xq/LSB)*LSB;  
end
% end