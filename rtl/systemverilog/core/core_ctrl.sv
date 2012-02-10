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
	input clk, rst,
	input swi, input branch, input branch_imm, input reg_t rega_data,
	input data_t imm, input reg_addr_t spr_addr, input wb_spr, input rfe,
	input irq, output irq_ack, input addr_t id_pc, input sr_t sr,
	output reg_t epc, output sr_t esr, output set_pc, output mode_t mode,
	output write_mode, output addr_t new_pc,
	output sr_t wb_sr, output write_sr,
	input addr_t if_pc, input addr_t ex_pc, input if_err, input mau_err,
	input id_err, output id_flush, ex_flush, input branch_abs,
	input mau_busy, output if_halt, id_halt, ex_halt
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
	else if (wb_spr) begin
		if (spr_addr == SPR_EPC)
			epc = rega_data;
		if (spr_addr == SPR_ESR)
			esr = rega_data;
	end
	else if (if_err) begin
		epc = if_pc;
		esr = sr;
	end
	else if (id_err) begin
		epc = id_pc;
		esr = sr;
	end
	else if (mau_err) begin
		epc = id_pc;
		esr = sr;
	end
end

always_comb
begin
	if (sr.i && irq) begin
		id_flush = 1;
		ex_flush = 1;
		mode = MODE_IRQ;
		write_mode = 1;
	end
	else if (sr.i && swi) begin
		id_flush = 1;
		ex_flush = 1;
		mode = MODE_SWI;
		write_mode = 1;
	end
	else if (if_err) begin
		id_flush = 1;
		ex_flush = 0;
		mode = MODE_IFERR;
		write_mode = 1;
	end
	else if (id_err) begin
		id_flush = 1;
		ex_flush = 1;
		mode = MODE_IDERR;
		write_mode = 1;
	end
	else if (mau_err) begin
		id_flush = 1;
		ex_flush = 1;
		mode = MODE_MAUERR;
		write_mode = 1;
	end
	else begin
		id_flush = 0;
		ex_flush = 0;
		mode = MODE_NONE;
		write_mode = 0;
	end
end

always_comb
begin
	if (sr.i && irq) begin
		set_pc = 1;
		new_pc = VECTOR_IRQ;
	end
	else if (sr.i && swi) begin
		set_pc = 1;
		new_pc = VECTOR_SWI;
	end
	else if (if_err) begin
		set_pc = 1;
		new_pc = VECTOR_IFERR;
	end
	else if (id_err) begin
		set_pc = 1;
		new_pc = VECTOR_IDERR;
	end
	else if (mau_err) begin
		set_pc = 1;
		new_pc = VECTOR_MAUERR;
	end
	else if (branch) begin
		set_pc = 1;
		new_pc = (branch_abs?0:id_pc) + (branch_imm?imm:rega_data);
	end
	else if (rfe) begin
		set_pc = 1;
		new_pc = epc;
	end
	else begin
		set_pc = 0;
		new_pc = 0;
	end
end

always_comb
begin
	if (rfe) begin
		write_sr = 1;
		wb_sr = esr;
	end
	else if (wb_sr && (spr_addr == SPR_SR)) begin
		write_sr = 1;
		wb_sr = sr_t'(rega_data);
	end
	else begin
		write_sr = 0;
		wb_sr = 0;
	end
end

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

endmodule
