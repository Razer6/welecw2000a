


#include "types.h"
#include "DSO_MAIN.h"
#include "DSO_Screen.h"
#include "Filter_I8.h"

#define SIGNAL_HSTART 0
#define SIGNAL_HSTOP  HLEN

#ifdef BOARD_COMPILATION
void DrawSignal(
		uint32_t Voffset, 
		uSample * Data, 
		uint16_t Color){

	register uint32_t i = SIGNAL_HSTART+1;
	register uint32_t curr = 0;
        register uint32_t prev = 0;

	prev = Data[SIGNAL_HSTART].i + Voffset;
	if (prev < 0)     prev = 0;
	if (prev >= VLEN) prev = VLEN-1;

	for (; i < SIGNAL_HSTOP; ++i){
		curr = Data[i].i + Voffset;
		if (curr < 0)     curr = 0;
		if (curr >= VLEN) curr = VLEN-1;
		if (curr == prev) {
			DrawPoint(Color,i,curr);
		} else if (curr > prev) {
			DrawVLine(Color,i,prev,curr);
		} else {
			DrawVLine(Color,i,curr,prev);
		}
		prev = curr;
	}

}


void ConvSample (
		int32_t * dst, 
		int32_t * src, 
		int32_t const * const fir){

	register int fir_idx = 0;
	register int32_t result = 0;

	for(fir_idx = 0; fir_idx < POLYPHASE_COEFFS; fir_idx+= 1){
		result  += src[fir_idx] * fir[POLYPHASE_COEFFS-1-fir_idx];
	}
	*dst = result/(32768);
}


void Interpolate (
		uint32_t srcSamples, 
		uSample *Dst, 
		uSample *Src, 
		uint32_t type){

	register uint32_t i = 0;
	register uint32_t j = 0;
	register uint32_t polyphase_idx = 0;;
	register uint32_t dst_idx = 0;
	register int16_t * fir;
	
	for (i = 0; i < srcSamples; ++i){
		for (j = 0; j < POLYPHASES; ++j){
			fir = &Filter_I8[j][0];
			ConvSample(&Dst[dst_idx].i,&Src[i].i,fir);
		/*	Dst[dst_idx] = Src[i];*/
			dst_idx++;
		}
	}
}

void GetCh(
		uint32_t ch,
		uint32_t size,
		uSample * dst, 
		uSample * src, 
		uint32_t srcSamples){

	register uint32_t i = 0;
	switch (size){
		case 8: 
			for (; i < srcSamples; ++i) {
				dst[i].i = -src[i].c[ch];
			}
			break;
		case 16:
			for (; i < srcSamples; ++i) {
				dst[i].i = -src[i].s[ch];
			}
			break;
		default:
			for (; i < srcSamples; ++i) {
				dst[i].i = -src[i].i;
			}
			break;
	}
}
#endif
