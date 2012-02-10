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
	wishbone.pl_master dbus, input irq, output irq_ack
);
//core_if output
addr_t	if_pc;
data_t	if_instr;
wire	if_err;

//core_id output
wire	[3:0]	rega_addr;
wire	[3:0]	regb_addr;
wire	[31:0]	imm;
opmux_a_t		opmux_a;
opmux_b_t		opmux_b;
wire	[31:0]	id_pc;
instr_t	id_instr;
wire	swi;
wire	branch_imm;
wire	branch_abs;
wire	rfe;
reg_addr_t	spr_addr;
wire	wb_spr;
wire	id_err;
wire	branch;

//core_rf_gpr output
data_t	rega_data;
data_t	regb_data;

//core_operand_mux output
data_t	operand_a;
data_t	operand_b;

//core_alu output
flag_t flag;
data_t	alu_result;

//core_mau output
wire		mau_busy;
wire	[31:0]	mau_data;
wire	mau_err;

//core_ex output
wire	[3:0]	wb_addr;
wire		wb;
wire	[31:0]	wb_data;
instr_t ex_instr;
wire	[31:0]	ex_pc;

//core_rf_sr output
sr_t sr;
flag_t flag_in;

//core_ctrl output
reg_t	epc;
sr_t	esr;
wire		set_pc;
addr_t	new_pc;
mode_t	mode;
wire	write_mode;
sr_t	wb_sr;
wire	write_sr;
wire	if_halt;
wire	id_halt;
wire	id_flush;
wire	ex_flush;
wire	ex_halt;

//other
wire i;
wire write_i;

assign flag_in = sr.flag;

core_if	core_if(.bus(ibus), .*);

core_mau core_mau(.*, .bus(dbus));

core_id core_id(.*);

core_rf_gpr core_rf_gpr(.*);

core_operand_mux core_operand_mux(.*);

core_alu core_alu(.*);

core_ex core_ex(.*);

core_rf_sr core_rf_sr(.*);

core_ctrl core_ctrl(.*);

endmodule

