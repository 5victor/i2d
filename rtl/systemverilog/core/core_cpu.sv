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
wire	[3:0]	rega_addr;
wire	[3:0]	regb_addr;
wire	[31:0]	imm;
opmux_a_t		opmux_a;
opmux_b_t		opmux_b;
wire	[31:0]	id_pc;
instr_t	id_instr;

//core_rf_gpr output
wire	[31:0]	rega_data;
wire	[31:0]	regb_data;
wire	[31:0]	regm_data;

//core_operand_mux output
wire	[31:0]	operand_a;
wire	[31:0]	operand_b;

//core_alu output
flag_t flag;
wire	[31:0]	alu_result;

//core_mau output
wire		mau_busy;
wire	[3:0]	regm_addr;
wire	[31:0]	mau_data;

//core_ex output
wire	[3:0]	wb_addr;
wire		wb;
wire	[31:0]	wb_data;
instr_t ex_instr;
wire	[31:0]	ex_pc;



//other output
wire		if_halt;
wire		set_pc;
wire	[31:0]	new_pc;
wire		id_halt;
wire		flush;
sr_t sr;
wire		ex_halt;
flag_t flag_in = sr.flag;

core_if	core_if(.bus(ibus), .*);

core_mau core_mau(.*, .bus(dbus));

core_id core_id(.*);

core_rf_gpr core_rf_gpr(.*);

core_operand_mux core_operand_mux(.*);

core_alu core_alu(.*);

core_ex core_ex(.*);

endmodule

