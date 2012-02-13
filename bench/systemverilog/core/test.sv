/* test.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

program test(
	input clk, rst,
	wishbone.pl_slave ibus,
	wishbone.pl_slave dbus,
	output irq, input irq_ack,
	ref mailbox mb[9]
);

virtual wishbone.pl_slave ibus_v;
virtual wishbone.pl_slave dbus_v;

endprogram
