/* test.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

program automatic test(
	input clk, rst,
	wishbone.pl_slave ibus,
	wishbone.pl_slave dbus,
	output irq, input irq_ack,
	ref mailbox mb_out[9]
);

virtual wishbone.pl_slave ibus_v;
virtual wishbone.pl_slave dbus_v;

driver	drv;
monitor mon;
mailbox mb_instr;

initial begin
fork begin
	ibus_v = ibus;
	dbus_v = dbus;
	mb_instr = new(1);
	drv = new(ibus_v, dbus_v, mb_instr);
	drv.run();
	mon = new(mb_out, mb_instr);
	mon.run();

end
join

#1000;

end

endprogram
