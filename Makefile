riscv-core: deps main.o utils.o
	cc -g -o riscv-core main.o utils.o libelf/libelf.a libelf/libbele/libbele.a

main.o: main.c
	cc -g -c main.c

utils.o: utils.c
	cc -g -c utils.c

clean:
	rm -f riscv-core *.o

run: riscv-core
	./riscv-core riscv-tests/isa/rv32ui-p-auipc

deps:
	@if [ ! -d libelf ]; then git clone -q https://github.com/tomriley/libelf; cd libelf; make; cd libbele; make; fi
