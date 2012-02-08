/* filename
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "i2d_core_defines.sv"

module core_alu(
	input instr_t ex_instr, input flag_t flag_in, input [31:0] operand_a,
	input [31:0] operand_b, output flag_t flag,
	output [31:0] alu_result
);

logic [31:0] result;

assign alu_result = result;

always_comb
begin
	flag.cf = flag_in.cf;
	flag.of = flag_in.of;
	flag.zf = flag_in.zf;
	unique case(ex_instr.opcode)
	OPCODE_ADD: begin
		{flag.cf,result} = operand_a + operand_b;
		flag.of = (operand_a[31] & operand_b[31]) != result[31];
		flag.zf = ~(|result);
	end
	OPCODE_ADDC: begin
		{flag.cf,result} = operand_a + operand_b + flag.cf;
		flag.of = (operand_a[31] & operand_b[31]) != result[31];
		flag.zf = ~(|result);
	end
	OPCODE_SUB: begin
		flag.cf = 0;
		result = {1'b1,flag.cf,operand_a} - operand_b;
		flag.of = (operand_a[31] & !operand_b[31]) != result[31];
		flag.zf = ~(|result);
	end
	OPCODE_SUB: begin
		result = {1'b1,flag.cf,operand_a} - operand_b - flag.cf;
		flag.of = (operand_a[31] & !operand_b[31]) != result[31];
		flag.zf = ~(|result);
	end
	OPCODE_MUL: begin
		if (ex_instr.s)
			result = signed'(operand_a) * signed'(operand_b);
		else
			result = unsigned'(operand_a) * unsigned'(operand_b);
		flag.zf = ~(|result);
	end
	OPCODE_DIV: begin
		if (ex_instr.s)
			result = signed'(operand_a) / signed'(operand_b);
		else
			result = unsigned'(operand_a) / unsigned'(operand_b);
		flag.zf = ~(|result);
	end
	OPCODE_AND: begin
		result = operand_a & operand_b;
		flag.zf = ~(|result);
	end
	OPCODE_OR: begin
		result = operand_a | operand_b;
		flag.zf = ~(|result);
	end
	OPCODE_NOT: begin
		result = ~(operand_a);
		flag.zf = ~(|result);
	end
	OPCODE_LSL: begin
		result = operand_a << operand_b;
		flag.zf = ~(|result);
	end
	OPCODE_LSR: begin
		result = operand_a >> operand_b;
		flag.zf = ~(|result);
	end
	OPCODE_ASL: begin
		result = operand_a <<< operand_b;
		flag.zf = ~(|result);
	end
	OPCODE_ASR: begin
		result = operand_a << operand_b;
		flag.zf = ~(|result);
	end
	endcase
end

endmodule
