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
	input opmux_a_t opmux_a, input opmux_b_t opmux_b,
	input data_t rega_data, input data_t regb_data, input data_t imm,
	input addr_t ex_pc, input data_t wb_data,
	output data_t operand_a, output data_t operand_b
);
data_t	op_a;
data_t	op_b;
data_t	rega;
data_t	regb;


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
