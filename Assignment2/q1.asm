section .bss
    d1: resb 1
    num: resb 1
    temp: resb 1
    count_dig: resb 1
    count: resb 1
    max: resb 1

section .data
    m1: db 'Enter number : '
    l1: equ $-m1
    m2: db 'Maximum of the 3 numbers is : '
    l2: equ $-m2
    space: db ' '
    newline: db 0xa
    zero: db '0'

section .text
    global _start
    _start:
        mov byte[count],0
        mov byte[max],0
        read_3_numners:
            mov eax,4
            mov ebx,1
            mov ecx,m1
            mov edx,l1
            int 0x80
            call scanf
            mov byte[num],al
            mov bl,byte[max]
            cmp bl,byte[num]
            ja increase
            max_assign:
            mov bl,byte[num]
            mov byte[max],bl
            increase:
            inc byte[count]
            cmp byte[count],3
            jne read_3_numners
        print:
            mov eax,4
            mov ebx,1
            mov ecx,m2
            mov edx,l2
            int 0x80
            cmp byte[max],0
            je print_zero
            mov byte[count_dig],0
        extract_num_digits:
            cmp byte[max],0
            je print_num
            mov al,byte[max]
            mov dx,0
            mov bx,10
            div bx
            push dx
            
            inc byte[count_dig]
            mov byte[max],al
            jmp extract_num_digits

        print_num:
            cmp byte[count_dig],0
            je end_print
            dec byte[count_dig]
            pop dx
            mov byte[temp],dl
            add byte[temp],30h
            mov eax,4
            mov ebx,1
            mov ecx,temp
            mov edx,1
            int 0x80
            jmp print_num
        print_zero:
            mov eax,4
            mov ebx,1
            mov ecx,zero
            mov edx,1
            int 0x80
        end_print:
            mov eax,4
            mov ebx,1
            mov ecx,newline
            mov edx,1
            int 0x80
        exit:
            mov eax,1
            mov ebx,0
            int 0x80

        scanf: ;subprogram
            mov byte[num],0
            mov byte[count_dig],0
            read_num:
                inc byte[count_dig]
                cmp byte[count_dig],4
                je end_read
                mov eax,3
                mov ebx,0
                mov ecx,d1
                mov edx,1
                int 0x80
                cmp byte[d1],0xa
                je end_read
                
                mov bl,10
                mov al,byte[num]
                mul bl
                sub byte[d1],30h
                add al,byte[d1]
                mov byte[num],al
                jmp read_num
            end_read:
                mov al,byte[num]
                ret

