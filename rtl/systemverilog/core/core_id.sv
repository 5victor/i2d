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
`include "instruction.sv"

module core_id(
	input clk, rst,
	input [31:0] if_pc, input [31:0] if_instr, input id_halt, flush,
	input if_busy, input [3:0] wb_addr,
	output [3:0] rega_addr, output [3:0] regb_addr, output [31:0] imm,
	output opmux_a opmux_a, output opmux_b opmux_b,
	output logic [31:0] id_pc, output instruction id_instr
);
//logic	[31:0]	id_pc;
//instruction	id_instr;
logic	opcode_err;

assign rega_addr = id_instr[21:18];
assign regb_addr = id_instr[17:14];

always_ff @(posedge clk)
begin
	if (!rst) begin
		id_pc <= 0;
		id_instr <= {`CORE_OPCODE_NOP, (32-`CORE_OPCODE_WIDTH)'b0};
	end
	else if (!if_busy) begin
		id_pc <= if_pc;
		id_instr <= if_instr;
	end
	else if (id_halt) begin
		id_pc <= id_pc;
		id_instr <= id_instr;
	end
	else if (flush)
		id_instr <= {OPCODE_NOP, {26{1}}}; // for record flush nop
end

//decode imm
always_comb
begin
	if(id_instr.i)
		if (id_instr.s)
			imm[31:11] = {21{id_instr[10]}};
		else
			imm[31:11] = '0;
		imm[10:0] = id_instr[10:0];
	else
		imm = '0;
end

//decode operandmux
always_comb
begin
	logic	op_rega_wb = rega_addr == wb_addr;
	logic	op_regb_wb = regb_addr == wb_addr;
	logic	op_rega_pc = rega_addr == RF_PC;
	logic	op_regb_pc = rega_addr == RF_PC;
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

//decode alu_op & opcode_err
// alu_op in alu

//decode mau_op
// in mau

//decode branch
always_comb
begin

end
