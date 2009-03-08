void Bootloader();

int _premain () {
	Bootloader();
	return 0;
}

#define STARTING_FRAME_OFFSET 0x80000000

void Bootloader () {
	int i = 0;
        int * a = 100000;
	*a = 3;
	for (;i< 5;++i) {
	switch (i) {
		case 0:
			*a = 1;
			break;
		case 1: 
			*a = 199;
			break;
		default :
			*a = 0;
	}
	}
}
