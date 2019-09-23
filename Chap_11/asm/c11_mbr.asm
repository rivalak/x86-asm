        ;Chapter 8
        ;File name: c11_mbr.asm
        ;Description: from real mode to protection mode
        ;Author: rivalak
        ;Time: 2019-04-04 17:29

        mov ax,cs
        mov ss,ax
        mov sp,0x7c00

        ;Get logic seg addr of GDT
        ;32 lineal addr to 20 logic addr
        mov ax,[cs:gdt_base+0x7c00]         
        mov dx,[cs:gdt_base+0x7c00+0x02]
        mov bx,16
        div bx
        mov ds,ax
        mov bx,dx

        ;0# descriptor: NULL
        mov dword [bx+0x00],0x00
        mov dword [bx+0x04],0x00

        ;1# descriptor: protection mode code seg descriptor
        mov dword [bx+0x08],0x7c0001ff
        mov dword [bx+0x0c],0x00409800

        ;2# ~: ~ data ~(display buffer in text mode)
        mov dword [bx+0x10],0x8000ffff
        mov dword [bx+0x14],0x0040920b

        ;3# ~: protection mode stack seg descriptor
        mov dword [bx+0x18],0x00007a00
        mov dword [bx+0x1c],0x00409600

        ;initialize GDTR
        mov word [cs:gdt_size+0x7c00],31    ;initialize gdt_size: total 4 descriptors

        lgdt [cs:gdt_size+0x7c00]           ;oprand 6 Bytes 

        ;open A20
        in al,0x92
        or al,0000_0010B
        out 0x92,al

        cli

        ;set PE
        mov eax,cr0
        or eax,1
        mov cr0,eax

        ;entering protection mode
        ;16 bits descriptor selector: 32 bits offset
        ;use jmp to flush pipe line
        jmp dword 0x0008:flush

        [bits 32]

    flush:
        ;index GDT
        mov cx,0000_0000_000_10_000B
        mov ds,cx

        ;show "Protect mode OK."
         mov byte [0x00],'P'  
         mov byte [0x02],'r'
         mov byte [0x04],'o'
         mov byte [0x06],'t'
         mov byte [0x08],'e'
         mov byte [0x0a],'c'
         mov byte [0x0c],'t'
         mov byte [0x0e],' '
         mov byte [0x10],'m'
         mov byte [0x12],'o'
         mov byte [0x14],'d'
         mov byte [0x16],'e'
         mov byte [0x18],' '
         mov byte [0x1a],'O'
         mov byte [0x1c],'K'

         ;a example to help elastrate stack operation of 32 protect mode
        mov cx,000000000000_11_000B
        mov ss,cx
        mov esp,0x7c00

        mov ebp,esp
        push byte '.'

        sub ebp,4
        cmp ebp,esp
        jnz ghalt
        pop eax
        mov [0x1e],al                   ;show '.'

    ghalt:
        hlt                 ;cli so cannot wake up
;------------------------------------------------------------------------------

        gdt_size        dw 0
        gdt_base        dd 0x00007e00           ;GDT phy addr

times 510-($-$$) db 0
                 db 0x55,0xaa

