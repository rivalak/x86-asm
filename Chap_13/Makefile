#author: rivalak
#Time: 2019-03-29 20:13

NASM    	= nasm
DISASM 		= ndisasm
DD      	= dd
QEMU 		= qemu-system-i386
BOCHS   = bochs
BXIMAGE = bximage

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
BINs = $(patsubst %.asm,$(DIR_BIN)/%.bin,$(notdir $(ASMs)))
IMG = $(DIR_IMG)/chap_13.img
BXIMG = $(DIR_IMG)/c_13bx.img
VHD = $(DIR_VHD)/chap_13.vhd

TARGET: $(TARGET)
all: clean TARGET
.DEFAULT_GOAL := TARGET

$(DIR_BIN)/%.bin: $(DIR_ASM)/%.asm
	@$(DO_DIRs)
	$(NASM) -f bin $< -o $@

ACT_VHD = \
$(DD) if=/dev/zero of=$(IMG) count=10000; \
$(DD) if=$(DIR_BIN)/c13_mbr.bin of=$(IMG) conv=notrunc; \
$(DD) if=$(DIR_BIN)/c13_core.bin of=$(IMG) seek=1 conv=notrunc; \
$(DD) if=$(DIR_BIN)/c13.bin of=$(IMG) seek=50 conv=notrunc; \
$(DD) if=$(DIR_ASM)/diskdata.txt of=$(IMG) seek=100 conv=notrunc; \
VBoxManage convertfromraw $(IMG) $(VHD) --format VHD

DO_VHD = \
if [ -f $(VHD) ]; \
then rm -f $(VHD); \
$(ACT_VHD); \
else \
$(ACT_VHD); \
fi

$(TARGET): $(BINs)
	@$(DO_VHD)

$(BXIMG): $(BINs)
	@$(BXIMAGE) -hd -size=5 -q $(BXIMG)
	@$(DD) if=$(DIR_BIN)/c13_mbr.bin of=$(BXIMG) conv=notrunc
	@$(DD) if=$(DIR_BIN)/c13_core.bin of=$(BXIMG) seek=1 conv=notrunc
	@$(DD) if=$(DIR_BIN)/c13.bin of=$(BXIMG) seek=50 conv=notrunc
	@$(DD) if=$(DIR_ASM)/diskdata.txt of=$(BXIMG) seek=100 conv=notrunc

.PHONY: qemu bochs clean

qemu: $(VHD)
	$(QEMU) -hda $(VHD)

bochs: $(BXIMG)
	@$(BOCHS)

clean:
	-rm -fr $(DIR_BIN) $(DIR_IMG) $(DIR_VHD)
