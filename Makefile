core: deps main.o
	cc -g -o core main.o libelf/libelf.a libelf/libbele/libbele.a

main.o: main.c
	cc -g -c main.c

clean:
	rm core *.o

run: core
	./core

deps:
	@if [ ! -d libelf ]; then git clone -q https://github.com/tomriley/libelf; cd libelf; make; cd libbele; make; fi
