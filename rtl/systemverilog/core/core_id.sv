/* core_id.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "i2d_core_defines.sv"

module core_id(
	input clk, rst,
	input addr_t if_pc, input instr_t if_instr, input id_halt, id_flush,
	input reg_addr_t wb_addr, input flag_t flag,
	output reg_addr_t rega_addr, output reg_addr_t regb_addr,
	output logic swi, output data_t imm, output opmux_a_t opmux_a,
	output opmux_b_t opmux_b, output addr_t id_pc,
	output instr_t id_instr, output logic branch_imm,
	output logic branch_abs, rfe, output reg_addr_t spr_addr,
	output logic wb_spr, id_err, branch
);
//logic	[31:0]	id_pc;
//instruction	id_instr;
logic	opcode_err;

assign rega_addr = if_instr.rega;
assign regb_addr = if_instr.regb;

always_ff @(posedge clk, negedge rst)
begin
	if (!rst) begin
		id_pc <= 0;
		id_instr <= {OPCODE_NOP,26'(0)};
	end
	else if (id_flush)
		id_instr <= {OPCODE_NOP,26'(1)}; // for record flush nop
	else if (id_halt) begin
		id_pc <= id_pc;
		id_instr <= id_instr;
	end
	else begin
		id_pc <= if_pc;
		id_instr <= if_instr;
	end
end

//decode imm
always_ff @(posedge clk)
begin
	if(id_instr.i) begin
		if (id_instr.s)
			imm[31:11] = {21{id_instr[10]}};
		else
			imm[31:11] = '0;
		imm[10:0] = id_instr[10:0];
		end
	else
		imm = '0;
end

//decode operandmux
logic	op_rega_wb;
logic	op_regb_wb;
logic	op_rega_pc;
logic	op_regb_pc;
always_comb
begin
	op_rega_wb = rega_addr == wb_addr;
	op_regb_wb = regb_addr == wb_addr;
	op_rega_pc = rega_addr == RF_PC;
	op_regb_pc = rega_addr == RF_PC;
	unique case({op_rega_wb,op_rega_pc})
		2'b00: opmux_a = OPMUX_A_RA;
		2'b01: opmux_a = OPMUX_A_PC;
		2'b10: opmux_a = OPMUX_A_WB;
	endcase
	unique case({id_instr.i,op_regb_wb,op_regb_pc})
		3'b000: opmux_b = OPMUX_B_RB;
		3'b001: opmux_b = OPMUX_B_PC;
		3'b010: opmux_b = OPMUX_B_WB;
		3'b100: opmux_b = OPMUX_B_IMM;
	endcase
end

always_ff @(posedge clk, negedge rst)
begin
	if (!rst)
		swi = 0;
	else if (id_instr.opcode == OPCODE_SWI)
		swi = 1;
	else
		swi = 0;
end
//decode alu_op & opcode_err
// alu_op in alu

//decode mau_op
// in mau

//decode branch
always_comb
begin
	case(id_instr.opcode)
		OPCODE_B: begin
			if (id_instr.regd_cond[2:0] == flag)
				branch = id_halt ? 0 : 1;
			else
				branch = 0;
		end
		OPCODE_CALL: branch = id_halt ? 0 : 1;
		OPCODE_RET: branch = id_halt ? 0 : 1;
		default : branch = 0;
	endcase
	branch_imm = id_instr.i;
	branch_abs = id_instr.regb[0];
end

//decode rfe
always_comb
begin
	if (id_instr.opcode == OPCODE_RFE)
		rfe = id_halt ? 0 : 1;
	else
		rfe = 0;
end

//decode mov
always_comb
begin
	if (id_instr.opcode == OPCODE_MOV) begin
		if (id_instr.regb[1])
			wb_spr = id_halt ? 0 : 1;
		else
			wb_spr = 0;
	end
	else
		wb_spr = 0;
	
	spr_addr = id_instr.regd_cond;
end

//decode id_err
always_comb
begin
	id_err = 0;
end

endmodule
