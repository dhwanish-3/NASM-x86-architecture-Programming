section .data
    m1:db 'enter n : '
    l1:equ $-m1
    m2:db 'enter m : '
    l2:equ $-m2
    m3:db 'enter matrix : ',0xa
    l3:equ $-m3
    m4:db 'enter matrix : ',0xa
    l4:equ $-m4
    space : db ' '
    newline: db 0xa
    neg_sign:db '-'
    zero:db '0'

section .bss
    temp:resw 1
    num: resw 1
    count:resb 1
    digit:resb 1
    matrix: resw 100
    transpose: resw 100
    n: resw 1
    m: resw 1
    i: resw 1
    j: resw 1
    negative: resb 1
    neg_num: resw 1
    elements:resw 1
    right:resw 1
    down:resw 1
    left:resw 1
    up:resw 1
    rows:resw 1
    columns:resw 1
    
section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 80h
        call scanf
        mov word[n],ax
        mov eax,4
        mov ebx,1
        mov ecx,m2
        mov edx,l2
        int 80h
        call scanf
        mov word[m],ax
        mov esi,matrix
        call matrix_input
        
        snake_movement:
            mov esi,matrix
            mov ax,word[n]
            mov bx,word[m]
            mov word[rows],ax
            mov word[columns],bx
            mul bx
            mov word[elements],ax
            ;
            mov word[i],0
            mov word[j],0
            mov edi,0
            first_loop:
                mov cx,word[columns]
                cmp cx,word[i]
                je end_first_loop
                mov word[j],0
                second_loop:
                    mov cx,word[rows]
                    cmp cx,word[j]
                    je end_second_loop
                    mov ax,word[esi+2*edi]
                    call printf
                    inc word[j]
                    movzx edx,word[columns]
                    add edi,edx
                    jmp second_loop
                end_second_loop:
                    inc word[i]
                    movzx edi,word[i]
                    jmp first_loop
            end_first_loop:


        end_looping:
            mov eax,4
            mov ebx,1
            mov ecx,newline
            mov edx,1
            int 80h

exit:
    mov eax,1
    mov ebx,0
    int 80h

print_matrix:
    mov edi,0
    mov word[i],0
    mov word[j],0
    print_i_loop:
        mov cx,word[n]
        cmp cx,word[i]
        je end_print_i_loop
        mov word[j],0
        print_j_loop:
            mov cx,word[m]
            cmp cx,word[j]
            je end_print_j_loop
            mov ax,word[esi+2*edi]
            call printf
            inc edi
            inc word[j]
            jmp print_j_loop
        end_print_j_loop:
            mov eax,4
            mov ebx,1
            mov ecx,newline
            mov edx,1
            int 80h
            inc word[i]
            jmp print_i_loop
    end_print_i_loop:
        ret


matrix_input:
    mov edi,0
    mov word[i],0
    mov word[j],0
    i_loop:
        mov cx,word[n]
        cmp cx,word[i]
        je end_i_loop
        mov word[j],0
        j_loop:
            mov cx,word[m]
            cmp cx,word[j]
            je end_j_loop
            call scanf
            mov word[esi+2*edi],ax
            inc edi
            inc word[j]
            jmp j_loop
        end_j_loop:
            inc word[i]
            jmp i_loop
    end_i_loop:
        ret

printf:
    mov word[num],ax
    cmp word[num],0
    mov byte[count],0
    je print_zero
    mov word[neg_num],ax
    neg word[neg_num]
    mov ax,word[num]
    cmp ax,word[neg_num]
    jg extract_digits
    print_neg_sign:
        neg word[num]
        mov eax,4
        mov ebx,1
        mov ecx,neg_sign
        mov edx,1
        int 80h
    
    extract_digits:
        cmp word[num],0
        je start_printing
        inc byte[count]
        mov ax,word[num]
        mov dx,0
        mov bx,10
        div bx
        mov word[num],ax
        push dx
        
        jmp extract_digits
    start_printing:
        cmp byte[count],0
        je end_printing
        pop bx
        mov byte[digit],bl
        add byte[digit],30h
        mov eax,4
        mov ebx,1
        mov ecx,digit
        mov edx,1
        int 80h
        dec byte[count]
        jmp start_printing
    print_zero:
        mov eax,4
        mov ebx,1
        mov ecx,zero
        mov edx,1
        int 80h
    end_printing:
        mov eax,4
        mov ebx,1
        mov ecx,space
        mov edx,1
        int 80h
        ret



scanf:
    mov word[num],0
    ; mov byte[count],0
    mov byte[negative],0
    scanf_loop:
        mov eax,3
        mov ebx,0
        mov ecx,digit
        mov edx,1
        int 80h
        cmp byte[digit],45
        je it_is_negative
        cmp byte[digit],10
        je end_scanf
        cmp byte[digit],32
        je end_scanf
        ;
        mov ax,word[num]
        mov bx,10
        mul bx
        sub byte[digit],30h
        movzx cx,byte[digit]
        add ax,cx
        mov word[num],ax
        ; inc byte[count]
        jmp scanf_loop
        it_is_negative:
            mov byte[negative],1
            jmp scanf_loop
    end_scanf:
        cmp byte[negative],1
        jne return_scanf
        convert_neg:
            neg word[num]
        return_scanf:
            mov ax,word[num]
            ret

