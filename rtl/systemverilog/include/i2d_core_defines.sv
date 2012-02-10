/* i2d_core_defines.v
 *
 * Copyright: Victor Wen, vic7tor@gmail.com
 *
 * i2d core defines
 */
`ifndef I2D_CORE_DEFINES_SV
`define I2D_CORE_DEFINES_SV

//`include "i2d_soc_defines.v"

typedef logic [31:0] data_t;
typedef logic [31:0] addr_t;
typedef logic [31:0] reg_t;
typedef logic [3:0] reg_addr_t;

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
OPCODE_RET	= 6'd26,
OPCODE_RFE	= 6'd27
} opcode_t;

typedef struct packed {
	opcode_t opcode;
	logic [3:0] regd_cond;
	logic [3:0] rega;
	logic [3:0] regb;
	logic	i;
	logic	s;
	logic	[11:0] imm;
} instr_t;

/*
//branch cond
typedef enum logic [3:0] {
COND_B		= 4'd1,
COND_BE		= 4'd2,
COND_BNE	= 4'd3,
COND_BG		= 4'd4,
COND_BL		= 4'd5,
COND_BA		= 4'd6,
COND_BB		= 4'd7
} cond_t;
*/

//i2d regfile
typedef enum logic [3:0] {
	RF_LR = 4'b1101,
	RF_SP = 4'b1110,
	RF_PC = 4'b1111
} mode_depend_gpr;

typedef enum logic [3:0] {
	SPR_SR = 4'b0001,
	SPR_EPC = 4'b0010,
	SPR_ESR = 4'b0011
} spr_t;

//oprand mux
typedef enum logic [3:0] {
//OPMUX_A_NONE	= 0,
OPMUX_A_RA	= 4'd1,
OPMUX_A_PC	= 4'd2,
OPMUX_A_WB	= 4'd3
} opmux_a_t;

typedef enum logic [3:0] {
//OPMUX_B_NONE	= 0,
OPMUX_B_RB	= 4'd1,
OPMUX_B_PC	= 4'd2,
OPMUX_B_IMM	= 4'd3,
OPMUX_B_WB	= 4'd4
} opmux_b_t;

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
} aluop_t;
*/

typedef struct packed {
	logic	cf;
	logic	of;
	logic	zf;
} flag_t;

typedef enum logic [2:0] {
MODE_NONE = 3'd0,
MODE_SYS = 3'd1,
MODE_IRQ = 3'd2,
MODE_SWI = 3'd3,
MODE_USER = 3'd4,
MODE_IFERR = 3'd5,
MODE_IDERR = 3'd6,
MODE_MAUERR = 3'd7
} mode_t;

typedef enum logic [2:0] {
VECTOR_RST = 3'd1,
VECTOR_IRQ = 3'd2,
VECTOR_SWI = 3'd3,
VECTOR_IFERR = 3'd4,
VECTOR_IDERR = 3'd5,
VECTOR_MAUERR = 3'd6
} vector_t;

//status register
typedef struct packed {
	mode_t	mode;
	logic	i;
	flag_t	flag;
} sr_t;


//mau op
typedef enum logic [1:0] {
MAUOP_NONE	= 2'd0,
MAUOP_R		= 2'd1,
MAUOP_W		= 2'd2
} mau_op_t;

//mau sel
typedef enum logic [1:0] {
MAUSEL_NONE	= 2'd0,
MAUSEL_B	= 2'd1,
MAUSEL_W	= 2'd2,
MAUSEL_D	= 2'd3
} mau_sel_t;

`endif
