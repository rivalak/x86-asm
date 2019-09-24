#author: rivalak
#Time: 2019-03-25 15:32

NASM    	= nasm
DISASM 		= ndisasm
DD      	= dd
BEGIN_ADD 	= 0x7c00
QEMU 		= qemu-system-i386

DIR_ASM = ./asm
DIR_BIN = ./bin
DIR_IMG = ./img
DIR_VHD = ./vhd
ALLDIRs := $(DIR_ASM) $(DIR_BIN) $(DIR_IMG) $(DIR_VHD)

TARGET := $(DIR_BIN)/c_5.bin

DO_DIRs = \
for i in $(ALLDIRs); \
	do (if [ -d $$i ]; then exit 0; else mkdir $$i; fi); \
done

ASMs = $(shell ls $(DIR_ASM)/*.asm)
BIN = $(TARGET)
BASE_BIN = $(basename $(notdir $(BIN) ) )
IMG = $(addsuffix .img, $(addprefix $(DIR_IMG)/, $(BASE_BIN)))
VHD = $(addsuffix .vhd, $(addprefix $(DIR_VHD)/, $(BASE_BIN)))

TARGET: $(TARGET)
all: clean TARGET dis_asm vhd
.DEFAULT_GOAL := TARGET

$(TARGET): $(ASMs)
	@$(DO_DIRs)
	$(NASM) -f bin $< -o $@

.PHONY: vhd dis_asm qemu clean
	
ACT_VHD = \
$(DD) if=/dev/zero of=$(IMG) count=10000; \
$(DD) if=$(BIN) of=$(IMG) conv=notrunc; \
VBoxManage convertfromraw $(IMG) $(VHD) --format VHD

DO_VHD = \
if [ -f $(VHD) ]; \
then rm -f $(VHD); \
$(ACT_VHD); \
else \
$(ACT_VHD); \
fi

vhd: $(BIN)
	@$(DO_VHD)

dis_asm: $(BIN)
	$(DISASM) -o $(BEGIN_ADD) $(BIN) > $(DIR_ASM)/dis_c_5.asm

qemu: $(BIN)
	$(QEMU) -hda $(BIN)

clean:
	-rm -fr $(DIR_BIN) $(DIR_IMG) $(DIR_VHD)
