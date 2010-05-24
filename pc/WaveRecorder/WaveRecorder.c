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

struct arg_lit  * config = arg_lit1(NULL,"config", "Initializes the configuration file");
struct arg_str * uart = arg_str1("u", "UART", NULL, "UART adress for communication");
struct arg_int * arg_baudrate = arg_int1("b","Baudrate",NULL,"Baudrate for UART communication");
struct arg_end * end_config = arg_end(20);
void *argtable_config[] = {config, uart, arg_baudrate, end_config};

struct arg_lit  * loadrun = arg_lit1(NULL,"loadrun", "Loads a firmware to the Leon3 processor");
struct arg_file * loadrun_filename = arg_file1("f", "File", "<file>", "Binary file for the direct DSO CPU access (binary software file)");
struct arg_end * end_loadrun = arg_end(20);
void *argtable_loadrun[] = {loadrun, loadrun_filename, end_loadrun};

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

struct arg_lit  * debug = arg_lit1(NULL,"debug", "Generates a debug trace");
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
struct arg_int * external_trigger = arg_int1(NULL,"ExtTrigger","<n>", "External trigger, #0 = always, #1 = external trigger 1, #n = external trigger n");
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

struct arg_lit  * message = arg_lit1(NULL, "message", "Reads out a message");
struct arg_end * end_message = arg_end(20);
void *argtable_message[]  = {message, end_message};

struct arg_lit  * capture = arg_lit1(NULL, "capture", "Captures data");
struct arg_int * capture_size = arg_int1("s", "size", "<n>", "Capture data size in Dwords"); 
struct arg_int * capture_wait_time	= arg_int1(NULL,"waittime", "<n>", "Abourt time, before recording"); 
struct arg_int * capture_sampling_freq = arg_int1(NULL,"Fs",		"<n>",	"Sampling frequency"); 
struct arg_int * capture_sample_size = arg_int1(NULL,"SampleSize",	"<n>",	"Bits per sample"); 
struct arg_int * capture_channels	= arg_int1("n","Channels",	"<n>",	"Number of channels");
struct arg_file * wave_file = arg_file1("f","File","<file>", "Record data to this file");
struct arg_end * end_capture= arg_end(20);
void *argtable_capture[]  = {capture, capture_size, capture_wait_time, capture_sampling_freq, wave_file, 
					capture_channels, end_capture}; 
					
struct arg_lit * help = arg_lit0("hH","help", "Displays this help information");
struct arg_lit * version  = arg_lit0("vV","version", "Version");
struct arg_end * end_help = arg_end(20);	
void *argtable_help[] = {help, version, end_help};

#define SYNTAX_ERROR 2

#if 0
uint32_t CheckArgCount (	
		void * 	IsCount, 
		const struct arg_str * Command,
		const int		count,
		const int		size){ 
	int i = 0;
	int nerrors = 0;
	arg_lit ** IsX = (arg_lit **)IsCount;
	for(i = 0; i < size; ++i){
		if (IsX[i]->count != count){
			printf("With --Command=%s also %d --%s= argument is/are needed!\n", Command->sval[0], count, IsX[i]->hdr.longopts);
			nerrors++;		
		}
	}
	if (nerrors != 0){
		return SYNTAX_ERROR;
	}
	return TRUE;
}
#endif

void exit_waverecorder (uint32_t ret, Protocoll **dso)
{
	delete *dso;
	
	/* free all argtables */
	arg_freetable(argtable_config, sizeof(argtable_config)/sizeof(argtable_config[0]));
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
	arg_freetable(argtable_help, sizeof(argtable_help)/sizeof(argtable_help[0]));
	
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

const string defaut_interface = "Com4";
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
	cout << "Waverecorder Configuration" << endl;
	
	cout << "Enter Interface. Default: <" << defaut_interface << ">" << endl;
	cin >> serial_interface;
	cout << endl;
	
	cout << "Enter Baudrate. Default: <" << default_baudrate << ">" << endl;
	cin >> baudrate;
	cout << endl;
	
	cout << "Enter Channels. Default: <" << default_channels << ">" << endl;
	cin >> channels;
	cout << endl;
	
	write_configuration();
}

/* 
 * type = 0: Debug Interface FPGA
 * type = 1: Communication Interface to Leon3
 */
#define DEBUG_INTERFACE 0
#define COMMUNICATION_INTERFACE 1

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
	/* Parse all argument tables */
	int nerrors_config = arg_parse(argc,argv,argtable_config);
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
	int nerrors_help = arg_parse(argc,argv, argtable_help); 
	
	Protocoll * DSOInterface = NULL;
	
	if(read_configuration() == false) 	//Couldn't read configuration file
	{
		init_configuration();
	}
	
	if(nerrors_help == 0)
	{
		if(help->count != 0)
		{
			cout << "Help" << endl;
		}
		if(version->count != 0)
		{
			cout << "Version 0.1.1, compile time: " << __DATE__ << " " << __TIME__ << " (development stage)" << endl;
			cout << "Author: Alexander Lindert" << endl;
			cout << "\t\tRobert Schilling" << endl;
			cout << "Remote Control for Open Source Digital Storage Scopes" << endl;
		}
		exit_waverecorder(true, &DSOInterface);
	}
	
	if(nerrors_config == 0)
	{
		cout << "Config" << endl;
	}
	
	if(nerrors_loadrun == 0)
	{
		uint32_t base_addr = RAM_BASE_ADDR;
		uint32_t stack = RAM_BASE_ADDR + RAM_SIZE - 0x80;
		uint32_t ret;
		
		open_interface(DEBUG_INTERFACE, &DSOInterface);

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

#if 0	
	SampleFS->hdr.scanfn        = (arg_scanfn*)arg_exp_scanfn;
	TriggerLowRef->hdr.scanfn   = (arg_scanfn*)arg_exp_scanfn;
	TriggerHighRef->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	TriggerLowTime->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	TriggerHighTime->hdr.scanfn = (arg_scanfn*)arg_exp_scanfn;
	AnGainCh0->hdr.scanfn       = (arg_scanfn*)arg_exp_scanfn;
	AnGainCh1->hdr.scanfn       = (arg_scanfn*)arg_exp_scanfn;
	AnGainCh2->hdr.scanfn       = (arg_scanfn*)arg_exp_scanfn;
	AnGainCh3->hdr.scanfn       = (arg_scanfn*)arg_exp_scanfn;
	AnDA_OffsetCh0->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	AnDA_OffsetCh1->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	AnDA_OffsetCh2->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	AnDA_OffsetCh3->hdr.scanfn  = (arg_scanfn*)arg_exp_scanfn;
	CapWTime->hdr.scanfn        = (arg_scanfn*)arg_exp_scanfn;
	CapSize->hdr.scanfn         = (arg_scanfn*)arg_exp_scanfn;
	Data->hdr.scanfn            = (arg_scanfn*)arg_exp_scanfn;
#endif

#if 0	
	if (help->count != 0)
	{
		printf("\nDSO specific commands:\n\n");
		printf("TriggerInput \t... Sets the sampling rate, lowpass-filters and the pre trigger mux. \n"); 
		printf("Trigger \t... Sets the trigger type and values. \n"); 
		printf("AnalogSettings \t... Sets the voltage range, dc offset and so on.\n"); 
		printf("Capture \t... Captures raw data from the scope.\n"); 
		printf("Message \t... Displays debug information if the serial port is also used for the remote control.\n");
		printf("\nLEON3 Debugging commands:\n\n");
		printf("ReadAddr \t... Reads -s DWORDs with the start address Faddr.\n"); 
		printf("WriteAddr \t... Writes -d or --Ffile data to start address Faddr \n"); 
		printf("LoadRun \t... Loads the software into the FPGA.\n"); 
		printf("DumpPC \t\t... Generates a backtrace output\n"); 
		printf("Screenshot \t... Generates a screenshot\n");
		printf("\nCommand line arguments\n\n");
		arg_print_glossary(stdout,argtable,0);
		printf("\n");
		arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
		return 0;
	}
#endif	
	

#if 0	
	if (nerrors != 0) 
	{
		arg_print_errors(stdout,end,argv[0]);
		printf("Failed: Try option -h or --help for a detailed help information!\n");
		arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
		return 1;
	}	
#endif
#if 0	
	if (strcmp("Debugger",Protocol->sval[0]) == 0) 
	{
		DSOInterface = new RemoteSignalCapture(new DebugUart);
	} 
	else 
	{
		DSOInterface = new Request(new NormalUart);
	}
	
	if (DSOInterface == 0) 
	{
		arg_freetable(argtable,sizeof(argtable)/sizeof(argtable[0]));
		return 2;
	}

	if (!DSOInterface->InitComm((char*)serial_interface.c_str(),5000,baudrate))
	{
		exit_waverecorder(false,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
	}
#endif

	#if 0
	if (strcmp("LoadRun",Command->sval[0]) == 0)
	{
		struct arg_int * IsOnce[] = {(arg_int*)ForceFile};
		int32_t Ret = CheckArgCount((void*)IsOnce,Command,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		
		if (ForceAddr->count == 1)
		{
			//BaseAddr = ForceAddr->ival[0];
			printf("Ignorig user FAddr\n");
		}
		if (StackAddr->count == 1)
		{
			Stack = StackAddr->ival[0];
		}
		
		if (Ret != TRUE) 
		{
			printf("%s:%d\n",__FILE__,__LINE__);
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		}
		
		exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
	}
	#endif
    #if 0    
	if (strcmp("Debug",Command->sval[0]) == 0){
		int32_t Ret = DSOInterface->Debug();
		exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
	}
	#endif

	#if 0
    if (strcmp("Screenshot",Command->sval[0]) == 0) 
	{
		struct arg_int * IsOnce[] = {(arg_int*)ImageFile};
		uint32_t Ret = CheckArgCount((void*)IsOnce,Command,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		if (Ret != TRUE) 
		{
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		}
		
		Ret = DSOInterface ->Screenshot(ImageFile->filename[0]);
		exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
	}
	#endif

	#if 0
	if (strcmp("ReadAddr",Command->sval[0]) == 0) 
	{
		struct arg_int * IsOnce[] = {(arg_int*)ForceAddr, CapSize};
		uint32_t Ret = CheckArgCount((void*)IsOnce,Command,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		uint32_t addr = 0;
		if (Ret != TRUE) {
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		}
		addr = ForceAddr->ival[0];
		Ret = DSOInterface->Receive(
			addr,
			CapSize->ival[0]);
		exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);	
	}
	#endif

	#if 0
	if (strcmp("WriteAddr",Command->sval[0]) == 0) {
		
		struct arg_int * IsOnce[] = {(arg_int*)ForceAddr};
		uint32_t Ret = CheckArgCount((void*)IsOnce,Command,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		if (Ret != TRUE) 
		{
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		}
		
		uint32_t addr = ForceAddr->ival[0];

		uint32_t * data = (uint32_t*)&Data->ival[0];
		uint32_t length = Data->count;
		
		if (ForceFile->count != 0) 
		{
			DSOInterface->SendRAWFile(
				addr,
				ForceFile->filename[0]);
		} else if (length == 0) 
		{
			printf("Write data not set -d=<n> | --Data=<n> | Ffile=<file>\n");
			exit_waverecorder(SYNTAX_ERROR,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		} else {
			Ret = DSOInterface->Send(
				addr,
				data,
				length);
		}
		exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);	
	}
	#endif

#if 0
	if (strcmp("TriggerInput",Command->sval[0]) == 0){
		struct arg_int * IsOnce[] = {
			Channels,SampleSize,SampleFS,AACFilterStart,AACFilterEnd,
			Ch0Src,Ch1Src,Ch2Src,Ch3Src};
		uint32_t Ret = CheckArgCount((void*)IsOnce,Command,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		if (Ret != TRUE) {
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		}	

		Ret = DSOInterface->SendTriggerInput(
			Channels->ival[0],
			SampleSize->ival[0],
			SampleFS->ival[0],
			AACFilterStart->ival[0],
			AACFilterEnd->ival[0],
			Ch0Src->ival[0],
			Ch1Src->ival[0],
			Ch2Src->ival[0],
			Ch3Src->ival[0]);

		exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);	
		
	}
#endif
#if 0
	if (strcmp("Trigger",Command->sval[0]) == 0){
		struct arg_int * IsOnce[] = {
			(arg_int*)Trigger, ExtTrigger, TrPrefetch,TriggerChannel,TriggerLowRef,TriggerHighRef,
			TriggerLowTime,TriggerHighTime};
		int TriggerNo = 2;
		uint32_t Ret = CheckArgCount(IsOnce,Command,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		if (Ret != TRUE) {
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		}	
		if (strcmp("ExtLH",Trigger->sval[0]) == 0){
			TriggerNo = 0;
		} else 
		if (strcmp("ExtHL",Trigger->sval[0]) == 0){
			TriggerNo = 1;
		} else 
		if (strcmp("SchmittLH",Trigger->sval[0]) == 0){
			TriggerNo = 2;
		} else 
		if (strcmp("SchmittHL",Trigger->sval[0]) == 0){
			TriggerNo = 3;
		} else 
		if (strcmp("GlitchLH",Trigger->sval[0]) == 0){
			TriggerNo = 4;
		} else 
		if (strcmp("GlitchHL",Trigger->sval[0]) == 0){
			TriggerNo = 5;
		} else 
		if (strcmp("DigitalArrive",Trigger->sval[0]) == 0){
			TriggerNo = 6;
		} else
		if (strcmp("DigitalLeave",Trigger->sval[0]) == 0){
			TriggerNo = 7;
		} else
		{	
			printf("Invalid trigger type, forced capturing set instead!\n");
			TriggerNo = 0;
			ExtTrigger->ival[0] = 0;
		}

		
		Ret = DSOInterface->SendTrigger(
			TriggerNo,
			ExtTrigger->ival[0],
			TriggerChannel->ival[0],
			TrPrefetch->ival[0],
			TriggerLowRef->ival[0],
			TriggerHighRef->ival[0],
			TriggerLowTime->ival[0],
			TriggerHighTime->ival[0]);
		exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);	
	}
#endif	
#if 0
	if (strcmp("AnalogSettings",Command->sval[0]) == 0){
		struct arg_int * IsOnce[] = {
			AnGainCh0,AnGainCh1,AnGainCh2,AnGainCh3,AnDA_OffsetCh0,
			AnDA_OffsetCh1,AnDA_OffsetCh2,AnDA_OffsetCh3,AnPWM,(arg_int*)AnSrc2Ch0,
			(arg_int*)AnSrc2Ch1,(arg_int*)AnSrc2Ch2,(arg_int*)AnSrc2Ch3};
		int i = 0;
		SetAnalog Settings[4];
		struct arg_int * Gain[4] = {AnGainCh0,AnGainCh1,AnGainCh2,AnGainCh3};
		struct arg_lit * AC[4]   = {AnAC_Ch0,AnAC_Ch1,AnAC_Ch2,AnAC_Ch3};
		struct arg_int * DAoff[4]= {AnDA_OffsetCh0,AnDA_OffsetCh1,AnDA_OffsetCh2,AnDA_OffsetCh3};	
		struct arg_str * Src2[4] = {AnSrc2Ch0,AnSrc2Ch1,AnSrc2Ch2,AnSrc2Ch3}; 
		uint32_t Ret = CheckArgCount(IsOnce,Command,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		if (Ret != TRUE) {
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		}
		for (i = 0; i < Channels->ival[0]; ++i) {
			Settings[i].myVperDiv 	= Gain[i]->ival[0];
			Settings[i].AC 		= AC[i]->count;
			Settings[i].DA_Offset	= DAoff[i]->ival[0];
			Settings[i].Specific	= AnPWM->ival[0];
			Settings[i].Mode = normal;
			if (strcmp("pwm",Src2[i]->sval[0]) == 0){
					Settings[i].Mode = pwm_offset;
			}
			if (strcmp("gnd",Src2[i]->sval[0]) == 0){
					Settings[i].Mode = gnd;
			}
			if (strcmp("lowpass",Src2[i]->sval[0]) == 0){
					Settings[i].Mode = lowpass;
			}
		}	

		Ret = DSOInterface->SendAnalogInput(Channels->ival[0], Settings);
		exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);		
	}
#endif

	#if 0
	if (strcmp("Message",Command->sval[0]) == 0){
		uint32_t FastMode = 0;
		uint32_t buffer = 0;
		DSOInterface->ReceiveSamples(
			-1,
			1,
			0,
			&FastMode,
			&buffer);
		exit_waverecorder(false,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
	}
	#endif

	#if 0
	if (strcmp("Capture",Command->sval[0]) == 0){
		struct arg_int * IsOnce[] = {
			Channels,SampleSize,SampleFS,CapWTime,CapSize,
			WavForceFS,(arg_int*)WaveFile};
		uint32_t Ret = CheckArgCount(IsOnce,Command,1,sizeof(IsOnce)/sizeof(IsOnce[0]));
		if (Ret != TRUE) {
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		}
		uSample * buffer = (uSample *)malloc(CapSize->ival[0]*sizeof(int));
		uint32_t FastMode = 0;
 
		if (buffer == 0){
			printf("Not enough memory aviable!\n");
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		}	
		Ret = DSOInterface->ReceiveSamples(
			CapWTime->ival[0],
			1,
			CapSize->ival[0],
			&FastMode,
			(uint32_t *)buffer);

/*		{
		int i = 0;
		int j = 0;
		FastMode = 1;
		for (i = 1; i <= 4; ++i){
			for (j = 8; j <= 32; j*=2){
			SampleSize->ival[0] = j;
			Channels->ival[0] = i;
			if (i*j <= 32){

		sprintf(WaveFile->filename[0],"c%d_b_%d.csv",i,j);
		Ret = 16;
		{
			unsigned int i = 0;
			for(;i < Ret; ++i){
				switch (j) {
					case 8:
						buffer[i].c[0] = 10+i;
						buffer[i].c[1] = 20+i;
						buffer[i].c[2] = -10-i;
						buffer[i].c[3] = -20-i;
						break;
					case 16:
						buffer[i].s[0] = i;
						buffer[i].s[1] = -i;
						break;
					case 32:
						buffer[i].i = i;
						break;
				}
			}
		}
*/	

        if (Ret != 0){
			RecordWave(buffer,(char*)WaveFile->filename[0],
				Ret,SampleFS->ival[0],Channels->ival[0],
				SampleSize->ival[0],FastMode);
			free(buffer);
			buffer = 0;
			exit_waverecorder(Ret,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		 } else {
			exit_waverecorder(false,argtable,sizeof(argtable)/sizeof(argtable[0]),DSOInterface);
		 }		
	/*	}}}} */
	}
	#endif
	
	cout << "Unknown Command, Try -h or --help for help!" << endl;
	exit_waverecorder(false, &DSOInterface);
	return 0;
}
