/* core_except.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

module core_except(
	input clk, rst,
	input swi,
	input irq, output irq_ack, input addr_t id_pc, input sr_t sr,
	output reg_t epc, output reg_t esr, output set_pc, output mode_t mode,
	output write_mode, output addr_t new_pc, output except
);

//irq_ack
always_ff @(posedge clk, negedge rst)
begin
	if (!rst)
		irq_ack = 0;
	else if (sr.i && irq)
		irq_ack = 1;
	else
		irq_ack = 0;
end

//epc esr
always_ff @(posedge clk, negedge rst)
begin
	if (!rst) begin
		epc = 0;
		esr = 0;
	end
	else if (sr.i && irq) begin
		epc = id_pc;
		esr = sr;
	end
	else if (sr.i && swi) begin
		epc = id_pc;
		esr = sr;
	end
end

always_comb
begin
	if (sr.i && irq) begin
		except = 1;
		set_pc = 1;
		new_pc = VECTOR_IRQ;
		mode = MODE_IRQ;
		write_mode = 1;
	end
	else if (sr.i && swi) begin
		except = 1;
		set_pc = 1;
		new_pc = VECTOR_SWI;
		mode = MODE_SWI;
		write_mode = 1;
	end
	else begin
		except = 0;
		set_pc = 0;
		new_pc = 0;
		mode = MODE_NONE;
		write_mode = 0;
	end
end

endmodule
