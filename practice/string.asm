section .data
    m1:db 'Enter your string'
    l1: equ $-m1
    yes:db 'Your string is a palindrome'
    yes_len:equ $-yes
    no:db 'Your string is not a palindrome'
    no_len:equ $-no
    newline:db 0xa
    space:db ' '

section .bss
    char: resb 1
    strlen: resw 1
    temp: resb 1
    string: resb 100

section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 80h
        call scan_string
        
        mov eax,4
        mov ebx,1
        mov ecx,string
        mov edx,strlen
        int 80h

    exit:
        mov eax,1
        mov ebx,0
        int 80h


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

