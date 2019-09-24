  ; Code of Chapter 5
  ; P46
  ; Author: rivalak
  ; Time: 2019-03-25 10:32

  ; Description: Get familiar with MBR(Master Boot Record)
  ; 显示 Label offset:[number]

  _code_segment:
        mov ax, 0xb800
        mov es, ax                       ; The begin physic address of graphics memory (project)


                                         ; (graphic memory)
                                         ; Display string "Label offset:"
                                         ; ASCII(1 Byte) + Attributes(1 Byte)
        mov byte [es:0x00], 'L'
        mov byte [es:0x01], 0x07
        mov byte [es:0x02], 'a'
        mov byte [es:0x03], 0x07
        mov byte [es:0x04], 'b'
        mov byte [es:0x05], 0x07
        mov byte [es:0x06], 'e'
        mov byte [es:0x07], 0x07
        mov byte [es:0x08], 'l'
        mov byte [es:0x09], 0x07
        mov byte [es:0x0a], ' '
        mov byte [es:0x0b], 0x07
        mov byte [es:0x0c], 'o'
        mov byte [es:0x0d], 0x07
        mov byte [es:0x0e], 'f'
        mov byte [es:0x0f], 0x07
        mov byte [es:0x10], 'f'
        mov byte [es:0x11], 0x07
        mov byte [es:0x12], 's'
        mov byte [es:0x13], 0x07
        mov byte [es:0x14], 'e'
        mov byte [es:0x15], 0x07
        mov byte [es:0x16], 't'
        mov byte [es:0x17], 0x07
        mov byte [es:0x18], ':'
        mov byte [es:0x19], 0x07

        ; Dividend: dx:ax ; number replace the data address
        ; Divisor: bx
				; number 是一个标号，存的是其汇编地址
        mov ax, number
        mov bx, 10

        mov cx, cs
        mov ds, cx                       ; cs = ds cause the data(number) in the same segment as code
                                         ; (main memory)
                                         ; ds = 0x0000, the code being loaded at 0x7c00
                                         ; mov dx, 0                       ;3 Bytes
        xor dx, dx                       ; 2 Bytes
        div bx
        mov [0x7c00+number+0x00], dl     ; single

        xor dx, dx
        div bx
        mov [0x7c00+number+0x01], dl     ; tens

        xor dx, dx
        div bx
        mov [0x7c00+number+0x02], dl     ; hundreds

        xor dx, dx
        div bx
        mov [0x7c00+number+0x03], dl     ; thousands

        xor dx, dx
        div bx
        mov [0x7c00+number+0x04], dl     ; ten thousands

                                         ; get ASCII code by add 0x30
                                         ; 0x04 是黑底红字； 0x07 黑底白字
                mov al, [0x7c00+number+0x04]
        add al, 0x30
        mov [es:0x1a], al
        mov byte [es:0x1b], 0x04

        mov al, [0x7c00+number+0x03]
        add al, 0x30
        mov [es:0x1c], al
        mov byte [es:0x1d], 0x04

        mov al, [0x7c00+number+0x02]
        add al, 0x30
        mov [es:0x1e], al
        mov byte [es:0x1f], 0x04

        mov al, [0x7c00+number+0x01]
        add al, 0x30
        mov [es:0x20], al
        mov byte [es:0x21], 0x04

        mov al, [0x7c00+number+0x00]
        add al, 0x30
        mov [es:0x22], al
        mov byte [es:0x23], 0x04

        mov byte [es:0x24], 'D'
        mov byte [es:0x25], 0x07

        ; infinit loop
    infi:
        jmp near infi

    _data_segment:
    number:
        db 0, 0, 0, 0, 0

    times 204 db 0                       ; Padding
              db 0x55, 0xaa              ; Effective flag of MBR

