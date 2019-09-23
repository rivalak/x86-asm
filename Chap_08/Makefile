#author: rivalak
#Time: 2019-03-29 20:13

NASM    	= nasm
DISASM 		= ndisasm
DD      	= dd
BEGIN_ADD 	= 0x7c00
QEMU 		= qemu-system-x86_64

DIR_ASM = ./asm
DIR_BIN = ./bin
DIR_IMG = ./img
DIR_VHD = ./vhd
ALLDIRs := $(DIR_ASM) $(DIR_BIN) $(DIR_IMG) $(DIR_VHD)

TARGET = $(VHD)

DO_DIRs = \
for i in $(ALLDIRs); \
	do (if [ -d $$i ]; then exit 0; else mkdir $$i; fi); \
done

ASMs = $(wildcard $(DIR_ASM)/*.asm)
BIN = $(patsubst %.asm,$(DIR_BIN)/%.bin,$(notdir $(ASMs)))
IMG = $(DIR_IMG)/chap_8.img
VHD = $(DIR_VHD)/chap_8.vhd

TARGET: $(TARGET)
all: clean TARGET
.DEFAULT_GOAL := TARGET

$(DIR_BIN)/%.bin: $(DIR_ASM)/%.asm
	@$(DO_DIRs)
	$(NASM) -f bin $< -o $@

ACT_VHD = \
$(DD) if=/dev/zero of=$(IMG) count=10000; \
$(DD) if=$(DIR_BIN)/c08_mbr.bin of=$(IMG) conv=notrunc; \
$(DD) if=$(DIR_BIN)/c08.bin of=$(IMG) seek=100 conv=notrunc; \
VBoxManage convertfromraw $(IMG) $(VHD) --format VHD

DO_VHD = \
if [ -f $(VHD) ]; \
then rm -f $(VHD); \
$(ACT_VHD); \
else \
$(ACT_VHD); \
fi

$(TARGET): $(BIN)
	@$(DO_VHD)

.PHONY: qemu clean

#dis_asm: $(BIN)
#	$(DISASM) -o $(BEGIN_ADD) $(BIN) > $(DIR_ASM)/dis_c_5.asm

qemu: $(VHD)
	$(QEMU) -hda $(VHD)

clean:
	-rm -fr $(DIR_BIN) $(DIR_IMG) $(DIR_VHD)
