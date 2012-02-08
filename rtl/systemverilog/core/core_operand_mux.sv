/* operand_mux.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "i2d_core_defines.sv"

module core_operand_mux(
	input clk, rst,
	input opmux_a_t opmux_a, input opmux_b_t opmux_b, input [31:0] rega_data,
	input [31:0] regb_data, input [31:0] imm, input [31:0] ex_pc,
	input [31:0] wb_data,
	output logic [31:0] operand_a, output logic [31:0] operand_b
);
logic	[31:0]	op_a;
logic	[31:0]	op_b;
logic	[31:0]	rega;
logic	[31:0]	regb;


always_ff @(posedge clk, negedge rst)
begin
	if (!rst) begin
		rega = 0;
		regb = 0;
	end
	else
		rega = rega_data;
		regb = regb_data;
end

always_comb
begin
	operand_a = op_a;
	operand_b = op_b;
end

always_comb
begin
	unique case(opmux_a)
		OPMUX_A_RA: op_a = rega;
		OPMUX_A_PC: op_a = ex_pc;
		OPMUX_A_WB: op_a = wb_data;
	endcase
	unique case(opmux_b)
		OPMUX_B_RB: op_b = regb;
		OPMUX_B_PC: op_b = ex_pc;
		OPMUX_B_IMM: op_b = imm;
		OPMUX_B_WB: op_b = wb_data;
	endcase
end

endmodule
