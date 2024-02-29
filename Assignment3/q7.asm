section .data
    m1:db 'Enter your string :   '
    l1: equ $-m1
    yes:db 'Your string is a palindrome',0xa
    yes_len:equ $-yes
    no:db 'Your string is not a palindrome',0xa
    no_len:equ $-no
    newline:db 0xa
    space:db ' '

section .bss
    char: resb 1
    strlen: resw 1
    strlen_by_2: resb 1
    string: resb 100
    palindrome: resb 1

section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 80h
        call scan_string
        call check_palindrome
        cmp byte[palindrome],0
        je print_not_palindrome
    print_palindrome:
        mov eax,4
        mov ebx,1
        mov ecx,yes
        mov edx, yes_len
        int 80h
        jmp exit
    print_not_palindrome:
        mov eax,4
        mov ebx,1
        mov ecx,no
        mov edx,no_len
        int 80h

    exit:
        mov eax,1
        mov ebx,0
        int 80h


check_palindrome:
    mov ax,word[strlen]
    mov bl,2
    div bl
    mov byte[strlen_by_2],al 
    mov esi,0 ;esi will have i pointer from the start set as 0
    movzx edx,word[strlen] 
    dec edx;edx is the pointer from end index, now contains strlen
    while_i_lessthan_strlenby2:
        movzx ax,byte[strlen_by_2]
        cmp si,ax
        je end_it_is_palindrome
        mov eax,string
        mov cl,byte[eax+edx]
        cmp byte[eax+esi],cl
        jne not_palindrome
        inc esi
        dec edx
        jmp while_i_lessthan_strlenby2
    not_palindrome:
        mov byte[palindrome],0
        mov al,byte[palindrome]
        jmp return
    end_it_is_palindrome:
        mov byte[palindrome],1
        mov al,byte[palindrome]
    return:
        ret


scan_string:
    mov word[strlen],0
    mov esi,string
    scanning:
        mov eax,3
        mov ebx,0
        mov ecx,char
        mov edx,1
        int 80h
        cmp byte[char],0xa
        je end_scan_string
        mov al,byte[char]
        mov byte[esi],al
        
        inc word[strlen]
        inc esi
        jmp scanning

    end_scan_string:
        mov byte[esi],0xa
    ret

