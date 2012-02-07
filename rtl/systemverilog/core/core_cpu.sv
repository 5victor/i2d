/* core_cpu.sv
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
`include "instruction.sv"

module core_cpu(
	input clk, rst,
	wishbone.pl_master ibus,
	wishbone.pl_master dbus
);
//core_if output
wire	[31:0]	if_pc;
wire	[31:0]	if_instr;
wire		if_busy;

//core_id output
wire	[3:0]	wb_addr;
wire	[3:0]	rega_addr;
wire	[3:0]	regb_addr;
wire	[31:0]	imm;
opmux_a		opmux_a;
opmux_b		opmux_b;
wire	[31:0]	id_pc;
instruction	id_instr;

//core_rf_gpr output
wire	[31:0]	rega_data;
wire	[31:0]	regb_data;

//core_operand_mux output
wire	[31:0]	operand_a;
wire	[31:0]	operand_b;

//core_alu output
wire		sr_cf;
wire		sr_of;
wire		sr_zf;
wire	[31:0]	result;

//other output
wire		if_halt;
wire		set_pc;
wire	[31:0]	new_pc;
wire		id_halt;
wire		flush;


core_if	core_if(.clk, .rst, .bus(ibus), .*);

core_id core_id(.*);

core_rf_gpr core_rf_gpr(.*);

core_operand_mux core_operand_mux(.*);

core_alu core_alu(.*);

endmodule

