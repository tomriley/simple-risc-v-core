riscv-core: deps main.o utils.o
	cc -g -o riscv-core main.o utils.o libelf/libelf.a libelf/libbele/libbele.a

main.o: main.c main.h utils.h
	cc -g -c main.c

utils.o: utils.c utils.h
	cc -g -c utils.c

clean:
	rm -f riscv-core *.o

test: riscv-core
	./test-rv32ui-p.rb

test-add: riscv-core
	./riscv-core riscv-tests/isa/rv32ui-p-add

deps:
	@if [ ! -d libelf ]; then git clone -q https://github.com/tomriley/libelf; cd libelf; make; cd libbele; make; fi
