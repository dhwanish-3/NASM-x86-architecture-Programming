section .data
    m1: db 'Enter n : '
    l1: equ $-m1
    m2: db 'Enter m : '
    l2: equ $-m2
    m3: db 'Enter matrix : '
    l3: equ $-m3
    m4: db 'Transpose matrix : '
    l4: equ $-m4
    newline: db 0xa
    neg_sign: db '-'
    zero: db '0'
    space: db ' '

section .bss
    m:resw 1
    n:resw 1
    i:resw 1
    j:resw 1
    size:resb 1
    num: resw 1
    matrix: resw 20
    transpose:resw 20
    count: resb 1
    count_printed:resw 1
    temp: resw 1
    d1: resb 1
    print: resw 1
    neg_num:resw 1
    negative: resb 1

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
        ;enter matrix
        mov eax,4
        mov ebx,1
        mov ecx,m3
        mov edx,l3
        int 80h
        mov esi,matrix
        call matrix_input

        mov eax,4
        mov ebx,1
        mov ecx,m4
        mov edx,l4
        int 80h

        ;transpose 
        find_transpose:
            mov esi,transpose
            mov eax,matrix
            mov ebx,0
            mov edi,0
            mov word[i],0
            mov word[j],0
            i_loop1:
                mov cx,word[m]
                cmp cx,word[i]
                je end_i_loop1
                mov word[j],0
                j_loop1:
                    mov cx,word[n]
                    cmp cx,word[j]
                    je end_j_loop1
                    mov cx,word[eax+2*ebx]
                    mov word[esi+2*edi],cx
                    movzx ecx,word[m]
                    add ebx,ecx
                    inc word[j]
                    inc edi
                    jmp j_loop1
                end_j_loop1:
                    inc word[i]
                    movzx ebx,word[i]
                    jmp i_loop1
            end_i_loop1:
        mov cx,word[n]
        mov dx,word[m]
        mov word[n],dx
        mov word[m],cx
        mov esi,transpose
        call print_matrix

        mov eax,4
		mov ebx,1
		mov ecx,newline
		mov edx,1
		int 80h

    exit:
        mov eax,1
        mov ebx,0
        int 80h

matrix_input:
    mov word[i],0
    mov word[j],0
    mov edi,0
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

print_matrix:
    mov word[i],0
    mov word[j],0
    mov edi,0
    i_loop_print:
        mov cx,word[n]
        cmp cx,word[i]
        je end_i_loop_print
        mov word[j],0
        j_loop_print:
            mov cx,word[m]
            cmp cx,word[j]
            je end_j_loop_print
            mov ax,word[esi+2*edi]
            call printf
            inc edi
            inc word[j]
            jmp j_loop_print
        end_j_loop_print:
            mov eax,4
            mov ebx,1
            mov ecx,newline
            mov edx,1
            int 80h
            inc word[i]
            jmp i_loop_print
    end_i_loop_print:
        ret

printf:
	mov word[print],ax
	cmp word[print],0
	je print_zero
	mov word[neg_num],ax
	neg word[neg_num]
	mov bx,word[print]
	cmp bx,word[neg_num]
	jg cont
	print_neg:
		not word[print]
		add word[print],1b
		mov eax,4
		mov ebx,1
		mov ecx,neg_sign
		mov edx,1
		int 80h
	cont:
	mov byte[count],0
	extract_digits:
		cmp word[print],0
		je start_printing
		inc byte[count]
		mov ax,word[print]
		mov dx,0
		mov bx,10
		div bx
		mov word[print],ax
		mov ax,dx
		push ax
		jmp extract_digits
		
	start_printing:
		cmp byte[count],0
		je end_printing
		dec byte[count]
		pop bx
		mov byte[temp],bl
		add byte[temp],30h
		mov eax,4
		mov ebx,1
		mov ecx,temp
		mov edx,1
		int 80h
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
	mov byte[negative],0
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
		cmp byte[d1],45
		jne continue
		mov byte[negative],1
		jmp read_digit
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
		cmp byte[negative],1
		jne ending
		neg word[num]
		
		ending:
			mov ax,word[num]
		ret

