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
	input instr_t if_instr, input data_t regb_data, input data_t imm,
	input data_t rega_data,
	output logic mau_busy, output data_t mau_data,
	output logic mau_err
);
mau_op_t	mau_op;
mau_sel_t	mau_sel;
logic last_stb, last_stb2;

assign mau_err = bus.err;

always_comb
begin
	if ((if_instr.opcode & 6'(~3)) == OPCODE_LD)
		mau_op = MAUOP_R;
	else if ((if_instr.opcode & 6'(~3)) == OPCODE_ST)
		mau_op = MAUOP_W;
	else
		mau_op = MAUOP_NONE;
	mau_sel = mau_sel_t'(if_instr.opcode[1:0]);
end

// cyc
always_ff @(posedge clk, negedge rst)
begin
	if (!rst)
		bus.cyc = 0;
	else if ((mau_op == MAUOP_R) || (mau_op == MAUOP_W))
		bus.cyc = 1;
	else if ((last_stb2 == 0) && bus.ack)
		bus.cyc = 0;
end

always_ff @(posedge clk, negedge rst)
begin
	if (!rst) begin
		bus.stb = 0;
		bus.we = 1;
		bus.sel = 0;
	end
	else if ((mau_op == MAUOP_R) || (mau_op == MAUOP_W)) begin
		bus.stb = 1;
		if (mau_op == MAUOP_W)
			bus.we = 1;
		else begin
			bus.we = 0;
			bus.dat_mo = rega_data;
		end
		unique case(mau_sel)
			MAUSEL_B: bus.sel = 4'b0001;
			MAUSEL_W: bus.sel = 4'b0011;
			MAUSEL_D: bus.sel = 4'b1111;
		endcase
	end
	else
		bus.stb = 0;
end

//TODO: distinguish signed unsigned imm rega_data...
//adr
always_comb
begin
	if (if_instr.i)
		bus.adr = regb_data + imm;
	else
		bus.adr = regb_data;
end

always_ff @(posedge clk)
begin
	if (bus.stb)
		last_stb = bus.stb;
	else if (last_stb2)
		last_stb = last_stb2;

	if (last_stb && bus.stb)
		last_stb2 = 1;
	else
		last_stb2 = 0;
	
	if (last_stb && !bus.ack)
		mau_busy = 1;
	else
		mau_busy = 0;
end

// always output if mau_op = MAUOP_R, other component may not accept this data
always_ff @(posedge clk)
begin
	if (bus.ack)
		mau_data = bus.dat_so;
end

endmodule
