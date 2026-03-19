.PHONY: all build run clean

all: build run

build: build/testbench.vpp

build/testbench.vpp: src/tm1638.v testbench/testbench.v
	mkdir -p build
	iverilog -o $@ $^

run: tm1638.vcd

tm1638.vcd: build
	build/testbench.vpp

clean:
	rm -f tm1638.vcd
	rm -rf build
