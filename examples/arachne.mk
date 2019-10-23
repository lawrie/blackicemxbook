bin/toplevel.json : ${VERILOG}
	mkdir -p bin
	yosys -v3 -p "synth_ice40 -blif bin/toplevel.blif" ${VERILOG}

bin/toplevel.asc : ${PCF} bin/toplevel.json
	arachne-pnr -d 8k -P tq144:4k -p ${PCF} bin/toplevel.blif -o  bin/toplevel.asc

bin/toplevel.bin : bin/toplevel.asc
	icepack bin/toplevel.asc bin/toplevel.bin

compile : bin/toplevel.bin

time: bin/toplevel.bin
	icetime -tmd hx8k bin/toplevel.asc

upload : bin/toplevel.bin
	stty -F /dev/ttyACM0 raw
	cat bin/toplevel.bin >/dev/ttyACM0

clean :
	rm -rf bin

