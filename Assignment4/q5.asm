section .data
    m1: db 'Enter n : '
    l1: equ $-m1
    m3: db 'Enter first array : '
    l3: equ $-m3
    m4: db 'Sorted array : '
    l4: equ $-m4
    newline: db 0xa
    neg_sign: db '-'
    zero: db '0'
    space: db ' '

section .bss
    m:resw 1
    n:resw 1
    size:resb 1
    num: resw 1
    array: resw 20
    sort:resw 40
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
        ;enter first array
        mov eax,4
        mov ebx,1
        mov ecx,m3
        mov edx,l3
        int 80h
        mov al,byte[n]
        mov byte[size],al
        mov edi,0
        mov esi,array
        call input_array
        mov eax,4
        mov ebx,1
        mov ecx,m4
        mov edx,l4
        int 80h
        insertion_sort:
            mov ebx,array
            mov eax,1
            for_loop:
                cmp al,byte[size]
                je end_for_loop
                mov cx,word[ebx+2*eax]
                mov word[num],cx
                mov esi,eax
                dec esi
                while_loop:
                    cmp ebx,0
                    jl end_while_loop
                    mov cx,word[ebx+2*esi]
                    cmp cx,word[num]
                    jng end_while_loop
                    mov dx,word[ebx+2*esi]
                    mov word[ebx+2*esi+2],dx
                    dec esi
                    jmp while_loop
                end_while_loop:
                    inc esi
                    mov cx,word[num]
                    mov word[ebx+2*esi],cx
                
                next_loop:
                inc eax
                jmp for_loop
            end_for_loop:
                mov edi,0
                mov esi,array
                call print_array


        mov eax,4
		mov ebx,1
		mov ecx,newline
		mov edx,1
		int 80h

    exit:
        mov eax,1
        mov ebx,0
        int 80h

input_array:
    mov byte[count],0
    for_i_lessthan_n:
        mov cl,byte[count]
        cmp cl,byte[size]
        je end_for_i_lessthan_n
        call scanf
        mov word[esi+2*edi],ax
        inc edi
        inc byte[count]
        jmp for_i_lessthan_n
    end_for_i_lessthan_n:
        ret

print_array:
    mov byte[count_printed],0
    for_j_lessthan_n:
        mov cl,byte[count_printed]
        cmp cl,byte[size]
        je end_for_j_lessthan_n
        mov ax,word[esi+2*edi]
        call printf
        inc edi
        inc byte[count_printed]
        jmp for_j_lessthan_n
    end_for_j_lessthan_n:
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

