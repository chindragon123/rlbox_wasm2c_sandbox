CC=build/_deps/wasiclang-src/bin/clang
CXX=build/_deps/wasiclang-src/bin/clang++
CFLAGS=--sysroot build/_deps/wasiclang-src/share/wasi-sysroot
LD=build/_deps/wasiclang-src/bin/wasm-ld
LDSRC=$(wildcard *.o) 
LDCSRC=$(wildcard c_src/*.c) 
LDFLAGS=-Wl,-export-all -Wl,-no-entry -Wl,-growable-table
WASMC=build/_deps/mod_wasm2c-src/bin/wasm2c 
GCCFLAGS=-shared -fPIC -O3 -o 
WASMCFILES=wasm-rt-impl.c wasm-rt-os-unix.c wasm-rt-os-win.c wasm-rt-wasi.c
WASMCPATH=build/_deps/mod_wasm2c-src/wasm2c/
WASMADJFILES=$(addprefix $(WASMCPATH), $(WASMCFILES))
start:
	$(CC) $(CFLAGS) -c $(LDCSRC)
libFoo.wasm:
	$(CC) $(CFLAGS) $(LDSRC) $(LDFLAGS) -o libFoo.wasm
libWasmFoo.c: libFoo.wasm
	$(WASMC) -o libWasmFoo.c libFoo.wasm
libpng.so: libWasmFoo.c
	gcc $(GCCFLAGS) $@ libWasmFoo.c $(WASMADJFILES)
clean:
	rm -f libFoo.wasm
	rm -f libWasmFoo.c
	rm -f libpng.so
	rm -f $(LDSRC)
	rm -f libWasmFoo.h
