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
	input instr_t id_instr, input addr_t id_pc, input ex_halt, ex_flush,
	output reg_addr_t wb_addr, output wb, output data_t wb_data,
	output instr_t ex_instr, output addr_t ex_pc,
	input data_t mau_data, input data_t alu_result, input data_t rega_data,
	input sr_t sr; input sr_t esr, input reg_t epc
);

always_ff @(posedge clk, negedge rst, posedge ex_halt)
begin
	if (!rst) begin
		ex_instr <= 'b0;
		ex_pc <= 0;
	end
	else if (ex_flush) begin
		ex_instr <= {OPCODE_NOP,26'(1)}; // for record flush nop
	end
	else if (ex_halt) begin
		ex_instr <= ex_instr;
		ex_pc <= ex_pc;
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
			if (ex_instr.regb[1])
				wb = 0;
			else
				wb = 1;
			if (ex_instr.regb[0]) begin
				if (ex_instr.rega == SPR_SR)
					wb_data = sr;
				else if (ex_instr.rega == SPR_EPC)
					wb_data = epc;
				else if (ex_instr.rega == SPR_ESR)
					wb_data = esr;
				else
					wb_data = 0;	
			end
			else
				wb_data = rega_data;
		end
		OPCODE_CALL: begin
			wb = 1;
			wb_data = ex_pc + 4;
		end
		default: wb = 0;
	endcase
end

endmodule
