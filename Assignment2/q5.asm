section .bss
    n:resb 1
    count:resb 1
    sum:resw 1
    mean:resw 1
    d1:resb 1
    temp:resb 1
    num:resw 1

section .data
    m1:db 'Enter n : '
    l1:equ $-m1
    m2:db 'Enter '
    l2:equ $-m2
    m3:db 'th number : '
    l3:equ $-m3
    newline:db 0xa
    m4:db 'Mean of these '
    l4:equ $-m4
    m5:db 'numbers is : '
    l5:equ $-m5
    zero:db '0'

section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 0x80
        call scanf
        mov byte[n],al
        cmp byte[n],0
        je exit
        mov byte[count],1
        mov word[sum],0
        whileLoop:
            mov al,byte[count]
            cmp byte[n],al
            jb findMean
            mov eax,4
            mov ebx,1
            mov edx,l2
            mov ecx,m2
            int 0x80
            mov eax,4
            mov ebx,1
            mov edx,1
            add byte[count],0x30
            mov ecx,count
            int 0x80
            sub byte[count],0x30
            mov eax,4
            mov ebx,1
            mov edx,l3
            mov ecx,m3
            int 0x80
            call scanf
            mov word[num],ax
            add word[sum],ax
            inc byte[count]
            jmp whileLoop
        findMean:
            mov ax,word[sum]
            movzx bx,byte[n]
            mov dx,0
            div bx
            mov word[mean],ax
        print:
            mov eax,4
            mov ebx,1
            mov ecx,m4
            mov edx,l4
            int 0x80
            mov eax,4
            mov ebx,1
            add byte[n],0x30
            mov ecx,n
            mov edx,1
            int 0x80
            mov eax,4
            mov ebx,1
            mov ecx,m5
            mov edx,l5
            int 0x80
            mov byte[count],0
            cmp word[mean],0
            je print_zero

        extract_num_digits:
        cmp word[mean],0
        je print_num
        mov ax,word[mean]
        mov dx,0
        mov bx,10
        div bx
        push dx
        
        inc byte[count]
        mov word[mean],ax
        jmp extract_num_digits

        print_num:
            cmp byte[count],0
            je end_print
            dec byte[count]
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
        mov word[num],0
        read_num:
            mov eax,3
            mov ebx,0
            mov ecx,d1
            mov edx,1
            int 0x80
            cmp byte[d1],0xa
            je end_read
            mov bx,10
            mov ax,word[num]
            mul bx
            sub byte[d1],0x30
            movzx bx,byte[d1]
            add ax,bx
            mov word[num],ax
            jmp read_num
        end_read:
            mov ax,word[num]
            ret
