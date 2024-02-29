section .bss
    num:resd 1
    sum:resd 1
    temp:resb 1

section .data
    m1:db 'System is Little Endian',0xa
    l1:equ $-m1
    m2:db 'System is Big Endian',0xa
    l2:equ $-m2
    newline:db 0xa

section .text
    global _start
    _start:
        ;moving 8 bit number to a 16 bit register
        mov ax,255
        ;checking if stored in lower order or higher order
        cmp ah,255
        je print_big_endian
        cmp al,255
        je print_little_endian

        print_big_endian:
        mov eax,4
        mov ebx,1
        mov ecx,m2
        mov edx,l2
        int 0x80

        print_little_endian:
            mov eax,4
            mov ebx,1
            mov ecx,m1
            mov edx,l1
            int 0x80
    
        exit:
            mov eax,1
            mov ebx,0
            int 0x80       

