/* core_rf_sr.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "i2d_core_defines.sv"
 
module core_rf_sr(
	input clk, rst,
	input flag_t flag, input write_sr, input sr_t sr_in, output sr_t sr,
	input write_mode, input mode_t mode, input write_i, input i
);
sr_t to_sr;

always_ff @(posedge clk, negedge rst)
begin
	if (!rst)
		sr = 0;
	else
		sr = to_sr;
end

always_comb
begin
	if (write_sr)
		to_sr = sr_in;
	else begin
		to_sr.flag = flag;
		if (write_mode)
			to_sr.mode = mode;
		else
			to_sr.mode = sr.mode;
		if (write_i)
			to_sr.i = i;
		else
			to_sr.i = sr.i;
	end
end

endmodule
