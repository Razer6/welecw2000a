// This file disables the SandboxX ATmega128 external memory interface.
// It is nessesary to get the address databus free for the analog card.

// TODO:
// Additionally it can be used to generate test signals to test the fpga signal inputs.


#include <avr/io.h>
#include <avr/interrupt.h>
#include <avr/signal.h>

int main () {
	MCUCR = (1 << SM1);
	return 0;
}
