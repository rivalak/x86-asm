ASM = nasm
DISASM = ndisasm
ASMFILE = 5-4.asm
BEGIN_ADD = 0x0000

all: $(ASMFILE)
	$(ASM) -f bin $< -o 5-4.bin
	$(DISASM) -o $(BEGIN_ADD) 5-4.bin >> dis5-4.asm
