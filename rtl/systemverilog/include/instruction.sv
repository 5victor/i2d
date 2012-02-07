/* instruction.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`ifndef INSTRUCTION_SV
`define INSTRUCTION_SV

`include "i2d_core_defines.sv"

typedef union packed {
	logic [3:0] regd;
	logic [3:0] cond;
	logic [3:0] sel;
} regd_cond_sel;

typedef union packed {
	logic [3:0] regb;
	logic [3:0] dummy;
} regb_dummy;

typedef struct packed {
	opcode opcode;
	regd_cond_sel rcs;
	logic [3:0] rega;
	regb_dummy rd;
	logic	i;
	logic	s;
	logic	[11:0] imm;
} instruction;

`endif
