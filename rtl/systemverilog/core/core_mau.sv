/* core_mau.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "i2d_core_defines.sv"

module core_mau(
	input clk, rst,
	wishbone.pl_master bus,
	input instruction if_instr, input [31:0] regb_data, input [31:0] imm,
	input [31:0] rega_data,
	output mau_busy, output [3:0] regm_addr, input [31:0] regm_data;
	output [31:0] mau_data
);
mau_op	mau_op;
mau_sel	mau_sel;
logic last_stb, last_stb2;

always_comb
begin
	unique case(if_instr.opcode)
		OPCODE_LD: mau_op = MAUOP_R;
		OPCODE_ST: mau_op = MAUOP_W;
		default: mau_op = MAUOP_NONE;
	endcase
	mau_sel = if_instr.opcode[1:0];
end

// cyc
always_ff @(posedge clk)
begin
	priority if ((mau_op == MAUOP_R) || (mau_op == MAUOP_W))
		bus.cyc = 1;
	else if ((last_stb2 == 0) && bus.ack)
		bus.cyc = 0;
end

always_ff @(posedge clk)
begin
	if ((mau_op == MAUOP_R) || (mau_op == MAUOP_W)) begin
		bus.stb = 1;
		if (mau_op == MAUOP_W)
			bus.we = 1;
		else	bus.we = 0;
	end
	else
		bus.stb = 0;
end

//TODO: distinguish signed unsigned imm rega_data...
//adr
always_comb
begin
	if (if_instr.i)
		bus.adr = rega_data + imm;
	else
		bus.adr = rega_data + regb_data;
end

always_ff @(posedge clk)
begin
	priority if (bus.stb)
		last_stb = bus.stb;
	else if (last_stb2)
		last_stb = last_stb2;

	if (last_stb && bus.stb)
		last_stb2 = 1;
	else
		last_stb2 = 0;

	if (last_stb && !bus.ack)
		if_halt = 1;
	else
		if_halt = 0;
end

// always output if mau_op = MAUOP_R, other component may not accept this data
always_ff @(posedge clk)
begin
	if (bus.ack)
		mau_data = bus.dat_so;
end
