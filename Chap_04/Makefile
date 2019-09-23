#author: rivalak
#Time: 2019-03-21 21:55

NASM    = nasm
DD      = dd

DIR_ASM = ./asm
DIR_BIN = ./bin
DIR_IMG = ./img
DIR_VHD = ./vhd
ALLDIRs := $(DIR_ASM) $(DIR_BIN) $(DIR_IMG) $(DIR_VHD)

TARGET := $(DIR_BIN)/4-2.bin

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
all: clean TARGET vhd
.DEFAULT_GOAL := TARGET

$(TARGET): $(ASMs)
	@$(DO_DIRs)
	$(NASM) -f bin $< -o $@

.PHONY: vhd clean
	
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
clean:
	-rm -fr $(DIR_BIN) $(DIR_IMG) $(DIR_VHD)
