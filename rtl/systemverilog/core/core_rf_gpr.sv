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
	input reg_addr_t rega_addr, input reg_addr_t regb_addr,
	output data_t rega_data, output data_t regb_data,
	input wb, input reg_addr_t wb_addr, input data_t wb_data
);
reg_t	regmem[15];

always_ff @(posedge clk)
begin
	if (wb)
		regmem[wb_addr] = wb_data;
	rega_data = regmem[rega_addr];
	regb_data = regmem[regb_addr];
end

endmodule

