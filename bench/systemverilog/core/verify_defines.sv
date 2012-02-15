/* verify_defines.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description: core component out
 *
 * TODO
 */

`ifndef VERIFY_DEFINES_SV
`define VERIFY_DEFINES_SV

`include "i2d_core_defines.sv"

class core_if_out;
	addr_t	if_pc;
	instr_t	if_instr;
	logic	if_err;
endclass

class core_id_out;
	reg_addr_t	rega_addr;
	reg_addr_t	regb_addr;
	data_t		imm;
	opmux_a_t	opmux_a;
	opmux_b_t	opmux_b;
	addr_t		id_pc;
	instr_t		id_instr;
	logic		swi;
	logic		branch_imm;
	logic		branch_abs;
	logic		rfe;
	reg_addr_t	spr_addr;
	logic		wb_spr;
	logic		id_err;
	logic		branch;
endclass

class core_rf_gpr_out;
	data_t	rega_data;
	data_t	regb_data;
endclass

class core_operand_mux_out;
	data_t	operand_a;
	data_t	operand_b;
endclass

class core_alu_out;
	flag_t	flag;
	data_t	alu_result;
endclass

class core_mau_out;
	logic	mau_busy;
	data_t	mau_data;
	logic	mau_err;
endclass

class core_ex_out;
	reg_addr_t	wb_addr;
	logic		wb;
	data_t		wb_data;
	instr_t		ex_instr;
	addr_t		ex_pc;
endclass

class core_rf_sr_out;
	sr_t sr;
endclass

class core_ctrl_out;
	reg_t	epc;
	sr_t	esr;
	logic	set_pc;
	addr_t	new_pc;
	mode_t	mode;
	logic	write_mode;
	sr_t	wb_sr;
	logic	write_sr;
	logic	if_halt;
	logic	id_halt;
	logic	id_flush;
	logic	ex_flush;
	logic	ex_halt;
endclass

typedef enum {
	CORE_IF, CORE_MAU, CORE_ID, CORE_RF_GPR, CORE_OPERAND_MUX,
	CORE_ALU, CORE_EX, CORE_RF_SR, CORE_CTRL
} mb_t;

`endif
