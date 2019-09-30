         ; �����嵥12-1
         ; �ļ�����c12_mbr.asm
         ; �ļ�˵����Ӳ����������������
         ; �������ڣ�2011-10-27 22:52

         ; ���ö�ջ�κ�ջָ��
         mov eax,cs
         mov ss,eax
         mov sp,0x7c00

         ; ����GDT���ڵ��߼��ε�ַ
         mov eax,[cs:pgdt+0x7c00+0x02]      ; GDT��32λ���Ի���ַ
         xor edx,edx
         mov ebx,16
         div ebx                            ; �ֽ��16λ�߼���ַ

         mov ds,eax                         ; ��DSָ��ö��Խ��в���
         mov ebx,edx                        ; ������ʼƫ�Ƶ�ַ

                                            ; ����0#�����������ǿ������������Ǵ�������Ҫ��
         mov dword [ebx+0x00],0x00000000
         mov dword [ebx+0x04],0x00000000

         ; ����1#������������һ�����ݶΣ���Ӧ0~4GB�����Ե�ַ�ռ�
         mov dword [ebx+0x08],0x0000ffff    ; ����ַΪ0���ν���Ϊ0xfffff
         mov dword [ebx+0x0c],0x00cf9200    ; ����Ϊ4KB���洢����������

                                            ; ��������ģʽ�³�ʼ�����������
         mov dword [ebx+0x10],0x7c0001ff    ; ����ַΪ0x00007c00��512�ֽ�
         mov dword [ebx+0x14],0x00409800    ; ����Ϊ1���ֽڣ������������

                                            ; �������ϴ���εı���������
         mov dword [ebx+0x18],0x7c0001ff    ; ����ַΪ0x00007c00��512�ֽ�
         mov dword [ebx+0x1c],0x00409200    ; ����Ϊ1���ֽڣ����ݶ�������

         mov dword [ebx+0x20],0x7c00fffe
         mov dword [ebx+0x24],0x00cf9600

         ; ��ʼ�����������Ĵ���GDTR
         mov word [cs: pgdt+0x7c00],39      ; ���������Ľ���

         lgdt [cs: pgdt+0x7c00]

         in al,0x92                         ; ����оƬ�ڵĶ˿�
         or al,0000_0010B
         out 0x92,al                        ; ��A20

         cli                                ; �жϻ�����δ����

         mov eax,cr0
         or eax,1
         mov cr0,eax                        ; ����PEλ

                                            ; ���½��뱣��ģʽ... ...
         jmp dword 0x0010:flush             ; 16λ��������ѡ���ӣ�32λƫ��

         [bits 32]
  flush:
         mov eax,0x0018
         mov ds,eax

         mov eax,0x0008                     ; �������ݶ�(0..4GB)ѡ����
         mov es,eax
         mov fs,eax
         mov gs,eax

         mov eax,0x0020                     ; 0000 0000 0010 0000
         mov ss,eax
         xor esp,esp                        ; ESP <- 0

         mov dword [es:0x0b8000],0x072e0750 ; �ַ�'P'��'.'������ʾ����
         mov dword [es:0x0b8004],0x072e074d ; �ַ�'M'��'.'������ʾ����
         mov dword [es:0x0b8008],0x07200720 ; �����հ��ַ�������ʾ����
         mov dword [es:0x0b800c],0x076b076f ; �ַ�'o'��'k'������ʾ����

                                            ; ��ʼð������
         mov ecx,pgdt-string-1              ; ��������=������-1
  @@1:
         push ecx                           ; 32λģʽ�µ�loopʹ��ecx
         xor bx,bx                          ; 32λģʽ�£�ƫ����������16λ��Ҳ����
  @@2:                                      ; �Ǻ����32λ
         mov ax,[string+bx]
         cmp ah,al                          ; ah�д�ŵ���Դ�ֵĸ��ֽ�
         jge @@3
         xchg al,ah
         mov [string+bx],ax
  @@3:
         inc bx
         loop @@2
         pop ecx
         loop @@1

         mov ecx,pgdt-string
         xor ebx,ebx                        ; ƫ�Ƶ�ַ��32λ�����
  @@4:                                      ; 32λ��ƫ�ƾ��и���������
         mov ah,0x07
         mov al,[string+ebx]
         mov [es:0xb80a0+ebx*2],ax          ; ��ʾ0~4GBѰַ��
         inc ebx
         loop @@4

         hlt

         ; -------------------------------------------------------------------------------
     string           db 's0ke4or92xap3fv8giuzjcy5l1m7hd6bnqtw.'
     ; -------------------------------------------------------------------------------
     pgdt             dw 0
                      dd 0x00007e00         ; GDT��������ַ
                                            ; -------------------------------------------------------------------------------
     times 510-($-$$) db 0
                      db 0x55,0xaa
