
#ifndef WAVEFILEPACKAGE_H
#define WAVEFILEPACKAGE_H

#include "stdio.h"
#include "types.h"

typedef struct { 
	short DataTyp;
	int Channels;
	int DataSize;
	unsigned int SamplingRate;
} aWaveFileInfo;

bool OpenWaveFileRead(	const char * 		FileName,
			FILE * 			WaveFileHandle,
 			aWaveFileInfo		FileInfo);


bool ReadSample(	FILE * 			WaveFileHandle,
			int * 			Sample,
			int * 			RemainingData,
			const short 	DataTyp);

bool ReadSamples(	FILE * 			WaveFileHandle,
			int * 			Samples,
			int * 			RemainingData,
			const int 		Channels,
			const short 	DataTyp);

bool OpenWaveFileWrite(	const char * 		FileName,
			FILE *	 		WaveFileHandle,
 			aWaveFileInfo 		WaveFile);

bool WriteSample(	FILE * 			WaveFileHandle,
			int const 		Sample,
			int * 			RemainingData,
			const short 	DataTyp);

bool WriteSamples(	FILE * 			WaveFileHandle,
			const int * 		Samples,
			int * 			RemainingData,
			const int 		Channels,
			const short 	DataTyp);

#endif
