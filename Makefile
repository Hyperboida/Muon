CC=gcc
build=build
incl:=-Iinclude/ -Ilibs/extlib/include/
flags=-g $(incl)
src=src
out=out
libs := $(wildcard libs/extlib/cmake/bin/lib/*.a)
files := $(subst src, build, $(patsubst %.c, %.o, $(wildcard $(src)/*.c)))
$(build)/%.o: $(src)/%.c
	$(CC) -c $(flags) -o $(build)/$*.o $(src)/$*.c $(libs)
$(build)/$(out): $(files) $(libs) $(build)
	$(CC) $(flags) -o $(build)/$(out) $(filter-out $(build), $^) 
	
$(build):
	mkdir build
.PHONY: clean
clean:
	rm -rf build
.PHONY: run
run:
	./$(build)/$(out)
