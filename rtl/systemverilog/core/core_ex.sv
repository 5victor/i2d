/* core_ex.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "i2d_core_defines.sv"

module core_ex(
	input clk, rst,
	input instr_t id_instr, input [31:0] id_pc, input ex_halt, input flush,
	output [3:0] wb_addr, output wb, output [31:0] wb_data,
	output instr_t ex_instr, output [31:0] ex_pc,
	input [31:0] mau_data, input [31:0] alu_result, input [31:0] rega_data
);

always_ff @(posedge clk, negedge rst, posedge ex_halt)
begin
	if (!rst) begin
		ex_instr <= 'b0;
		ex_pc <= 0;
	end
	else if (ex_halt) begin
		ex_instr <= ex_instr;
		ex_pc <= ex_pc;
	end
	else if (flush) begin
		ex_instr <= {OPCODE_NOP,26'(1)}; // for record flush nop
	end
	else begin
		ex_instr <= id_instr;
		ex_pc <= id_pc;
	end
end

always_comb
begin
	wb_addr = ex_instr.regd_cond;
	wb_data = 0;
	unique case(ex_instr.opcode)
		OPCODE_ADD,
		OPCODE_ADDC,
		OPCODE_SUB,
		OPCODE_SUBC,
		OPCODE_MUL,
		OPCODE_DIV,
		OPCODE_AND,
		OPCODE_OR,
		OPCODE_NOT,
		OPCODE_LSL,
		OPCODE_LSR,
		OPCODE_ASL,
		OPCODE_ASR: begin
			wb = 1;
			wb_data = alu_result;
		end
		OPCODE_LD: begin
			wb = 1;
			wb_data = mau_data;
		end
		OPCODE_MOV: begin
			wb = 1;
			wb_data = rega_data;
		end
		default: wb = 0;
	endcase
end

endmodule
