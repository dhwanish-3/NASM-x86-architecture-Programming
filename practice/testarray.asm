section .data
    newline: db '0xa'
    zero:db '0'
    nega_sign:db '-'
    dot:db '.'
    space:db ' '

section .bss
    num: resb 1
    nums: resw 20
    count: resb 1
    temp: resb 1
    d1: resb 1
    negative:resb 1
    neg_num: resb 1
    print: resw 1

section .text
    global _start
    _start:
        call scanf
        mov byte[num],al
        mov byte[count],0
        mov rbx,nums
        read_nums:
            push rbx
            call scanf
            pop rbx
            mov byte[rbx],al
            add rbx,1
            mov al,byte[num]
            cmp byte[count],al
            je end_read_nums
            inc byte[count]
            jmp read_nums
    end_read_nums:
        mov byte[count],0
        mov rbx,nums
    print_nums:
    	mov al,byte[rbx]
        call printf
        mov eax,4
        mov ebx,1
        mov ecx,space
        mov edx,1
        int 80h
        inc bx
        mov al,byte[num]
        cmp byte[count],al
        je end_print_nums
        inc byte[count]
        jmp print_nums
    end_print_nums:
        mov eax,4
        mov ebx,1
        mov ecx,newline
        mov edx,1
        int 80h
    exit:
        mov eax,1
        mov ebx,0
        int 80h
    printf:
	mov byte[print],al
	cmp byte[print],0
	je print_zero
	mov byte[neg_num],al
	neg byte[neg_num]
	mov bl,byte[print]
	cmp bl,byte[neg_num]
	jg cont
	print_neg:
		;not byte[print]
		;add byte[print],1b
		mov eax,4
		mov ebx,1
		mov ecx,nega_sign
		mov edx,1
		int 80h
	cont:
	mov byte[count],0
	extract_digits:
		cmp byte[print],0
		je start_printing
		inc byte[count]
		mov al,byte[print]
		mov ah,0
		mov bl,10
		div bl
		mov byte[print],ah
		mov ah,0
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
		mov ecx,newline
		mov edx,1
		int 80h		
		ret

	scanf:
	mov byte[num],0
	mov byte[negative],0
	read_digit:
		mov eax,3
		mov ebx,0
		mov ecx,d1
		mov edx,1
		int 80h
		cmp byte[d1],0xa
		je end_reading
		cmp byte[d1],45
		jne continue
		mov byte[negative],1
		continue:
			sub byte[d1],30h
			mov al,byte[num]
			mov bl,10
			mul bl
			mov bl,byte[d1]
			add al,bl
			mov byte[num],al
			jmp read_digit
	end_reading:
		cmp byte[negative],1
		jne ending
		neg byte[num]
		;mov al,byte[num]
		;call printf
		;neg byte[num]
		;mov al,byte[num]
		;call printf
		ending:
			mov al,byte[num]
		ret

