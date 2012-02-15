/* monitor.sv
 *
 * Copyright Victor Wen, vic7tor@gmail.com
 * This code publish under GNU GPL License
 *
 * Description:
 *
 * TODO
 */

`include "i2d_core_defines.sv"
`include "verify_defines.sv"

class monitor;
mailbox mb_out[9];
mailbox mb_instr;

core_if_out             if_out;
core_id_out             id_out;
core_rf_gpr_out         rf_gpr_out;
core_operand_mux_out    operand_mux_out;
core_alu_out            alu_out;
core_mau_out            mau_out;
core_ex_out             ex_out;
core_rf_sr_out          rf_sr_out;
core_ctrl_out           ctrl_out;

instr_t instr;


function new(ref mailbox mb_out[9], ref mailbox mb_instr);
	for(int i = 0; i < 9; i++)
		this.mb_out[i] = mb_out[i];
	this.mb_instr = mb_instr;
endfunction

task run();
fork begin
	forever begin
		get_data();
		display();
	end
end
join_none
endtask

task get_data;
	mb_out[CORE_IF].get(if_out);
	mb_out[CORE_ID].get(id_out);
	mb_out[CORE_RF_GPR].get(rf_gpr_out);
	mb_out[CORE_OPERAND_MUX].get(operand_mux_out);
	mb_out[CORE_ALU].get(alu_out);
	mb_out[CORE_MAU].get(mau_out);
	mb_out[CORE_EX].get(ex_out);
	mb_out[CORE_RF_SR].get(rf_sr_out);
	mb_out[CORE_CTRL].get(ctrl_out);
endtask

function string decode_instr(instr_t instr);
	string str;
	$sformat(str, "opcode:%s regd_cond=4'b%4b rega=4'b%4b regb=4'b%4b i=%1b s=%1b imm=%11b", instr.opcode.name, instr.regd_cond, instr.rega,
		instr.regb, instr.i, instr.s, instr.imm
	);
	return str;
endfunction

function void display_if_out();
	$display("core_if: if_pc=%h if_instr=%h(%s), if_err=%0d\n",
		if_out.if_pc, if_out.if_instr,
		decode_instr(if_out.if_instr),
		if_out.if_err);
endfunction

function void display_id_out();
	$display("core_id: rega_addr=%0d regb_addr=%0d imm=%h opmux_a=%s opmux_b=%s id_pc=%h id_instr=%h(%s) swi=%0d branch_imm=%0d branch_abs=%0d rfe=%0d spr_addr=%0d wb_spr=%0d id_err=%0d branch=%0d\n",
		id_out.rega_addr, id_out.regb_addr, id_out.imm,
		id_out.opmux_a.name, id_out.opmux_b, id_out.id_pc,
		id_out.id_instr, decode_instr(id_out.id_instr), id_out.swi,
		id_out.branch_imm,
		id_out.branch_abs, id_out.rfe, id_out.spr_addr,
		id_out.wb_spr, id_out.id_err, id_out.branch
	);
endfunction

function void display_rf_gpr_out();
	$display("core_rf_gpr: rega_data=%h regb_data=%h\n",
		rf_gpr_out.rega_data, rf_gpr_out.regb_data
	);
endfunction

function void display_operand_mux_out();
	$display("core_operand_mux: operand_a=%h operand_b=%h\n",
		operand_mux_out.operand_a, operand_mux_out.operand_b
	);
endfunction

function void display_alu_out();
	$display("core_alu: flag=%0b alu_result=%h\n",
		alu_out.flag, alu_out.alu_result
	);
endfunction

function void display_mau_out();
	$display("core_mau: mau_busy=%0d mau_data=%h\n",
		mau_out.mau_busy, mau_out.mau_data
	);
endfunction

function void display_ex_out();
	$display("core_ex: wb_addr=%0d wb=%0d wb_data=%h ex_instr=%h(%s) ex_pc = %h\n",
		ex_out.wb_addr, ex_out.wb, ex_out.wb_data, ex_out.ex_instr,
		decode_instr(ex_out.ex_instr), ex_out.ex_pc
	);
endfunction

function void display_rf_sr_out();
	$display("core_rf_sr: sr=%0b\n", rf_sr_out.sr);
endfunction

function void display_ctrl_out();
	$display("core_ctrl: epc=%h esr=%0b set_pc=%0d new_pc=%h mode=%0d write_mode=%0d wb_sr=%0b write_sr=%0d if_halt=%0d id_halt=%0d id_flush=%0d ex_flush=%0d ex_halt=%0d\n",
		ctrl_out.epc, ctrl_out.esr, ctrl_out.set_pc,
		ctrl_out.new_pc, ctrl_out.mode, ctrl_out.write_mode,
		ctrl_out.wb_sr, ctrl_out.write_sr, ctrl_out.if_halt,
		ctrl_out.id_halt, ctrl_out.id_flush, ctrl_out.ex_flush,
		ctrl_out.ex_halt
	);
endfunction

function void display();
	display_if_out();
	display_id_out();
	display_rf_gpr_out();
	display_operand_mux_out();
	display_alu_out();
	display_mau_out();
	display_ex_out();
	display_rf_sr_out();
	display_ctrl_out();
endfunction

endclass
