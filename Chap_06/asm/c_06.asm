        ;Code of Chapter 6
        ;P76
        ;File name: c_06.asm
        ;Description: Get familiar with some assembler instructs
        ;Author: rivalak
        ;Time: 2019-03-27 16:15

        jmp near start              ;skip data

 mytext db 'L',0x07,'a',0x07,'b',0x07,'e',0x07,'l',0x07,' ',0x07,'o',0x07,\
            'f',0x07,'f',0x07,'s',0x07,'e',0x07,'t',0x07,':',0x07
 number db 0,0,0,0,0

 start:
        mov ax,0x7c0               ;set data segment base address
        mov ds,ax
        
        mov ax,0xb800              ;set es
        mov es,ax

        cld                         ;positive direction
                                    ;si,di automatically + 2

        ;source address:       ds:si
        ;destination address:  es:di
        ;times: cx
        mov si,mytext
        mov di,0
        mov cx,(number-mytext)/2
        rep movsw                   ;execute cx times

        mov ax,number
        mov bx,ax                   ;use bx as index
        mov cx,5
        mov si,10
 digit:
        xor dx,dx
        div si
        mov [bx],dl
        inc bx
        loop digit                  ;automatically execute cx-1

        ;move contents of number to es:di
        mov bx,number
        mov si,4
 show:
        mov al,[bx+si]
        add al,0x30
        mov ah,0x04
        mov [es:di],ax
        add di,2
        dec si
        jns show                    ;jmp while SF != 1

        mov byte [es:di],'D'
        inc di
        mov byte [es:di],0x07

        jmp near $

    times 510-($-$$) db 0
                     dw 0xaa55

