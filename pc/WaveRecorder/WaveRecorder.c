/****************************************************************************
* Project        : Welec W2000A
*****************************************************************************
* File           : WaveRecorder.c
* Author       : Alexander Lindert <alexander_lindert at gmx.at>
		 Schilling Robert <robert.schilling at gmx.at>
* Date           : 20.04.2009
*****************************************************************************
* Description	 : 
*****************************************************************************

*  Copyright (c) 2009, Alexander Lindert
		  2010, Robert Schilling

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


#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "WaveFilePackage.h"
#include "DSO_Remote_Master.h"
#include "argtable2.h"
#include "arg_costums.h"
#include "crc.h"
#include "Protocoll.h"
#include "Request.h"
#include "RemoteSignalCapture.h"
#include "NormalUART.h"
#include "DebugUart.h"

#include <iostream>
#include <fstream> 
#include <string> 
#include <vector>
#include <sstream>
using namespace std;

struct arg_lit  *screenshot = arg_lit1(NULL,"screenshot", "Generates a screenshot");
struct arg_file * screenshot_filename = arg_file0("f", "File", "<file>", "Filename for screenshot");
struct arg_end * end_screenshot = arg_end(20);
void *argtable_screenshot[] = {screenshot, screenshot_filename, end_screenshot}; 

struct arg_lit  * loadrun = arg_lit1(NULL,"loadrun", "Loads a firmware to the Leon3 processor");
struct arg_file * loadrun_filename = arg_file1("f", "File", "<file>", "Binary file for the direct DSO CPU access (binary software file)");
struct arg_int * stack_addr = arg_int0("a", "Address", NULL, "Address where stack starts"); 
struct arg_end * end_loadrun = arg_end(20);
void *argtable_loadrun[] = {loadrun, loadrun_filename, stack_addr, end_loadrun};

struct arg_lit  * read_addr = arg_lit1(NULL,"readaddr", "Reads <Size> Dwords from memory");
struct arg_int * address_read = arg_int1("a", "Address", NULL, "Address to start from"); 	
struct arg_int * cap_size_read = arg_int1("s", "size", "<n>", "Read data size in Dwords"); 	
struct arg_end * end_read_addr = arg_end(20);
void *argtable_read_addr[] = {read_addr, address_read, cap_size_read,  end_read_addr};

struct arg_lit  * write_addr = arg_lit1(NULL,"writeaddr", "Reads <CapSize> Dwords from memory");
struct arg_int * address_write = arg_int1("a", "Address", NULL, "Capture data size in Dwords"); 
struct arg_int * data_write = arg_intn("d","Data", "<n>",0,64, "Data Dword(s) for writeaddr"); 
struct arg_file * file_write = arg_file0("f", "File", "<file>", "Binary file for write");
struct arg_end * end_write_addr = arg_end(20);
void *argtable_write_addr[] = {write_addr, address_write,  data_write, file_write, end_write_addr};

struct arg_lit  * debug = arg_lit1(NULL,"debug", "Generates a backtrace output");
struct arg_end * end_debug = arg_end(20);
void *argtable_debug[]  = {debug, end_debug};

struct arg_lit  * trigger_input = arg_lit1(NULL,"triggerinput", "Modifies trigger input settings");
struct arg_int * trigger_channels	= arg_int1("n","Channels",	"<n>",	"Number of channels");
struct arg_int * sample_size	= arg_int1(NULL,"SampleSize",	"<n>",	"Bits per sample"); 
struct arg_int * sampling_freq	= arg_int1(NULL,"Fs",		"<n>",	"Sampling frequency"); 
struct arg_int * aac_filter_start	= arg_int1(NULL,"AACStart",	"<n>",	"Polyphase decimator start"); 
struct arg_int * aac_filter_stop	= arg_int1(NULL,"AACEnd",	"<n>",	"Polyphase decimator end"); 
struct arg_int * ch0_src		= arg_int1(NULL,"CH1",		"<n>",	"Channel 1 source"); 
struct arg_int * ch1_src		= arg_int1(NULL,"CH2",		"<n>",	"Channel 2 source"); 
struct arg_int * ch2_src		= arg_int1(NULL,"CH3",		"<n>",	"Channel 3 source"); 
struct arg_int * ch3_src		= arg_int1(NULL,"CH4",		"<n>",	"Channel 4 source"); 						
struct arg_end * end_trigger_input = arg_end(20);					
void *argtable_trigger_input[] = {trigger_input, trigger_channels, sample_size, sampling_freq, aac_filter_start,
						aac_filter_stop, ch0_src, ch1_src, ch2_src, ch3_src, end_trigger_input};

struct arg_lit  * trigger = arg_lit1(NULL,"trigger", "Modifies trigger settings");
struct arg_str * trigger_type	= arg_str1(NULL,"TrType","[ExtLH | ExtHL | SchmittLH | SchmittHL | GlitchLH | GlitchHL]","Trigger type");
struct arg_int * external_trigger = arg_int1(NULL,"ExtTrigger","<n>", "External trigger, #0 = always, #1 = external trigger 1, #n = external trigger");
struct arg_int * trigger_channel = arg_int1(NULL,"TrCh",		"<n>",	"Trigger Channel"); 
struct arg_int * trigger_prefetch = arg_int1(NULL,"TrPrSamples",	"<n>",	"Trigger prefetch samples/8");
struct arg_int * trigger_low_level = arg_int1(NULL,"TrLowRef",	"<n>",	"Trigger low level  (integer!)"); 
struct arg_int * trigger_high_level = arg_int1(NULL,"TrHighRef",	"<n>",	"Trigger high level (integer!)"); 
struct arg_int * trigger_low_time = arg_int1(NULL,"TrLowSt",	"<n>",	"Trigger low stable (samples/8)"); 
struct arg_int * trigger_high_time = arg_int1(NULL,"TrHighSt",	"<n>",	"Trigger high stable (samples/8)"); 
struct arg_end * end_trigger = arg_end(20);
void *argtable_trigger[]  = {	trigger, trigger_type, external_trigger, trigger_channel, trigger_prefetch, 
					trigger_low_level, trigger_high_level, trigger_low_time, trigger_high_time, end_trigger};

struct arg_lit  * analog_input = arg_lit1(NULL, "analoginput", "Modifies analog input settings");
struct arg_int * channels_analog	= arg_int1("n", "Channels","<n>","Number of channels");
struct arg_int * analog_pwm = arg_int0(NULL,"An_Offset2",	"<n>",	"Analog offset from PWM"); 
struct arg_str * analog_src_ch0 = arg_str1(NULL, "AnSrc2Ch1","[none | pwm | gnd | lowpass]", "Normal operating mode, PWM offset, GND, lowpass");
struct arg_str * analog_src_ch1 = arg_str1(NULL, "AnSrc2Ch2","[none | pwm | gnd | lowpass]", "Normal operating mode, PWM offset, GND, lowpass");
struct arg_str * analog_src_ch2 = arg_str1(NULL, "AnSrc2Ch3","[none | pwm | gnd | lowpass]", "Normal operating mode, PWM offset, GND, lowpass");
struct arg_str * analog_src_ch3 = arg_str1(NULL, "AnSrc2Ch4","[none | pwm | gnd | lowpass]", "Normal operating mode, PWM offset, GND, lowpass");

struct arg_int * analog_gain_ch0	= arg_int1(NULL, "AnGainCh1", "<n>", "Analog input gain"); 
struct arg_int * analog_gain_ch1	= arg_int1(NULL, "AnGainCh2", "<n>", "Analog input gain"); 
struct arg_int * analog_gain_ch2	= arg_int1(NULL, "AnGainCh3", "<n>", "Analog input gain"); 
struct arg_int * analog_gain_ch3	= arg_int1(NULL, "AnGainCh4", "<n>", "Analog input gain"); 
					
struct arg_lit * analog_ac_ch0 = arg_lit0(NULL,"ACModeCh1", "AC Mode, if not set AC=off"); 
struct arg_lit * analog_ac_ch1 = arg_lit0(NULL,"ACModeCh2", "AC Mode, if not set AC=off"); 
struct arg_lit * analog_ac_ch2 = arg_lit0(NULL,"ACModeCh3", "AC Mode, if not set AC=off"); 
struct arg_lit * analog_ac_ch3 = arg_lit0(NULL,"ACModeCh4", "AC Mode, if not set AC=off");

struct arg_int * analog_offset_ch0	= arg_int1(NULL, "An_OffCh1", "<n>", "Analog offset Ch1 (integer!)"); 
struct arg_int * analog_offset_ch1	= arg_int1(NULL, "An_OffCh2", "<n>", "Analog offset Ch2 (integer!)"); 
struct arg_int * analog_offset_ch2	= arg_int1(NULL, "An_OffCh3", "<n>", "Analog offset Ch3 (integer!)"); 
struct arg_int * analog_offset_ch3	= arg_int1(NULL, "An_OffCh4", "<n>", "Analog offset Ch4 (integer!)"); 
struct arg_end * end_analog_input = arg_end(20);
void *argtable_analog_input[]  = {analog_input, channels_analog, analog_pwm,
						analog_src_ch0, analog_src_ch1, analog_src_ch2, analog_src_ch2,
						analog_gain_ch0, analog_gain_ch1, analog_gain_ch2, analog_gain_ch3,
						analog_ac_ch0, analog_ac_ch1, analog_ac_ch2, analog_ac_ch3,
						analog_offset_ch0, analog_offset_ch1, analog_offset_ch2, analog_offset_ch3,
						end_analog_input};

struct arg_lit  * message = arg_lit1(NULL, "message", "Displays debug information if the serial port is also used for the remote control");
struct arg_end * end_message = arg_end(20);
void *argtable_message[]  = {message, end_message};

struct arg_lit  * capture = arg_lit1(NULL, "capture", "Captures data");
struct arg_int * capture_size = arg_int1("s", "size", "<n>", "Capture data size in Dwords"); 
struct arg_int * capture_wait_time	= arg_int1(NULL,"waittime", "<n>", "Abourt time, before recording"); 
struct arg_int * capture_sampling_freq = arg_int1(NULL,"Fs", "<n>", "Sampling frequency"); 
struct arg_int * capture_sample_size = arg_int1(NULL,"SampleSize", "<n>", "Bits per sample"); 
struct arg_int * capture_channels	= arg_int1("n","Channels", "<n>", "Number of channels");
struct arg_file * wave_file = arg_file1("f","File","<file>", "Record data to this file");
struct arg_end * end_capture= arg_end(20);
void *argtable_capture[]  = {capture, capture_size, capture_wait_time, capture_sampling_freq, wave_file, 
					capture_channels, end_capture}; 
					
struct arg_lit * help = arg_lit0("hH","help", "Displays this help information");
struct arg_lit * version  = arg_lit0("vV","version", "Version");
struct arg_lit  * config = arg_lit0(NULL,"config", "Initializes the configuration file");
struct arg_end * end_help = arg_end(20);	
void *argtable_misc[] = {help, version, config, end_help};

#define SYNTAX_ERROR 2

void exit_waverecorder (uint32_t ret, Protocoll **dso)
{
	if(*dso != NULL)
	{
		delete *dso;
	}
	
	/* free all argtables */
	arg_freetable(argtable_screenshot, sizeof(argtable_screenshot)/sizeof(argtable_screenshot[0]));
	arg_freetable(argtable_loadrun, sizeof(argtable_loadrun)/sizeof(argtable_loadrun[0]));
	arg_freetable(argtable_read_addr, sizeof(argtable_read_addr)/sizeof(argtable_read_addr[0]));
	arg_freetable(argtable_write_addr, sizeof(argtable_write_addr)/sizeof(argtable_write_addr[0]));
	arg_freetable(argtable_debug, sizeof(argtable_debug)/sizeof(argtable_debug[0]));
	arg_freetable(argtable_trigger, sizeof(argtable_trigger)/sizeof(argtable_trigger[0]));
	arg_freetable(argtable_trigger_input, sizeof(argtable_trigger_input)/sizeof(argtable_trigger_input[0]));
	arg_freetable(argtable_analog_input, sizeof(argtable_analog_input)/sizeof(argtable_analog_input[0]));
	arg_freetable(argtable_message, sizeof(argtable_message)/sizeof(argtable_message[0]));
	arg_freetable(argtable_capture, sizeof(argtable_capture)/sizeof(argtable_capture[0]));
	arg_freetable(argtable_misc, sizeof(argtable_misc)/sizeof(argtable_misc[0]));
	
	if (ret == true)
	{
		cout << "Success!" << endl;
		exit(0);
	 }
	 else if (ret == false) 
	{
		cout << "Error in communication!" << endl;
		exit(3);
	 } 
	 else 
	 {
		cout << "Syntax error!" << endl;
		exit(SYNTAX_ERROR);
	}	
}

const string defaut_serial_interface = "Com4";
const int default_baudrate = 115200;
const int default_channels = 2;

string serial_interface = "";
int baudrate = -1;
int channels = -1;

const string interface_identifier = "SERIAL_INTERFACE";
const string baudrate_Iidentifier = "BAUD";
const string channel_identifier = "CHANNELS";

const string configfile_name = "waverecorder.cfg";

const string default_screenshot_name = "screenshot";

void split(string str, vector<string>& tokens, string delimiters)
{
	string::size_type lastPos = str.find_first_not_of(delimiters, 0);
	string::size_type pos = str.find_first_of(delimiters, lastPos);

	while (string::npos != pos || string::npos != lastPos)
	{
		// Found a token, add it to the vector.
		tokens.push_back(str.substr(lastPos, pos - lastPos));
		// Skip delimiters.  Note the "not_of"
		lastPos = str.find_first_not_of(delimiters, pos);
		// Find next "non-delimiter"
		pos = str.find_first_of(delimiters, lastPos);
	}
}


void parse_config_line(string line)
{
	string identifier;
	string data;
	vector<string> token;
	
	split(line, token, "=");
	
	if(token.size() != 2) 	//No valid configuration command
	{
		return;
	}
	
	identifier = token[0];
	data = token[1];

	/*
	 * Add additional configuration parameters here
	 */
	if(identifier.compare(interface_identifier) == 0)
	{
		serial_interface = data;
	} 
	else if(identifier.compare(baudrate_Iidentifier) == 0)
	{
		baudrate = atoi(data.c_str());
	}
	else if(identifier.compare(channel_identifier) == 0)
	{
		channels = atoi(data.c_str());
	}
	else
	{
		cout << "Unrecognized argument: " << identifier;
	}
}
	
	

bool read_configuration(void)
{
	ifstream config (configfile_name.c_str());
	
	if(config.is_open() == false)
	{
		cout << "Couldn't read configuration!" << endl;
		return false;
	}
	
	string token;
	while(!config.eof())
	{
		getline(config, token);
		parse_config_line(token);
	}
	
	config.close();
	
	if(serial_interface.compare("") == 0 || baudrate == -1 || channels == -1)
	{
		cout << "Wrong configuration. Try again." << endl;
		return false;
	}

	return true;
}

void write_configuration(void)
{
	ofstream config (configfile_name.c_str());
	
	if(config.is_open() == false)
	{
		cout << "Couldn't open configfile '" << configfile_name <<"'" << endl;
		exit(-1);
	}
	
	config << interface_identifier << "=" << serial_interface << endl;
	config << baudrate_Iidentifier << "=" << baudrate << endl;
	config << channel_identifier << "=" << channels << endl;
	
	config.close();
}

void init_configuration(void)
{
	string line;
	
	cout << "Waverecorder Configuration" << endl;
	
	cout << "Enter Interface. Default: <" << defaut_serial_interface << ">" << endl;
	getline(cin, line);
	
	if(line.compare("") == 0)
	{
		serial_interface = defaut_serial_interface;
	}
	else
	{
		serial_interface = line;
	}

	cout << "Enter Baudrate. Default: <" << default_baudrate << ">" << endl;
	getline(cin, line);
	
	if(line.compare("") == 0)
	{
		baudrate = default_baudrate;
	}
	else
	{
		baudrate = atoi(line.c_str());
	}
	
	cout << "Enter Channels. Default: <" << default_channels << ">" << endl;
	getline(cin, line);
	
	if(line.compare("") == 0)
	{
		channels = default_channels;
	}
	else
	{
		channels = atoi(line.c_str());
	}
	
	write_configuration();
}

/* 
 * type = 0: Debug Interface FPGA
 * type = 1: Communication Interface to Leon3
 */
#define DEBUG_INTERFACE 			0
#define COMMUNICATION_INTERFACE 	1

void open_interface(int type, Protocoll **dso)
{
	switch(type)
	{
		case DEBUG_INTERFACE:
			*dso = new RemoteSignalCapture(new DebugUart);
			if ((*dso)->InitComm((char*) serial_interface.c_str(), 5000, baudrate) == false)
			{
				/* Could not initialize UART */
				cout << "Couldn't initialize debug interface. Settings: " << serial_interface << ", " << baudrate << endl;
				exit_waverecorder(false, dso);
			}
		break;
		case COMMUNICATION_INTERFACE:
			*dso =  new Request(new NormalUart);
			if ((*dso)->InitComm((char*) serial_interface.c_str(), 5000, baudrate) == false)
			{
				/* Could not initialize UART */
				cout << "Couldn't initialize communication interface. Settings: " << serial_interface << ", " << baudrate << endl;
				exit_waverecorder(false, dso);
			}
		break;
		default:
			cout << "Interface Error: Wrong Interface!" << endl;
			exit_waverecorder(false, dso);
		break;
	}
}


int main(int argc, char * argv[]) 
{
	/* Override parsing function with a custom one */
	sampling_freq->hdr.scanfn        = (arg_scanfn*)arg_exp_scanfn;
	trigger_low_level->hdr.scanfn   = (arg_scanfn*)arg_exp_scanfn;
	trigger_high_level->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	trigger_low_time->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	trigger_high_time->hdr.scanfn = (arg_scanfn*)arg_exp_scanfn;
	analog_gain_ch0->hdr.scanfn       = (arg_scanfn*)arg_exp_scanfn;
	analog_gain_ch1->hdr.scanfn       = (arg_scanfn*)arg_exp_scanfn;
	analog_gain_ch2->hdr.scanfn       = (arg_scanfn*)arg_exp_scanfn;
	analog_gain_ch3->hdr.scanfn       = (arg_scanfn*)arg_exp_scanfn;
	analog_offset_ch0->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	analog_offset_ch1->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	analog_offset_ch2->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	analog_offset_ch3->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	capture_wait_time->hdr.scanfn        = (arg_scanfn*)arg_exp_scanfn;
	capture_size->hdr.scanfn         = (arg_scanfn*)arg_exp_scanfn;
	capture_sampling_freq->hdr.scanfn = (arg_scanfn*)arg_exp_scanfn;
	data_write->hdr.scanfn            = (arg_scanfn*)arg_exp_scanfn;
	cap_size_read->hdr.scanfn            = (arg_scanfn*)arg_exp_scanfn;

	
	/* Parse all argument tables */
	int nerrors_screenshot = arg_parse(argc,argv,argtable_screenshot);
	int nerrors_loadrun = arg_parse(argc,argv,argtable_loadrun);
	int nerrors_read_adress = arg_parse(argc,argv,argtable_read_addr);
	int nerrors_write_adress = arg_parse(argc,argv,argtable_write_addr);
	int nerrors_debug = arg_parse(argc,argv, argtable_debug);
	int nerrors_trigger = arg_parse(argc,argv, argtable_trigger);
	int nerrors_trigger_input = arg_parse(argc,argv, argtable_trigger_input); 
	int nerrors_analog_input = arg_parse(argc,argv, argtable_analog_input); 
	int nerrors_message = arg_parse(argc,argv, argtable_message); 
	int nerrors_capture = arg_parse(argc,argv, argtable_capture); 
	int nerrors_misc = arg_parse(argc,argv, argtable_misc); 
	
	Protocoll * DSOInterface = NULL;
	
	if(read_configuration() == false) 	//Couldn't read configuration file
	{
		init_configuration();
	}
	
	if(nerrors_misc == 0)
	{
		if(help->count != 0)
		{
			cout << "DSO specific commands:" << endl <<endl;

			arg_print_glossary(stdout,argtable_trigger_input,0);
			cout << endl;
			arg_print_glossary(stdout,argtable_trigger, 0);
			cout << endl << endl;
			arg_print_glossary(stdout,argtable_analog_input,0);
			cout << endl << endl;
			arg_print_glossary(stdout,argtable_capture,0);
			cout << endl << endl;
			arg_print_glossary(stdout,argtable_message,0);
			cout << endl << endl;
			arg_print_glossary(stdout,argtable_screenshot,0);
			cout << endl << endl;
			
			cout << "LEON3 Debugging commands:" << endl << endl;
			
			arg_print_glossary(stdout,argtable_read_addr,0);
			cout << endl << endl;
			arg_print_glossary(stdout,argtable_write_addr,0);
			cout << endl << endl;
			arg_print_glossary(stdout,argtable_loadrun,0);
			cout << endl << endl;
			arg_print_glossary(stdout,argtable_debug,0);
			cout << endl << endl;
			
			cout << "Miscellaneous commands:" << endl << endl;
			
			arg_print_glossary(stdout,argtable_misc,0);
			cout << endl << endl;
		}
		
		if(version->count != 0)
		{
			cout << "Version 0.2, compile time: " << __DATE__ << " " << __TIME__ << " (development stage)" << endl;
			cout << "Author: Alexander Lindert" << endl;
			cout << "\tRobert Schilling" << endl;
			cout << "Remote control for Open Source Digital Storage Scopes" << endl;
		}
		
		if(config->count != 0)
		{
			init_configuration();
		}
		exit_waverecorder(true, &DSOInterface);
	}
	
	if(nerrors_loadrun == 0)
	{
		uint32_t base_addr = RAM_BASE_ADDR;
		uint32_t stack = RAM_BASE_ADDR + RAM_SIZE - 0x80;
		uint32_t ret;
		
		open_interface(DEBUG_INTERFACE, &DSOInterface);
		
		if(stack_addr->count != 0)
		{
			stack = stack_addr->ival[0];
		}

		ret = DSOInterface->LoadProgram(loadrun_filename->filename[0], base_addr, stack);
		
		exit_waverecorder(ret, &DSOInterface);
	}

	if(nerrors_screenshot == 0)
	{
		string filename;
		uint32_t ret;
		
		open_interface(COMMUNICATION_INTERFACE, &DSOInterface);
		
		if (screenshot_filename->count != 0)
		{
			/* Aditional filename argument */
			filename = screenshot_filename->filename[0];
			
			fstream file(filename.c_str(), ios::in);
			if(file.is_open())
			{
				file.close();
				cout << "Filename '" << filename << "' already exists!" << endl;
				exit_waverecorder(false, &DSOInterface);
				
			}
			file.close();
		}
		else
		{
			/* Default filename */
			int number = 0;
			fstream file;
			stringstream ss_filename;
			
			do
			{
				file.close();
				ss_filename.str("");	//delete string
				ss_filename << default_screenshot_name << number;;
				file.open((ss_filename.str() + ".bmp").c_str(), ios::in);
				number++;
			}
			while(file.is_open());
			file.close();
			filename = ss_filename.str();
		}
		
		ret = DSOInterface->Screenshot(filename.c_str());
		exit_waverecorder(ret, &DSOInterface);
		
	}
		
	if(nerrors_read_adress == 0)
	{
		uint32_t ret;
		
		open_interface(DEBUG_INTERFACE, &DSOInterface);
		
		ret = DSOInterface->Receive(address_read->ival[0], cap_size_read->ival[0]);
	
		exit_waverecorder(ret, &DSOInterface);	
	}
	
	if(nerrors_write_adress == 0)
	{
		uint32_t ret;
		uint32_t length = data_write->count;
		open_interface(DEBUG_INTERFACE, &DSOInterface);
		
		if(data_write->count != 0 &&  file_write->count != 0)
		{
			cout << "Write data not set -d=<n> | --Data=<n> | File=<file>" << endl;
			exit_waverecorder(ret, &DSOInterface);
		}
		else if(data_write->count == 0 &&  file_write->count == 0)
		{
			cout << "Only set -d=<n>, --Data=<n> or File=<file>" << endl;
			exit_waverecorder(ret, &DSOInterface);
		}
		else if (file_write->count != 0) 
		{
			ret = DSOInterface->SendRAWFile(address_write->ival[0], file_write->filename[0]);
		} 
		else if (length == 0) 
		{
			cout << "Parameter -d or --Data set but specified no data" << endl;
			exit_waverecorder(ret, &DSOInterface);
		}
		else 
		{
			ret = DSOInterface->Send(address_write->ival[0], (uint32_t*)&data_write->ival[0], length);
		}
		exit_waverecorder(ret, &DSOInterface);
	}
	
	if(nerrors_debug == 0)
	{
		uint32_t ret;
		open_interface(DEBUG_INTERFACE, &DSOInterface);
		ret = DSOInterface->Debug();
		exit_waverecorder(ret, &DSOInterface);
	}
	
	if(nerrors_message == 0)
	{
		/* Todo: refractor to Dso_Remote -> ReceiveAll() */
		uint32_t fastMode = 0;
		uint32_t buffer = 0;
		uint32_t ret;
		
		open_interface(DEBUG_INTERFACE, &DSOInterface);
		
		ret = DSOInterface->ReceiveSamples(-1, 1, 0, &fastMode, &buffer);
		exit_waverecorder(ret, &DSOInterface);
	}
	
	if(nerrors_trigger_input == 0)
	{
		uint32_t ret;
		
		open_interface(DEBUG_INTERFACE, &DSOInterface);
		
		ret = DSOInterface->SendTriggerInput(
			trigger_channels->ival[0],
			sample_size->ival[0],
			sampling_freq->ival[0],
			aac_filter_start->ival[0],
			aac_filter_stop->ival[0],
			ch0_src->ival[0],
			ch1_src->ival[0],
			ch2_src->ival[0],
			ch3_src->ival[0]);

		exit_waverecorder(ret, &DSOInterface);	
	}
	
	if(nerrors_trigger == 0)
	{
		uint32_t trigger_nr, ret;
			
		open_interface(DEBUG_INTERFACE, &DSOInterface);
		
		if (strcmp(trigger_type->sval[0], "ExtLH") == 0)
		{
			trigger_nr = 0;
		} 
		else if (strcmp(trigger_type->sval[0], "ExtHL") == 0)
		{
			trigger_nr = 1;
		} 
		else if (strcmp(trigger_type->sval[0], "SchmittLH") == 0)
		{
			trigger_nr = 2;
		} 
		else if (strcmp(trigger_type->sval[0], "SchmittHL") == 0)
		{
			trigger_nr = 3;
		} 
		else if (strcmp(trigger_type->sval[0], "GlitchLH") == 0)
		{
			trigger_nr = 4;
		} 
		else if (strcmp(trigger_type->sval[0], "GlitchHL") == 0)
		{
			trigger_nr = 5;
		} 
		else if (strcmp(trigger_type->sval[0], "DigitalArrive") == 0)
		{
			trigger_nr = 6;
		} 
		else if (strcmp(trigger_type->sval[0], "DigitalLeave") == 0)
		{
			trigger_nr = 7;
		} 
		else
		{	
			cout << "Invalid trigger type, forced capturing set instead!\n" << endl;
			trigger_nr = 0;
			external_trigger->ival[0] = 0;
		}
		
		ret = DSOInterface->SendTrigger(trigger_nr, external_trigger->ival[0], trigger_channel->ival[0],
								trigger_prefetch->ival[0], trigger_low_level->ival[0], trigger_high_level->ival[0],
								trigger_low_time->ival[0], trigger_high_time->ival[0]);
		
		exit_waverecorder(ret, &DSOInterface);	
	}
	
	if(nerrors_analog_input == 0)
	{
		SetAnalog analog_settings[4];
		struct arg_int * gain[4] = {analog_gain_ch0, analog_gain_ch1, analog_gain_ch2, analog_gain_ch3};
		struct arg_lit * ac[4]   = {analog_ac_ch0, analog_ac_ch1, analog_ac_ch2, analog_ac_ch3};
		struct arg_int * dac_offset[4] = {analog_offset_ch0 , analog_offset_ch1, analog_offset_ch2, analog_offset_ch3}; 
		struct arg_str * src[4] = {analog_src_ch0, analog_src_ch1, analog_src_ch2, analog_src_ch3};
		
		uint32_t ret;
		uint32_t channels = channels_analog->ival[0];
		
		open_interface(DEBUG_INTERFACE, &DSOInterface);
		
		for (uint32_t i=0; i<channels; i++) 
		{
			analog_settings[i].myVperDiv = gain[i]->ival[0];
			analog_settings[i].AC 		= ac[i]->count;
			analog_settings[i].DA_Offset	= dac_offset[i]->ival[0];
			analog_settings[i].Specific	= analog_pwm->ival[0];
			analog_settings[i].Mode = normal;
			
			if (strcmp("pwm",src[i]->sval[0]) == 0)
			{
				analog_settings[i].Mode = pwm_offset;
			} 
			else if (strcmp("gnd",src[i]->sval[0]) == 0)
			{
				analog_settings[i].Mode = gnd;
			} 
			else if (strcmp("lowpass",src[i]->sval[0]) == 0)
			{
				analog_settings[i].Mode = lowpass;
			}
		}	

		ret = DSOInterface->SendAnalogInput(channels, analog_settings);
		exit_waverecorder(ret, &DSOInterface);	
	}
	
	if(nerrors_capture == 0)
	{
		uSample * buffer = new uSample[capture_size->ival[0]*sizeof(int)];
		uint32_t fastMode = 0;
		uint32_t ret;
		
		open_interface(DEBUG_INTERFACE, &DSOInterface);
 
		ret = DSOInterface->ReceiveSamples(capture_wait_time->ival[0], 1, capture_size->ival[0], &fastMode, (uint32_t *)buffer);

		delete buffer;
		if (ret != 0)
		{
			RecordWave(buffer,(char*)wave_file->filename[0], ret, capture_sampling_freq->ival[0],capture_channels->ival[0], capture_sample_size->ival[0], fastMode);
			exit_waverecorder(ret, &DSOInterface);
		 } 
		 else 
		{
			exit_waverecorder(ret, &DSOInterface);
		}		
	}

	cout << "Unknown Command, Try -h or --help for help!" << endl;
	exit_waverecorder(false, &DSOInterface);
	return 0;
}
