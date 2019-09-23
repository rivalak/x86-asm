;author: rivalak
;Time: 2019-03-22 21:00

            jmp near start
    data    db 0x55, 0xaa
    start:  mov ax, 0
            jmp 0x2000:0x0005
