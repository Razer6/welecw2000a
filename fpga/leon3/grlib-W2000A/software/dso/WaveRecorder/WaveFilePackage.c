/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : WaveFilePackage.c
* Author		 : Alexander Lindert <alexander_lindert at gmx.at>
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

#include "stdio.h"
#include "string.h"

#include "WaveFilePackage.h"

bool ReadString(	FILE * 			WaveFileHandle,
			char * const 		Name)  {
	char  ch;
	int i = 0;
	int size = strlen(Name);
	for (i = 0; i < size; ++i) {
		fscanf(WaveFileHandle,"%c", &ch);
		if (ch  != Name[i]){ 
			return false;
		}
	}
	return true;
}


unsigned int ReadDword(	FILE * 			WaveFileHandle)  {
	unsigned int  Ret = 0;
	fread(&Ret,sizeof(Ret),1,WaveFileHandle);
	return Ret;
}

unsigned short ReadWord(FILE * 			WaveFileHandle)  {
	unsigned short  Ret = 0;
/*	char  ch;
	int i = 0;

	for(i = 0; i <  1; ++i) {
		fscanf(WaveFileHandle,"%c", &ch);
		Ret = Ret + (short)(ch <<(8*i));
	}*/
	fread(&Ret,sizeof(Ret),1,WaveFileHandle);
	return Ret;
}

bool OpenWaveFileRead(	const char * 		FileName,
			FILE ** 			Handle,
 			aWaveFileInfo 		FileInfo) {
	int  Dummy = 0;
	
	FILE * WaveFileHandle = fopen(FileName,"r");
	if (WaveFileHandle == 0){
		printf("Cannot open file %s !\n",FileName);
		return false;
	}
	if (ReadString(WaveFileHandle, "RIFF")){
		printf("The file %s is not a wave file!\n",FileName);
		return false;
	}
	Dummy = ReadDword(WaveFileHandle) +8; /* wrong dummy access!!! */
	if (ReadString(WaveFileHandle, "WAVE")){
		printf("The file %s is not a wave file!\n", FileName);
		return false;
	}
	if (ReadString(WaveFileHandle, "fmt ")){
		printf("The file %s is not a wave file!\n", FileName);
		return false;
	}
	if (ReadDword(WaveFileHandle) == 16){
		printf("Uncommon header length, data will be corrupted!\n");
		return false;
	}
	if (ReadWord(WaveFileHandle) == 1){
		printf("Cannot Handle any compressed file format!\n");
		return false;
	}
	FileInfo.Channels = ReadWord(WaveFileHandle);
	FileInfo.SamplingRate = ReadDword(WaveFileHandle);
	Dummy = ReadDword(WaveFileHandle); /* bytes/second */
	Dummy = ReadWord(WaveFileHandle); /* block align */
	FileInfo.DataTyp = ReadWord(WaveFileHandle);
	if (ReadString(WaveFileHandle, "data")){
		printf("The file %s is not a wave file!\n", FileName);
		return false;
	}
	*Handle = WaveFileHandle;
	return true;
}


int ReadSignedDword(FILE * WaveFileHandle)  {
	int  Ret = 0;
	fread(&Ret,sizeof(Ret),1,WaveFileHandle);
	/*fscanf(WaveFileHandle,"%d",&Ret);*/
	return Ret;
}

short ReadSignedWord(FILE * WaveFileHandle)  {
	short  Ret = 0;
/*	char  ch;
	int i = 0;
	for(i = 0; i <  1; ++i) {
		fscanf(WaveFileHandle,"%c", &ch);
		Ret = Ret + (short)(ch << (i*8));
	}*/
	fread(&Ret,sizeof(Ret),1,WaveFileHandle);
	return Ret;
}

char ReadSignedByte(FILE * WaveFileHandle)  {
	char  Ret;
	/*fscanf(WaveFileHandle,"%c", &ch);*/
	fread(&Ret,sizeof(Ret),1,WaveFileHandle);
	return Ret;
}

bool ReadSample(	FILE * 			WaveFileHandle,
			int * 			Sample,
			int * 			RemainingData,
			const short 	DataTyp) {
	if (feof(WaveFileHandle) == true) {
		if (*RemainingData < 0) {
			printf("Unexpected end of file!\n");
			return false;
		} else {
			printf("End of file reached!\n");
		}
	} else {
	switch (DataTyp) {
		case 8:
			*Sample = (int)ReadSignedByte(WaveFileHandle);
			*RemainingData = *RemainingData-1;
			break;
		case 16:
			*Sample = (int)ReadSignedWord(WaveFileHandle);
			*RemainingData = *RemainingData-2;
			break;
		case 32:
			*Sample = ReadSignedDword(WaveFileHandle);
			*RemainingData = *RemainingData-4;
			break;
		default:
			return false;
	}
	}
	return true;
}


bool ReadSamples(	FILE * 			WaveFileHandle,
 			int * 			Samples,
			int * 			RemainingData,
			const int 		Channels,
			const short	DataTyp) {
	bool Ret = true;
	int i = 0;
	for(i = 0; i <  Channels; ++i) {
		if (Ret == true){
			ReadSample(WaveFileHandle, &Samples[i], RemainingData, DataTyp);
		} else {
			return false;
		}
	}
	return true;
}

void WriteString(	FILE * 			WaveFileHandle,
			char * const 		Name) {
	fprintf(WaveFileHandle,Name);
}

void WriteChar(		FILE * 			WaveFileHandle,
			char 			Value) {
	fwrite(&Value,sizeof(Value),1,WaveFileHandle);
}

void WriteDword(	FILE * 			WaveFileHandle,
			int const 		Value) {
	fwrite(&Value,sizeof(Value),1,WaveFileHandle);
}

void WriteWord(		FILE * 			WaveFileHandle,
			short 	 		Value) {
	fwrite(&Value,sizeof(Value),1,WaveFileHandle);
}


bool OpenWaveFileWrite(	const char * 		FileName,
			FILE **	 		Handle,
 			aWaveFileInfo 		WaveFile) {
	int  Size = 0;
	
	FILE * WaveFileHandle = fopen(FileName, "w");
	if(WaveFileHandle == 0){
		printf("Cannot open file %s!\n", FileName);
		return false;
	}
	WriteString(WaveFileHandle, "RIFF"); 
	Size = WaveFile.DataSize + 44 -8;
	WriteDword(WaveFileHandle, Size); 
	WriteString(WaveFileHandle, "WAVE");
	WriteString(WaveFileHandle, "fmt ");
	Size = 16;
	WriteDword(WaveFileHandle, Size); 
	Size = 1;
	WriteWord(WaveFileHandle, Size); 
	WriteWord(WaveFileHandle, WaveFile.Channels);
	WriteDword(WaveFileHandle, WaveFile.SamplingRate); 
	Size = WaveFile.DataTyp/8;
	WriteDword(WaveFileHandle, WaveFile.SamplingRate*WaveFile.Channels*Size); 
	WriteWord(WaveFileHandle, WaveFile.Channels*Size); 
	WriteWord(WaveFileHandle, Size);
	WriteString(WaveFileHandle, "data");
	WriteDword(WaveFileHandle, WaveFile.DataSize);
    *Handle = WaveFileHandle;
	return true;
}

bool WriteSample(	FILE * 			WaveFileHandle,
			const int  		Sample,
			int * 			RemainingData,
			const short 	DataTyp) {

	if (*RemainingData > 0) {
		switch (DataTyp) {
			case 8:
				WriteChar(WaveFileHandle, Sample);
				*RemainingData = *RemainingData -1;
				break;
			case 16:
				WriteWord(WaveFileHandle, Sample);
				*RemainingData = *RemainingData -2;
				break;
			case 32:
				WriteDword(WaveFileHandle, Sample);
				*RemainingData = *RemainingData -4;
				break;
			default: break;
		}
	} else {
		printf("Wave file is full, have you forgotten to set the data size for OpenWaveFileWrite!\n" );
		return false;
	}
	return true;
}

bool WriteSamples(	FILE * 			WaveFileHandle,
			const int * 		Samples,
			int * 			RemainingData,
			const int 		Channels,
			const short 	DataTyp) {
	int i = 0;
	bool Ret = true;
	for(i = 0; i <  Channels; ++i) {
		if (Ret == true) {
			Ret = WriteSample(WaveFileHandle, Samples[i], RemainingData, DataTyp);
		} else {
			return false;
		}
	}
	return true;
}

