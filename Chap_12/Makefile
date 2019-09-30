#author: rivalak
#Time: 2019-03-29 20:13

NASM    	= nasm
DISASM 		= ndisasm
DD      	= dd
BEGIN_ADD 	= 0x7c00
QEMU 		= qemu-system-i386

DIR_ASM = ./asm
DIR_BIN = ./bin
ALLDIRs := $(DIR_ASM) $(DIR_BIN)

DO_DIRs = \
for i in $(ALLDIRs); \
	do (if [ -d $$i ]; then exit 0; else mkdir $$i; fi); \
done

ASMs = $(wildcard $(DIR_ASM)/*.asm)
BIN = $(patsubst %.asm,$(DIR_BIN)/%.bin,$(notdir $(ASMs)))

TARGET: $(TARGET)
all: clean TARGET
.DEFAULT_GOAL := TARGET

$(DIR_BIN)/%.bin: $(DIR_ASM)/%.asm
	@$(DO_DIRs)
	$(NASM) -f bin $< -o $@

$(TARGET): $(BIN)
	@$(DO_VHD)

.PHONY: qemu clean

qemu: $(BIN)
	$(QEMU) -hda $(BIN)

clean:
	-rm -fr $(DIR_BIN)
