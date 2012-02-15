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
	input if_halt, set_pc, input addr_t new_pc,
	output addr_t if_pc, output instr_t if_instr, output logic if_err
);
addr_t	pc;
addr_t	last_pc;
logic	if_busy;

assign bus.adr = pc;
assign if_pc = last_pc;
assign if_instr = if_busy?{OPCODE_NOP,26'(0)} : if_halt?{OPCODE_NOP,26'(0)}:bus.dat_so;
assign if_busy = !bus.ack | if_halt;
assign bus.cyc = !if_halt;
assign bus.stb = bus.cyc;
assign bus.we = 0;
assign bus.sel = 4'b1111;
assign if_err = bus.err;

always_ff @(posedge clk, negedge rst)
begin
	if (!rst) begin
		pc <= 0;
		last_pc <= 0;
	end
	else if (set_pc) //prority set_pc must higher than if_halt, 
		pc <= new_pc;
	else if (if_halt) begin
		pc <= pc;
	end
	else begin
		last_pc <= pc;
	       	if (bus.ack)
			pc <= pc + 4;
		else
			pc <= pc;	
	end
end

endmodule
