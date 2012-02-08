/* core_rf_gpr.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "i2d_core_defines.sv"

module core_rf_gpr(
	input clk,
	input [3:0] rega_addr, input [3:0] regb_addr, output [31:0] rega_data,
	output [31:0] regb_data,
	input wb, input [3:0] wb_addr, input [31:0] wb_data
);
logic	[31:0]	regmem[15];

always_ff @(posedge clk)
begin
	if (wb)
		regmem[wb_addr] = wb_data;
	rega_data = regmem[rega_addr];
	regb_data = regmem[regb_addr];
end

endmodule

