# Author: Dylan Turner
# Description: Build the executable

# Options

## Cargo build options for kernel
RUSTC :=			cargo
RUSTC_FLAGS :=		+nightly \
					rustc \
					--release \
					--target=x86_64-unknown-none \
					-- -C code-model=kernel -Z plt=y
RUST_SRC :=			$(wildcard mos-kernel/src/*.rs)

## Bootloader options


## Main binary
OBJNAME :=			cyubos.flp

# Targets

## Helper targets

.PHONY: all
all: $(OBJNAME)

.PHONY: clean
clean:
	$(MAKE) -C mos-boot clean
	rm -rf mos-kernel/target
	rm -rf mos-kernel/Cargo.lock
	rm -rf *.tmp
	rm -rf *.bin
	rm -rf *.o
	rm -rf *.flp
	rm -rf *.elf
	rm -rf *.sym

### The binaries making up the final thing

stage1.bin: $(wildcard mos-boot/stage1/*.asm)
ifeq ($(DEBUG),)
	$(MAKE) -C mos-boot
else
	$(MAKE) -C mos-boot DEBUG=1
endif
	cp mos-boot/$@ $@

stage2.o: $(wildcard mos-boot/stage2/*.asm)
ifeq ($(DEBUG),)
	$(MAKE) -C mos-boot
else
	$(MAKE) -C mos-boot DEBUG=1
endif
	cp mos-boot/$@ $@

kernel.o: $(RUST_SRC)
	cd mos-kernel; cargo $(RUSTC_FLAGS)
	cp mos-kernel/target/x86_64-unknown-none/release/libcyub_os_kernel.a $@

kernel.elf: stage2.o kernel.o
	ld -Tlink.ld

kernel.bin: kernel.elf
	objcopy -O binary $< $@

## Main targets
$(OBJNAME): stage1.bin kernel.bin
	rm -rf $@
	cat $^ >> $@

