/* core_ctrl.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

module core_ctrl(
	input mau_busy, input except, output flush, output if_halt, id_halt,
	output ex_halt
);

always_comb
begin
	if (mau_busy) begin
		if_halt = 1;
		id_halt = 1;
		ex_halt = 1;
	end
	else begin
		if_halt = 0;
		id_halt = 0;
		ex_halt = 0;
	end
end

always_comb
begin
	if (except) begin
		flush = 1;
	end
	else begin
		flush = 0;
	end
end

endmodule
