#author: rivalak
#Time: 2019-03-25 15:32

NASM    	= nasm
DISASM 		= ndisasm
DD      	= dd
BEGIN_ADD 	= 0x7c00
QEMU 		= qemu-system-i386

ASMs = ./asm/c_07.asm
BINs = ./bin/c_07.bin

DIR_ASM = ./asm
DIR_BIN = ./bin
ALLDIRs := $(DIR_ASM) $(DIR_BIN)

TARGET = $(BINs)

DO_DIRs = \
for i in $(ALLDIRs); \
	do (if [ -d $$i ]; then exit 0; else mkdir $$i; fi); \
done

TARGET: $(TARGET)
all: clean TARGET
.DEFAULT_GOAL := TARGET

$(TARGET): $(ASMs)
	@$(DO_DIRs)
	$(NASM) -f bin $< -o $@

.PHONY: qemu clean

qemu: $(BINs)
	$(QEMU) -hda $(BINs)

clean:
	-rm -fr $(DIR_BIN)
