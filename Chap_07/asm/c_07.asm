        ;code of Chapter 7
        ;P98
        ;File name: c_07.asm
        ;Description: Get familiar with 'Stack'
        ;Author: rivalak
        ;Time: 2019-03-28 17:04

        jmp near start

message db '1+2+3+...+100='

start:
        mov ax,0x07c0
        mov ds,ax

        mov ax,0xb800
        mov es,ax

        ;show "message"
        mov si,message
        mov di,0
        mov cx,start-message
    @show_mess:
        mov al,[si]
        mov [es:di],al
        inc di
        mov byte [es:di],0x07
        inc di
        inc si
        loop @show_mess

        ;get answer
        xor ax,ax
        mov cx,100
    @get_answ:
        add ax,cx
        dec cx
        cmp cx,0
        jne @get_answ

        ;use Stack to store 'answer'
        xor cx,cx
        mov ss,cx               ;set stack segment address as 0
        mov sp,cx               ;set stack pointer address as 0

        mov bx,10
    @stac_answ:
        inc cx
        xor dx,dx
        div bx
        or dl,0x30
        push dx                 ;only support word
        cmp ax,0
        jne @stac_answ

        ;show 'answer'
    @show_answ:
        pop dx
        mov [es:di],dl
        inc di
        mov byte [es:di],0x07
        inc di
        loop @show_answ         ;loop auto do cx-1

        jmp near $              ;infinit loop

times 510-($-$$) db 0
                 dw 0xaa55      
        

        
        
