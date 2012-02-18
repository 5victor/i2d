SRC1 = ../../../rtl/systemverilog/core
SRC2 = .
TOP = top.sv monitor.sv generator.sv driver.sv
ARGS = -sverilog -debug_all +incdir+../../../rtl/systemverilog/include \
       -y ${SRC1} -y ${SRC2} +libext+.sv -ignore all

.PHONY:all
all:	simv

run:	simv
	./simv -l sim.log

gui:	simv
	./simv -gui

simv:	${TOP} ${SRC1} ${SRC2}
	vcs ${ARGS} -l comp.log ${TOP}

clean:
	@rm -rf simv* *.log csrc ucli.key DVEfiles *.vpd
