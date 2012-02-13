SRC1 = ../../../rtl/systemverilog/core
SRC2 = .
TOP = top.sv
ARGS = -sverilog -debug +incdir+../../../rtl/systemverilog/include \
       -y ${SRC1} -y ${SRC2} +libext+.sv

.PHONY:all
all:	simv

run:	simv
	./simv -l sim.log

simv:	${TOP} ${SRC1} ${SRC2}
	vcs ${ARGS} -l comp.log ${TOP}

clean:
	@rm -rf simv* *.log csrc ucli.key
