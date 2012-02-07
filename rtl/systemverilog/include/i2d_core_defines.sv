/* i2d_core_defines.v
 *
 * Copyright: Victor Wen, vic7tor@gmail.com
 *
 * i2d core defines
 */
`ifndef I2D_CORE_DEFINES_SV
`define I2D_CORE_DEFINES_SV

//`include "i2d_soc_defines.v"

typedef logic [31:0] bit_wide; //need a proper name

//ALU instruction
typedef enum logic [5:0] {
OPCODE_ADD	= 6'd1,
OPCODE_ADDC	= 6'd2,
OPCODE_SUB	= 6'd3,
OPCODE_SUBC	= 6'd4,
OPCODE_MUL	= 6'd5,
OPCODE_DIV	= 6'd6,
OPCODE_AND	= 6'd7,
OPCODE_OR	= 6'd8,
OPCODE_NOT	= 6'd9,
OPCODE_LSL	= 6'd10,
OPCODE_LSR	= 6'd11,
OPCODE_ASL	= 6'd12,
OPCODE_ASR	= 6'd13,

//MEM instruction
OPCODE_LD	= 6'd14,
OPCODE_LDB	= 6'd15,
OPCODE_LDW	= 6'd16,
OPCODE_ST	= 6'd17,
OPCODE_STB	= 6'd18,
OPCODE_STW	= 6'd19,

//branch instruction may have 2 opcodes(imm, reg), while the condition in ins[26:0]
OPCODE_B	= 6'd20,
//other instruction
OPCODE_NOP	= 6'd21,
OPCODE_MOV	= 6'd22,
OPCODE_SWI	= 6'd23,
OPCODE_CALL	= 6'd24,
OPCODE_CALLI	= 6'd25,
OPCODE_RET	= 6'd26,
OPCODE_RFE	= 6'd27,
OPCODE_MSR	= 6'd28,
OPCODE_MRS	= 6'd29
} opcode;

typedef enum logic [3:0] {
COND_B		= 4'd1,
COND_BE		= 4'd2,
COND_BNE	= 4'd3,
COND_BG		= 4'd4,
COND_BL		= 4'd5,
COND_BA		= 4'd6,
COND_BB		= 4'd7
} branch_cond;

//i2d regfile
typedef enum logic [3:0] {
	RF_LR = 4'b1101,
	RF_SP = 4'b1110,
	RF_PC = 4'b1111
} mode_depend_gpr;

//oprand mux
typedef enum logic [3:0] {
//OPMUX_A_NONE	= 0,
OPMUX_A_RA	= 1,
OPMUX_A_PC	= 2,
OPMUX_A_WB	= 3
} opmux_a;

typedef enum logic [3:0] {
//OPMUX_B_NONE	= 0,
OPMUX_B_RB	= 1,
OPMUX_B_PC	= 2,
OPMUX_B_IMM	= 3,
OPMUX_B_WB	= 4
} opmux_b;

/*
//alu op
typedef enum logic [3:0] {
ALUOP_NONE	= 0,
ALUOP_ADD	= 1,
ALUOP_ADDC	= 2,
ALUOP_SUB	= 3,
ALUOP_SUBC	= 4,
ALUOP_MUL	= 5,
ALUOP_MULU	= 6,
ALUOP_DIV	= 7,
ALUOP_DIVU	= 8,
ALUOP_AND	= 9,
ALUOP_OR	= 8,
ALUOP_NOT	= 9,
ALUOP_LSL	= 10,
ALUOP_LSR	= 11,
ALUOP_ASL	= 12,
ALUOP_ASR	= 13,
ALUOP_ERR	= 14
} aluop;
*/

//status register
typedef struct packed {
	logic	[3:0]	mode;
	logic	[0:0]	dummy;
	logic	cf;
	logic	of;
	logic	zf;
} sr;


//mau op
typedef enum logic [1:0] {
MAUOP_NONE	= 0,
MAUOP_R		= 1,
MAUOP_W		= 2
} mau_op;

//mau sel
typedef enum logic [1:0] {
MAUSEL_NONE	= 0,
MAUSEL_B	= 1,
MAUSEL_W	= 2,
MAUSEL_D	= 3
} mau_sel;

`endif
