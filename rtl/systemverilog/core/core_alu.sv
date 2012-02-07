/* filename
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "i2d_soc_defines.sv"

module core_alu(
	input instruction ex_instr, input sr sr, input [31:0] operand_a,
	input [31:0] operand_b, output sr_cf, output sr_of, output sr_zf,
	output [31:0] result
);


always_comb
begin
	sr_cf = sr.cf;
	sr_of = sr.of;
	sr_zf = sr.zf;
	unique case(ex_instr.opcode)
	OPCODE_ADD: begin
		{sr_cf,result} = operand_a + operand_b;
		sr_of = (operand_a[31] & operand_b[31]) != result[31];
		sr_zf = ~(|result);
	end
	OPCODE_ADDC: begin
		{sr_cf,result} = operand_a + operand_b + sr_cf;
		sr_of = (operand_a[31] & operand_b[31]) != result[31];
		sr_zf = ~(|result);
	end
	OPCODE_SUB: begin
		result = {1,sr_cf,oprand_a} - operand_b;
		sr_of = (operand_a[31] & !operand_b[31]) != result[31];
		sr_zf = ~(|result);
	end
	OPCODE_SUB: begin
		result = {1,sr_cf,oprand_a} - operand_b - sr_cf;
		sr_of = (operand_a[31] & !operand_b[31]) != result[31];
		sr_zf = ~(|result);
	end
	OPCODE_MUL: begin
		if (ex_instr.s)
			result = signed'(operand_a) * signed'(operand_b);
		else
			result = unsigned'(operand_a) * unsigned'(operand_b);
		sr_zf = ~(|result);
	end
	OPCODE_DIV: begin
		if (ex_instr.s)
			result = signed'(operand_a) / signed'(operand_b);
		else
			result = unsigned'(operand_a) / unsigned'(operand_b);
		sr_zf = ~(|result);
	end
	OPCODE_AND: begin
		result = operand_a & operand_b;
		sr_zf = ~(|result);
	end
	OPCODE_OR: begin
		result = operand_a | operand_b;
		sr_zf = ~(|result);
	end
	OPCODE_NOT: begin
		result = ~(operand_a);
		sr_zf = ~(|result);
	end
	OPCODE_LSL: begin
		result = operand_a << operand_b;
		sr_zf = ~(|result);
	end
	OPCODE_LSR: begin
		result = operand_a >> operand_b;
		sr_zf = ~(|result);
	end
	OPCODE_ASL: begin
		result = operand_a <<< operand_b;
		sr_zf = ~(|result);
	end
	OPCODE_ASR: begin
		result = operand_a << operand_b;
		sr_zf = ~(|result);
	end
	endcase
end

