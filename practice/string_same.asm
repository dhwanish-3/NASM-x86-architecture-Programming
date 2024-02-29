section .data
    m1: db 'enter first string : '
    l1:equ $-m1
    m2: db 'enter second string : '
    l2:equ $-m2
    m3: db 'both string are same',0xa
    l3:equ $-m3
    m4: db 'both strings are different',0xa
    l4:equ $-m4
    space: db ' '
    zero: db '0'
    newline: db 0xa

section .bss
    string1:resb 100
    string2:resb 100
    freq1:resb 100
    freq2:resb 100
    char : resb 1
    i:resb 1
    j:resb 1
    strlen1:resb 1
    strlen2:resb 1
    strlen:resb 1
    num:resb 1
    count:resb 1
    digit:resb 1

section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 80h
        mov esi,string1
        call scan_string
        mov byte[strlen1],al
        mov eax,4
        mov ebx,1
        mov ecx,m2
        mov edx,l2
        int 80h
        mov esi,string2
        call scan_string
        mov byte[strlen2],al

        mov esi,string1
        mov edx,freq1
        mov al,byte[strlen1]
        call get_freq

        mov esi,string2
        mov edx,freq2
        mov al,byte[strlen2]
        call get_freq

        check_same:
            mov esi,string1
            mov edx,freq1
            mov ecx,freq2
            mov byte[i],0
            mov edi,0
            check_loop:
                mov al,byte[strlen1]
                cmp al,byte[i]
                je end_check_loop
                mov bl,byte[esi+edi]
                inc edi
                movzx ebx,bl
                sub ebx,65
                mov al,byte[edx+ebx]
                cmp al,byte[ecx+ebx]
                jne not_same
                inc byte[i]
                jmp check_loop
            end_check_loop:
                same:
                    mov eax,4
                    mov ebx,1
                    mov ecx,m3
                    mov edx,l3
                    int 80h
                    jmp exit
        not_same:
            mov eax,4
            mov ebx,1
            mov ecx,m4
            mov edx,l4
            int 80h


        ; mov esi,freq1
        ; call print_array
        ; mov esi,freq2
        ; call print_array
        ; mov al,byte[strlen1]
        ; mov esi,string1
        ; call print_string

        ; mov al,byte[strlen2]
        ; mov esi,string2
        ; call print_string

exit:
    mov eax,1
    mov ebx,0
    int 80h

print_array:
    mov byte[i],0
    mov edi,0
    print_array_loop:
        cmp byte[i],10
        je end_print_array_loop
        mov al,byte[esi+edi]
        call printf
        inc edi
        inc byte[i]
        jmp print_array_loop
    end_print_array_loop:
        mov eax,4
        mov ebx,1
        mov ecx,newline
        mov edx,1
        int 80h
        ret

get_freq:
    mov byte[strlen],al
    dec byte[strlen]
    mov edi,0
    mov byte[i],0
    freq_loop:
        mov cl,byte[strlen]
        cmp cl,byte[i]
        je end_freq_loop
        mov bl,byte[esi+edi]
        inc edi
        movzx ecx,bl
        sub ecx,65
        inc byte[edx+ecx]
        inc byte[i]
        jmp freq_loop
    end_freq_loop:
        ret

print_string:
    mov byte[strlen],al
    mov edi,0
    mov byte[i],0
    print_loop:
        mov cl,byte[strlen]
        cmp cl,byte[i]
        je end_print_loop
        mov al,byte[esi+edi]
        mov byte[char],al
        mov eax,4
        mov ebx,1
        mov ecx,char
        mov edx,1
        int 80h
        inc edi
        inc byte[i]
        jmp print_loop
    end_print_loop:
        ret

scan_string:
    mov byte[strlen],0
    mov edi,0
    loop:
        mov eax,3
        mov ebx,0
        mov ecx,char
        mov edx,1
        int 80h
        cmp byte[char],10
        je end_loop
        mov al,byte[char]
        mov byte[esi+edi],al
        inc edi
        inc byte[strlen]
        jmp loop

    end_loop:
        mov byte[esi+edi],0xa
        inc byte[strlen]
        mov al,byte[strlen]
        ret

printf:
    mov byte[num],al
    cmp byte[num],0
    mov byte[count],0
    je print_zero
    
    extract_digits:
        cmp byte[num],0
        je start_printing
        inc byte[count]
        mov al,byte[num]
        mov dx,0
        mov bx,10
        div bx
        mov byte[num],al
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
