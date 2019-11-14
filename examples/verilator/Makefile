VERILOG_FILES = thruwire.v
PCF_FILE = thruwire.pcf
CPP_FILES = thruwire.cpp
VERILATOR_HOME = /usr/local/share/verilator

include ../blackicemx.mk

sim: ${VERILOG_FILES} ${CPP_FILES}
	verilator  -Wall -cc  ${VERILOG_FILES}
	(cd obj_dir; make -f Vthruwire.mk)
	g++ -I ${VERILATOR_HOME}/include -I obj_dir/ ${VERILATOR_HOME}/include/verilated.cpp ${CPP_FILES}  obj_dir/Vthruwire__ALL.a -o tb
	./tb

clean:
	rm -rf bin obj_dir tb

