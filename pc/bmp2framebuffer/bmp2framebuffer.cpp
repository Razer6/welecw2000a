

/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : bmp2framebuffer
* Author         : Robert Schilling <robert.schilling at gmx.at>
* Date           : 08.05.2010
*****************************************************************************
* Description	 : Converts a framebuffer to structure for
*				   drawing on a framebuffer
*****************************************************************************

*  Copyright (c) 2010, Schilling Robert

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

#include <iostream>
#include <fstream>
#include "EasyBMP.h"

using namespace std;

bool saveHeaderFile(string name, BMP &image);

int main( int argc, char* argv[] )
{
	BMP image;
	int width, height;

	if (argc<2)
	{
		cout << "Synopsys: bmp2framebuffer <image.bmp>";
		return -1;
	}

	string filename(argv[1]);	//Get name of BMP File

	SetEasyBMPwarningsOff();

	try 
	{
		//Read BMP Image
		image.ReadFromFile(filename.c_str());    
	}
	catch(...)
	{
		cout << "Couldn't open file " << argv[1] << endl;
		return -1;
	}    

	//Get BMP Size
	height = image.TellHeight();
	width = image.TellWidth();

	filename.erase(filename.find(".bmp", 0), filename.length());	//delete *.bmp extension of filename

	if (!saveHeaderFile(filename, image))
	{
		cout << "Could'nt create header file" << endl;
		return -1;
	}

	return 0;
}



bool saveHeaderFile(string name, BMP &image)
{
	ofstream out((name+".h").c_str());	//Open File

	if (!out)
	{
		cout << "Couldn't open file\n";
		return false;
	}

	//Write structure
	out << "sSymbol sym_" << name << " = {" << endl;
	out << "\t\t" << ".width = " << image.TellWidth() << "," << endl;
	out << "\t\t" << ".height = " << image.TellHeight() << "," << endl;
	out << "\t\t" << ".data = {" << endl;

	int count = (image.TellWidth()/8 + (image.TellWidth()%8==0?0:1))*image.TellHeight();
	int set = 0;
	int mask = 0x80;
  
	for(int h=0; h<image.TellHeight(); h++)
	{
		for(int w=0; w<image.TellWidth(); w++)
		{
			if(image(w,h)->Red<128 || image(w,h)->Green<128 || image(w,h)->Blue < 128)
			{
				set |= mask;
			}

			mask >>= 1;
			if(mask == 0)	//write one byte
			{
				out <<"0x";
				if (set<16)		//Write leading 0
					  out <<"0"; 
				out<<hex<<set;
				if(--count != 0) //print comma if not last byte
					out << ", ";
				mask = 0x80;
				set = 0;
			}
		}

		if(mask != 0)	//write one byte
		{
			out <<"0x";
			if (set<16)		//Write leading 0
				  out <<"0"; 
			out<<hex<<set;
			if(--count != 0) //print comma if not last byte
				out << ", ";
			mask = 0x80;
			set = 0;
		}
		out << endl << "\t\t\t";
	}

  out << "}" << endl << "};";
  out.close();

  return true;
}
