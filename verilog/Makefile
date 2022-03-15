core_tb: *.v
	iverilog -g2005-sv -o core_tb core_tb.v

clean:
	rm -f core_tb

test: core_tb
	./test-rv32ui-p.rb

test-add: core_tb
	vvp -n core_tb +MEM=tests/rv32ui-p-add.hex

test-lw: core_tb
	vvp -n core_tb +MEM=tests/rv32ui-p-lw.hex
