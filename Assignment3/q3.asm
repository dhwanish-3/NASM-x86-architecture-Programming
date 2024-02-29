section .data
    newline: db 0xa
    zero:db '0'
    space:db ' '

section .bss
    n:resb 1
    num: resb 1
    nums: resw 20
    count: resb 1
    count_printed:resb 1
    temp: resb 1
    d1: resb 1
    print: resw 1

section .text
    global _start
    _start:
        call scanf
        mov byte[n],al
        mov byte[count],0
        read_nums:
            mov al,byte[n]
            cmp byte[count],al
            je end_read_nums
            call scanf
            movzx cx,al
            movzx eax,byte[count]
            mov ebx,nums
            mov word[ebx+2*eax],cx
            inc byte[count]
            jmp read_nums
    end_read_nums:
        mov byte[count_printed],0
    print_nums:
        movzx eax,byte[count_printed]
        cmp byte[n],al
        je end_print_nums
        mov ebx,nums
        mov cx,word[ebx+2*eax]
        mov ax,cx
        call printf        
        inc byte[count_printed]
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
	mov word[print],ax
	cmp word[print],0
	je print_zero
	mov bx,word[print]
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
		push dx
		mov word[print],ax
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
	mov byte[num],0
	read_digit:
		mov eax,3
		mov ebx,0
		mov ecx,d1
		mov edx,1
		int 80h
		cmp byte[d1],0xa
		je end_reading
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
		ending:
			mov al,byte[num]
		ret

