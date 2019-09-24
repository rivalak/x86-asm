00000000  E90200            jmp 0x5
00000003  55                push bp
00000004  AA                stosb
00000005  B80000            mov ax,0x0
00000008  EA05000020        jmp 0x2000:0x5
