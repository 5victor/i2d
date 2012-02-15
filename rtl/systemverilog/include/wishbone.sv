/* filename
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`ifndef WISHBONE_SV
`define WISHBONE_SV

interface wishbone(input clk, rst);
parameter adr_width = 32;
parameter dat_width = 32;
parameter sel_width = 4;

logic	[adr_width-1:0]	adr;
logic	[dat_width-1:0] dat_mo;
logic	[sel_width-1:0] sel;
logic		cyc;
logic		stb;
logic		we;
logic	[dat_width-1:0]	dat_so;
logic		ack;
logic		rty;
logic		err;
logic		stall;

clocking cb @(posedge clk);
	input	adr, dat_mo, sel, cyc, stb, we;
	inout	dat_so, ack, rty, err, stall;
endclocking

modport	pl_master(
		output adr, dat_mo, sel, cyc, stb, we,
		input dat_so, ack, err, stall
);		

modport pl_slave(
		input adr, dat_mo, sel, cyc, stb, we,
		output dat_so, ack, err, stall,
		clocking cb
);

endinterface

`endif
