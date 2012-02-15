/* top.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */
`timescale 1ns/1ns

`include "wishbone.sv"

module top;
logic	clk, rst, irq, irq_ack;
mailbox mb_out[9];

wishbone ibus(clk, rst);
wishbone dbus(clk, rst);

test_cpu test_cpu(.*);
test test(.*);

initial
begin
	for (int i = 0; i < 9; i++)
		mb_out[i] = new(1);
	rst = 0;
	clk = 0;
	#20 rst = 1;
end

always
begin
	#10 clk++;
end

endmodule
