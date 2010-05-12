

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


/* Returns true if file exits else false */
bool check_file(char *name)
{
	ifstream chkfile;
	chkfile.open(name);
	if(!chkfile.is_open())
	{
		cout << "Couldn't open file: '" << name << "'";
		return false;
	}
	chkfile.close();
	return true;
}

string get_sym_name(char *filename)
{
	string name(filename);
	name.erase(name.find(".bmp", 0), name.length());	//delete *.bmp extension of filename
	return name;
}

/* Reads an bitmap into a bitmap structure */
bool read_bmp(char *name, BMP &image)
{
	try 
	{
		//Read BMP Image
		image.ReadFromFile(name);    
	}
	catch(...)
	{
		cout << "Couldn't open file " << name << endl;
		return false;
	}    
	return true;
}

/* Creates a C-Header file */
void create_header(ofstream &out, string sym_name)
{
	string upper;
	upper.resize(sym_name.length());

	out << licencetext;

	for(unsigned int i=0; i<sym_name.length(); i++)
	{
		upper[i] = toupper(sym_name[i]);
	}

	out << "#ifndef __SYM_" << upper << "__" << endl;
	out << "#define __SYM_" << upper << "__" << endl << endl;

	out << "#include \"symbol.h\"" << endl << endl;
}

/* Create C Code File */
void write_to_src_file(ofstream &out, BMP &image, string name)
{
	//Write structure
	out << "sSymbol sym_" << name << " =" << endl;
	out << "{" << endl;
	out << "\t\t" << ".width = " << dec << image.TellWidth() << "," << endl;
	out << "\t\t" << ".height = " << dec <<image.TellHeight() << "," << endl;
	out << "\t\t" << ".data =" << endl;
	out << "\t\t" << "{" << endl;
	out << "\t\t\t";

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

  out << "}" << endl << "};" << endl << endl << endl;
}

int main( int argc, char* argv[] )
{
	SetEasyBMPwarningsOff();

	if (argc < 2)
	{
		cout << "Synopsys: bmp2framebuffer <image.bmp>" << endl;
		cout << "          bmp2framebuffer -n <Name of Symbolfile> <image1.bmp> <image2.bmp> ...";
		return -1;
	}

	if(argc == 2)	//single image without command
	{
		BMP image;

		if(check_file(argv[1]) == false)
		{
			return -1;
		}
		read_bmp(argv[1], image);

		string name = get_sym_name(argv[1]);

		ofstream src_file((name+".c").c_str());
		ofstream header_file((name+".h").c_str());

		if (!src_file || !header_file)	//Couldn't open files
		{
			cout << "Couldn't open header or source file\n";
			return -1;
		}

		create_header(header_file, name);
		header_file << "extern sSymbol sym_" << name << ";" << endl << endl;
		header_file << "#endif" << endl;

		src_file << licencetext;
		src_file << "#include \"symbol.h\"" << endl << endl;
		write_to_src_file(src_file, image, name);

		header_file.close();
		src_file.close();
	}
	else		//More Bitmap files to convert in one module
	{
		if(strcmp(argv[1], "-n"))
		{
			cout << "Wrong synopsis!" << endl << endl;
			cout << "Synopsys: bmp2framebuffer <image.bmp>" << endl;
			cout << "          bmp2framebuffer -n <Name of Symbolfile> <image1.bmp> <image2.bmp> ...";
			return -1;
		}

		string name(argv[2]);
		ofstream src_file((name + ".c").c_str());
		ofstream header_file((name + ".h").c_str());

		if (!src_file || !header_file)	//Couldn't open files
		{
			cout << "Couldn't open header or source file\n";
			return -1;
		}

		/* Initialize header and source file */
		src_file << licencetext;
		src_file << "#include \"symbol.h\"" << endl << endl;

		create_header(header_file, name);

		for(int i=3; i<argc; i++)
		{
			BMP image;
			string name;

			if(check_file(argv[i]) == false)
			{
				break;
			}
			read_bmp(argv[i], image);

			name = get_sym_name(argv[i]);

			write_to_src_file(src_file, image, name);
			header_file << "extern sSymbol sym_" << name << ";" << endl << endl;
		}

		header_file << "#endif" << endl;

		src_file.close();
		header_file.close();
	}

	return 0;
}




