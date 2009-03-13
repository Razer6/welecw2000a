

#ifndef DSO_REMOTE_H
#define DSO_REMOTE_H

#define DSO_MASTER_HEADER "Digital Storage Scope Master "
#define DSO_SLAVE_HEADER  "Digital Storage Scope Slave  "
#define DSO_NAK_RESP      "NAK"
#define DSO_ACK_RESP      "ACK"

#define DSO_DATA           980
#define DSO_RESPONCE       990
#define SET_TRIGGER_INPUT 1000
#define SET_ANALOG_INPUT  1010
#define SET_TRIGGER       1020
#define CAPTURE_DATA      1030
#define STORE_DWORDS      1040
#define LOAD_DWORDS       1050
#define MAX_RX_ERRORS     100000

void RemoteSlave(	uart_regs * comm_uart,
			const unsigned int DataSize,
			int *Data);

#endif
