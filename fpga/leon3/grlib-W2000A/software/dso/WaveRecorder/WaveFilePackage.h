/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : WaveFilePackage.h
* Author         : Alexander Lindert <alexander_lindert at gmx.at>
* Date           : 20.04.2009
*****************************************************************************
* Description	 : 
*****************************************************************************

*  Copyright (c) 2009, Alexander Lindert

*  This program is free software; you can redistribute it and/or modify
*  it under the terms of the GNU General Public License as published by
*  the Free Software Foundation; either version 2 of the License, or
*  (at your option) any later version.

*  This program is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.

*  You should have received a copy of the GNU General Public License
*  along with this program; if not, write to the Free Software
*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

*  For commercial applications where source-code distribution is not
*  desirable or possible, I offer low-cost commercial IP licenses.
*  Please contact me per mail.

*****************************************************************************
* Remarks		: -
* Revision		: 0
****************************************************************************/
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

/*typedef union {
	int i;
	short s[2];
	char  c[4];
} uSample;*/


#ifdef __cplusplus
extern "C" {
#endif

bool OpenWaveFileRead(	const char * 		FileName,
			FILE ** 			WaveFileHandle,
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
			FILE **	 		WaveFileHandle,
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

#ifdef __cplusplus
}
#endif

#endif
