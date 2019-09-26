        ; Code of Chapter 6
        ; P76
        ; Author: rivalak
        ; Time: 2019-03-27 16:15
        ; Description: Get familiar with some assembler instructs
        ; 段之间的批量数据传送
        jmp near start          ; skip data

 mytext db 'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l',0x07,' ',0x07,'o',0x07,\
            'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07
 number db 0,0,0,0,0            ; 主要目的是保存数位

 start:
        mov ax,0x7c0            ; set data segment base address
        mov ds,ax

        mov ax,0xb800           ; set es
        mov es,ax

        ; 用 movsw 来批量传送数据

        cld                     ; 方向标志清零指令 cld std

        mov si,mytext
        mov di,0
        mov cx,(number-mytext)/2
        rep movsw               ; execute cx times, 直到 cx 为零

                                ; 用循环来分解数位
        mov ax,number
        mov bx,ax               ; use bx as index
        mov cx,5
        mov si,10
 digit:
        xor dx,dx
        div si
        mov [bx],dl
        inc bx
        loop digit
        ; move content of number to es:di
        mov bx,number
        mov si,4
 show:  mov al,[bx+si]
        add al,0x30             ; 得到 ascii 码
        mov ah,0x04             ; 显示属性
        mov [es:di],ax
        add di,2
        dec si
        ; jns 是相对 条件 转移指令，参考 标志寄存器符号位SF 是否为1
        jns show                ; jmp while SF != 1

        mov byte [es:di],'D'
        inc di
        mov byte [es:di],0x07

        jmp near $

        times 510-($-$$) db 0
        dw 0xaa55

