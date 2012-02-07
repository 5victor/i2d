/* operand_mux.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

module operand_mux(
	input clk, rst,
	input opmux_a opmux_a, input opmux_b opmux_b, input [31:0] rega_data,
	input [31:0] regb_data, input [31:0] imm, input [31:0] id_pc,
	input [31:0] wb_data,
	output logic [31:0] operand_a, output logic [31:0] operand_b
);
logic	[31:0]	op_a;
logic	[31:0]	op_b;

always_ff @(posedge clk)
begin
	if (!rst) begin
		operand_a <= 0;
		operand_b <= 0;
	end
	else begin
		operand_a <= op_a;
		operand_b <= op_b;
	end
end

always_comb
begin
	unique case(opmux_a)
		OPMUX_A_RA: op_a = rega_data;
		OPMUX_A_PC: op_a = id_pc;
		OPMUX_A_WB: op_a = wb_data;
	endcase
	unique case(opmux_b)
		OPMUX_B_RB: op_b = regb_data;
		OPMUX_B_PC: op_b = id_pc;
		OPMUX_B_IMM: op_b = imm;
		OPMUX_B_WB: op_b = wb_data;
	endcase
end
