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
wishbone ibus();
wishbone dbus();
logic	clk, rst, irq, irq_ack;
mailbox mb[9];

test_cpu test_cpu(.*);
test test(.*);

initial
begin
	rst = 0;
	clk = 0;
	#20 rst = 1;
end

always
begin
	#10 clk++;
end

endmodule
