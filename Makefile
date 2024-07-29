CC=gcc
build=build
incl:=-Iinclude/ $(addprefix -I, $(wildcard deps/*/include/))
flags=-g $(incl)
src=src
out=out
libs = $(shell find deps -name "*.a")
files := $(subst src, build, $(patsubst %.c, %.o, $(wildcard $(src)/*.c)))
$(build)/%.o: $(src)/%.c
	$(CC) -c $(flags) -o $(build)/$*.o $(src)/$*.c
$(build)/$(out): $(files) $(build)
	$(CC) $(flags) -o $(build)/$(out) $(filter-out $(build), $^) $(libs) 
	
$(build):
	mkdir build
.PHONY: clean
clean:
	rm -rf build
.PHONY: run
run:
	./$(build)/$(out)
