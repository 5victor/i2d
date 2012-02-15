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
`include "verify_defines.sv"

module test_cpu(
	input clk, rst,
	wishbone.pl_master ibus,
	wishbone.pl_master dbus, input irq, output irq_ack,
	ref mailbox mb_out[9]
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
flag_t flag_in;

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

always @(posedge clk)
begin
	core_if_out		if_out;
	core_id_out		id_out;
	core_rf_gpr_out		rf_gpr_out;
	core_operand_mux_out	operand_mux_out;
	core_alu_out		alu_out;
	core_mau_out		mau_out;
	core_ex_out		ex_out;
	core_rf_sr_out		rf_sr_out;
	core_ctrl_out		ctrl_out;

	if_out = new();
	if_out.if_pc = if_pc;
	if_out.if_instr = if_instr;
	if_out.if_err = if_err;

	id_out = new();
	id_out.rega_addr = rega_addr;
	id_out.regb_addr = regb_addr;
	id_out.imm = imm;
	id_out.opmux_a = opmux_a;
	id_out.opmux_b = opmux_b;
	id_out.id_pc = id_pc;
	id_out.id_instr = id_instr;
	id_out.swi = swi;
	id_out.branch_imm = branch_imm;
	id_out.branch_abs = branch_abs;
	id_out.rfe = rfe;
	id_out.spr_addr = spr_addr;
	id_out.wb_spr = wb_spr;
	id_out.id_err = id_err;
	id_out. branch = branch;

	rf_gpr_out = new();
	rf_gpr_out.rega_data = rega_data;
	rf_gpr_out.regb_data = regb_data;

	operand_mux_out = new();
	operand_mux_out.operand_a = operand_a;
	operand_mux_out.operand_b = operand_b;

	alu_out = new();
	alu_out.flag = flag;
	alu_out.alu_result = alu_result;

	mau_out = new();
	mau_out.mau_busy = mau_busy;
	mau_out.mau_data = mau_data;

	ex_out = new();
	ex_out.wb_addr = wb_addr;
	ex_out.wb = wb;
	ex_out.wb_data = wb_data;
	ex_out.ex_instr = ex_instr;
	ex_out.ex_pc = ex_pc;

	rf_sr_out = new();
	rf_sr_out.sr = sr;

	ctrl_out = new();
	ctrl_out.epc = epc;
	ctrl_out.esr = esr;
	ctrl_out.set_pc = set_pc;
	ctrl_out.new_pc = new_pc;
	ctrl_out.mode = mode;
	ctrl_out.write_mode = write_mode;
	ctrl_out.wb_sr = wb_sr;
	ctrl_out.write_sr = write_sr;
	ctrl_out.if_halt = if_halt;
	ctrl_out.id_halt = id_halt;
	ctrl_out.id_flush = id_flush;
	ctrl_out.ex_flush = ex_flush;
	ctrl_out.ex_halt = ex_halt;
	
	mb_out[CORE_IF].put(if_out);
        mb_out[CORE_ID].put(id_out);
        mb_out[CORE_RF_GPR].put(rf_gpr_out);
        mb_out[CORE_OPERAND_MUX].put(operand_mux_out);
        mb_out[CORE_ALU].put(alu_out);
        mb_out[CORE_MAU].put(mau_out);
        mb_out[CORE_EX].put(ex_out);
        mb_out[CORE_RF_SR].put(rf_sr_out);
	mb_out[CORE_CTRL].put(ctrl_out);
end

endmodule

