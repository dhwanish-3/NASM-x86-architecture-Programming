section .bss
    d1:resb 1
    count_dig:resb 1
    num:resd 1
    sum:resd 1
    temp:resb 1

section .data
    m1:db 'Enter number : '
    l1:equ $-m1
    m2:db 'Sum is : '
    l2:equ $-m2
    newline:db 0xa
    zero: db '0'

section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 0x80
        call scanf
        mov dword[sum],eax
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 0x80
        call scanf
        add dword[sum],eax

    print:
            mov eax,4
            mov ebx,1
            mov ecx,m2
            mov edx,l2
            int 0x80
            cmp dword[sum],0
            je print_zero
            mov byte[count_dig],0
        extract_num_digits:
            cmp dword[sum],0
            je print_num
            mov eax,dword[sum]
            mov edx,0
            mov ebx,10
            div ebx
            push dx
            
            inc byte[count_dig]
            mov dword[sum],eax
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
        mov dword[num],0
        read_num:
            mov eax,3
            mov ebx,0
            mov ecx,d1
            mov edx,1
            int 0x80
            cmp byte[d1],0xa
            je end_read
            mov ebx,10
            mov eax,dword[num]
            mul ebx
            sub byte[d1],0x30
            movzx ebx,byte[d1]
            add eax,ebx
            mov dword[num],eax
            jmp read_num
        end_read:
            mov eax,dword[num]
            ret
        

