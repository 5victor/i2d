/* driver.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "wishbone.sv"
`include "i2d_core_defines.sv"

class driver;
virtual wishbone.pl_slave ibus;
virtual wishbone.pl_slave dbus;
mailbox	instr;
generator gen;

function new(virtual wishbone.pl_slave ibus, virtual wishbone.pl_slave dbus,
		ref mailbox instr);
	this.ibus = ibus;
	this.dbus = dbus;
	this.instr = instr;
	this.gen = new();
endfunction

task run;
fork
begin
forever begin
	@dbus.cb;
	if (dbus.cb.stb == 1) begin
		dbus.cb.dat_so <= $random;
		dbus.cb.ack <= 1;
		ibus.cb.rty <= 1;
	end
	else if (ibus.cb.stb == 1) begin
		assert (gen.randomize())
		else $info("gen.randmoize fial\n");
		ibus.cb.dat_so <= gen.instr;
		ibus.cb.ack <= 1;
		dbus.cb.ack <= 0;
	end
	else begin
		dbus.cb.ack <= 0;
		ibus.cb.ack <= 0;
	end
	display_bus(ibus, dbus);
end
end
join_none
endtask

function void  display_bus(virtual wishbone.pl_slave ibus,
	virtual wishbone.pl_slave dbus);
	$display("ibus: adr=%h dat_mo=%h sel=%0b cyc=%0d stb=%0d we=%0d dat_so=%h ack=%0d rty=%0d err=%0d stall=%0d\n",
	ibus.cb.adr, ibus.cb.dat_mo, ibus.cb.sel, ibus.cb.cyc, ibus.cb.stb,
	ibus.cb.we, ibus.cb.dat_so, ibus.cb.ack, ibus.cb.rty, ibus.cb.err,
	ibus.cb.stall
	);
	$display("dbus.cb. adr=%h dat_mo=%h sel=%0b cyc=%0d stb=%0d we=%0d dat_so=%h ack=%0d rty=%0d err=%0d stall=%0d\n",
	dbus.cb.adr, dbus.cb.dat_mo, dbus.cb.sel, dbus.cb.cyc, dbus.cb.stb,
	dbus.cb.we, dbus.cb.dat_so, dbus.cb.ack, dbus.cb.rty, dbus.cb.err,
	dbus.cb.stall
	);
endfunction

endclass
