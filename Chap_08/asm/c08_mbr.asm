        ; Code of Chapter 8  P114
        ; Description: MBR/Loader
        ; Author: rivalak
        ; Time: 2019-03-28 22:07

        app_lba_start equ 100             ; user program start logic sector number

SECTION mbr align=16 vstart=0x07c00       ; vstart: relevant logic address
                                          ; cs: 0x0000

                                          ; set stack segment and stack pointer
        mov ax,0
        mov ss,ax
        mov sp,ax

        ; compute logic segment address for user program
        ; 8086 real mode physic address align=16
        mov ax,[cs:phy_base]
        mov dx,[cs:phy_base+0x02]
        mov bx,16                         ; get segment address
        div bx                            ; div 16 == >> 4 bits
        mov ds,ax
        mov es,ax

        ; read user program start part
        ; hard disk addressing mode = LBA28
        ; starting logic sector number(at hda) = app_lba_start
        xor di,di                         ; di:si = starting logic sector number
        mov si,app_lba_start
        xor bx,bx                         ; destination = DS:BX(0000)
        call read_hard_disk_0

        ; count the number of sectors to be loaded
        mov dx,[2]                        ; user head use 4 Bytes store
        mov ax,[0]                        ; user program's length
        mov bx,512
        div bx                            ; ax=answer, dx=reminder
        cmp dx,0
        jnz @1
        dec ax
    @1:
        cmp ax,0
        jz direct

        ; read the remaining sectors
        ; read a sector every time
        push ds

        mov cx,ax                         ; the number of remaining sectors
    @2:
        mov ax,ds
        add ax,0x20                       ; get the segment address divided by 512 Bytes
        mov ds,ax

        xor bx,bx                         ; ds:0x0000
        inc si
        call read_hard_disk_0
        loop @2

        pop ds

        ; compute entry point code segment base address
    direct:
        mov dx,[0x08]
        mov ax,[0x06]
        call calc_segment_base
        mov [0x06],ax                     ; 'backfill' the modified address of entry point code segment

                                          ; start process segment realloc table
        mov cx,[0x0a]                     ; the number of entry
        mov bx,[0x0c]                     ; first address of realloc table
realloc:
        mov dx,[bx+0x02]                  ; high address of 32 bits
        mov ax,[bx]
        call calc_segment_base
        mov [bx],ax                       ; 'backfill'
        add bx,4                          ; 4 Bytes every entry
        loop realloc

        jmp far [0x04]                    ; shift to user program

                                          ; ----------------------------------------------------------------------------
calc_segment_base:                        ; calculate 16 bits segment address
                                          ; Input: DX:AX=32 bits 'physic' address
                                          ; Return: AX=16 bits segment base address
        push dx

        add ax,[cs:phy_base]
        adc dx,[cs:phy_base+0x02]         ; now the address = dx:ax, but only 20 bits
                                          ; is effective, the lower 16 bits in ax, last
                                          ; 4 bits in dx(lower 4 bits)
                                          ; segment address is 16-byte alignment
                                          ; saved at ax
        shr ax,4
        ror dx,4
        and dx,0xf000
        or ax,dx

        pop dx

        ret

        ; ----------------------------------------------------------------------------




        ; ----------------------------------------------------------------------------
read_hard_disk_0:                         ; read a logic sector from hda
                                          ; to DS segment
                                          ; input: DI:SI=starting logic sector number
        push ax                           ; register stack
        push bx
        push cx
        push dx

        ; Step 1: set number of sectors to be read
        mov dx,0x1f2                      ; particular port
        mov al,1
        out dx,al

        ; Step 2: set LBA28
        inc dx                            ; 0x1f3 LBA address: 7~0
        mov ax,si
        out dx,al                         ; only ax

        inc dx                            ; 0x1f4 LBA address: 15~8
        mov al,ah
        out dx,al

        inc dx                            ; 0x1f5 LBA address: 23~16
        mov ax,di
        out dx,al

        inc dx                            ; 0x1f6 LBA address: 27~24
        mov al,0xe0                       ; 1110(LBA mode + main disk) 0000
        or al,ah
        out dx,al                         ; LBA address: 27~24

                                          ; Step 3: set read command
        inc dx                            ; 0x1f7(command/status port)
        mov al,0x20                       ; read command
        out dx,al

        ; Step 4: judge hda's status
    .waits:
        in al,dx                          ; read 0x1f7 status and not change its value
        and al,0x88                       ; keep 10001000
        cmp al,0x08                       ; judge whether disk read and idel
        jnz .waits                        ; cmp result: equ ZF = 0

                                          ; Step 5: read data to DS:BX
                                          ; 0x1f0: 16 bits
        mov cx,256
        mov dx,0x1f0
    .readw:
        in ax,dx
        mov [bx],ax
        add bx,2
        loop .readw

        pop dx
        pop cx
        pop bx
        pop ax

        ret

        ; ----------------------------------------------------------------------------
        phy_base dd 0x10000               ; the physic address that the user program
                                          ; will be loaded
times 510-($-$$) db 0
                 db 0x55,0xaa

