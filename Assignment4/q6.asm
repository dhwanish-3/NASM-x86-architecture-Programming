section .data
    m1:db 'Enter your string of length n : '
    l1: equ $-m1
    m2:db 'Enter n : '
    l2:equ $-m2
    m3:db 'Enter n1 : '
    l3:equ $-m3
    m4:db 'Enter n2 : '
    l4:equ $-m4
    m5:db 'Your substring is : '
    l5:equ $-m5
    newline:db 0xa
    space:db ' '
    zero:db '0'

section .bss
    n:resw 1
    n1:resw 1
    n2:resw 1
    char: resb 1
    num:resw 1
    d1:resb 1
    string:resb 50
    i:resw 1
    substring:resb 30
    substr_len:resw 1
    print:resw 1
    temp:resb 1


section .text
    global _start
    _start:

        mov eax,4
        mov ebx,1
        mov ecx,m2
        mov edx,l2
        int 80h
        call scanf
        mov word[n],ax
        ;n1
        mov eax,4
        mov ebx,1
        mov ecx,m3
        mov edx,l3
        int 80h
        call scanf
        mov word[n1],ax
        ;n2
        mov eax,4
        mov ebx,1
        mov ecx,m4
        mov edx,l4
        int 80h
        call scanf
        mov word[n2],ax

        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 80h
        mov esi,string
        call scan_string

        ;substring
        mov cx,word[n1]
        mov word[i],cx
        dec word[i]
        mov esi,string
        mov edi,substring
        ; mov word[substr_len],0
        looping:
            movzx ebx,word[i]
            movzx ecx,word[n2]
            cmp ecx,ebx
            je end_looping
            mov al,byte[esi+ebx]
            mov byte[edi],al
            inc edi
            inc word[i]
            ; inc word[substr_len]
            jmp looping
        end_looping:
            mov eax,4
            mov ebx,1
            mov ecx,m5
            mov edx,l5
            int 80h

            ; mov word[substr_len],0
            mov byte[edi],0xa
            mov eax,4
            mov ebx,1
            mov ecx,substring
            mov edx,char
            int 80h

    exit:
        mov eax,1
        mov ebx,0
        int 80h


scan_string:
    mov word[i],0
    scanning:
        mov eax,3
        mov ebx,0
        mov ecx,char
        mov edx,1
        int 80h
        
        mov al,byte[char]
        mov byte[esi],al
        inc word[i]
        inc esi
        mov cx,word[n]
        cmp word[i],cx
        je end_scan_string
        jmp scanning

    end_scan_string:
        mov byte[esi],0xa
    ret

scanf:
	mov word[num],0
	read_digit:
		mov eax,3
		mov ebx,0
		mov ecx,d1
		mov edx,1
		int 80h
		cmp byte[d1],0xa
		je end_reading
		cmp byte[d1],20h
		je end_reading
		continue:
			sub byte[d1],30h
			mov ax,word[num]
			mov bx,10
			mul bx
			movzx bx,byte[d1]
			add ax,bx
			mov word[num],ax
			jmp read_digit
	end_reading:
		ending:
			mov ax,word[num]
		ret

