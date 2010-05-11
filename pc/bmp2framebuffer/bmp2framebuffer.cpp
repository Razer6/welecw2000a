

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
#include <cctype>
#include <string>
#include "EasyBMP.h"

using namespace std;

bool createHeaderFile(string name);
bool createCodeFile(string name, BMP &image);


string licencetext 
("\
/****************************************************************************	\n \
* Project        : Welec W2000A												\n \
*****************************************************************************	\n \
* File           : Symbol created by bmp2framebuffer							\n \
* Author         : Robert Schilling <robert.schilling at gmx.at>				\n \
* Date           : 08.05.2010													\n \
*****************************************************************************	\n \
* Description	 : This symbol is created by bmp2framebuffer					\n \
*****************************************************************************	\n \
\n \
*  Copyright (c) 2010, Schilling Robert											\n \
\n \
*  This program is free software; you can redistribute it and/or modify			\n \
*  it under the terms of the GNU General Public License as published by			\n \
*  the Free Software Foundation; either version 2 of the License, or			\n \
*  (at your option) any later version.											\n \
\n \
*  This program is distributed in the hope that it will be useful,				\n \
*  but WITHOUT ANY WARRANTY; without even the implied warranty of				\n \
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the				\n \
*  GNU General Public License for more details.									\n \
\n \
*  You should have received a copy of the GNU General Public License			\n \
*  along with this program; if not, write to the Free Software					\n \
*  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA	\n \
\n \
*  For commercial applications where source-code distribution is not			\n \
*  desirable or possible, I offer low-cost commercial IP licenses.				\n \
*  Please contact me per mail.													\n \
\n \
*****************************************************************************	\n \
* Remarks		: -																\n \
* Revision		: 0																\n \
****************************************************************************/  \n\n");

int main( int argc, char* argv[] )
{
	BMP image;
	int width, height;
	ifstream chkfile;

	if (argc<2)
	{
		cout << "Synopsys: bmp2framebuffer <image.bmp>";
		return -1;
	}

	//Check if bitmap file exists
	chkfile.open(argv[1]);
	if(!chkfile.is_open())
	{
		cout << "Couldn't open file: '" << argv[1] << "'";
		return -1;
	}
	chkfile.close();

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

	if (!createCodeFile(filename, image))
	{
		cout << "Could'nt create code file" << endl;
		return -1;
	}

	if (!createHeaderFile(filename))
	{
		cout << "Could'nt create header file" << endl;
		return -1;
	}
	return 0;
}

/* Create C Header File */
bool createHeaderFile(std::string name)
{
	ofstream out((name+".h").c_str());	//Open File

	if (!out)
	{
		cout << "Couldn't open file\n";
		return false;
	}

	out << licencetext;

	string upper;
	upper.resize(name.length());

	for(unsigned int i=0; i<name.length(); i++)
	{
		upper[i] = toupper(name[i]);
	}

	out << "#ifndef SYM_" << upper << endl;
	out << "#define SYM_" << upper << endl << endl;

	out << "#include \"symbol.h\"" << endl << endl;
	out << "extern sSymbol sym_" << name << ";" << endl << endl;

	out << "#endif" << endl;

	out.close();
	return true;
}

/* Create C Code File */
bool createCodeFile(string name, BMP &image)
{
	ofstream out((name+".c").c_str());	//Open File

	if (!out)
	{
		cout << "Couldn't open file\n";
		return false;
	}

	out << licencetext;
	out << "#include \"symbol.h\"" << endl << endl;

	//Write structure
	out << "sSymbol sym_" << name << " = {" << endl;
	out << "\t\t" << ".width = " << image.TellWidth() << "," << endl;
	out << "\t\t" << ".height = " << image.TellHeight() << "," << endl;
	out << "\t\t" << ".data = {";
	out << endl << "\t\t\t";

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
