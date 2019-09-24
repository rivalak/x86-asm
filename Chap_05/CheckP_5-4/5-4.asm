            ; author: rivalak
            ; Time: 2019-03-22 21:00
            ; P66

            ; 通过反汇编验证两条 jmp (相对近跳转和绝对地址跳转) 的机器码

            jmp near start              ; E9 02 00   (5 - 3)
    data:    db 0x55, 0xaa               ; 注：两字节长度
    start:  mov ax, 0
            jmp 0x2000:0x0005           ; EA 05 00 00 20
