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
`include "wishbone.sv"

module core_if(
	input clk, rst,
	wishbone.pl_master bus,
	input if_halt, set_pc, input [31:0] new_pc,
	output [31:0] if_pc, output instr_t if_instr, output if_busy
);
logic	[31:0]	pc;
logic	[31:0]	last_pc;

assign bus.adr = pc;
assign if_pc = last_pc;
assign if_instr = bus.dat_so;
assign if_busy = !bus.ack | if_halt;
assign bus.cyc = !if_halt;
assign bus.stb = bus.cyc;
assign bus.we = 0;

always_ff @(posedge clk, negedge rst, posedge if_halt)
begin
	if (!rst) begin
		pc <= 0;
		last_pc <= 0;
	end
	else if (if_halt) begin
		pc <= pc;
	end
	else begin
	       	if (bus.ack)
			pc <= pc + 4;
		else if (set_pc) //
			pc <= new_pc;
		else
			pc <= pc;
		last_pc <= pc;
	end
end

endmodule
