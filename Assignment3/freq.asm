section .data
    m1:db 'Enter n : '
    l1:equ $-m1
    m2:db 'Enter n elements : '
    l2:equ $-m2
    m3:db 'Element with maximum occurance are :  '
    l3:equ $-m3
    m4:db 'Element with minimum occurance are :  '
    l4:equ $-m4
    newline: db 0xa
    zero:db '0'
    space:db ' '

section .bss
    n:resb 1
    num: resb 1
    nums: resw 100
    freq: resw 100
    count: resb 1
    count_printed:resb 1
    temp: resb 1
    d1: resb 1
    print: resw 1
    max: resw 1
    min: resw 1

section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 80h
        call scanf
        mov byte[n],al
        mov byte[count],0
        mov eax,4
        mov ebx,1
        mov ecx,m2
        mov edx,l2
        int 80h
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
    find_frequency:
        mov esi,nums
        mov edi,freq
        mov eax,0
        loop:
            movzx ecx,byte[n]
            cmp ecx,eax
            je end_loop
            mov ecx,0
            movzx ecx,word[esi+2*eax]
            inc word[edi+2*ecx]
            inc eax
            jmp loop
        end_loop:
            mov edi,freq
            mov ebx,0
            mov esi,nums
            mov word[max],0
            mov word[min],999
    find_max:
        movzx ecx,byte[n]
        cmp ecx,ebx
        je end_find_max
        movzx ecx,word[esi+2*ebx]
        mov dx,word[edi+2*ecx]
        max_check:
        cmp dx,word[max]
        jnb max_assign
        min_check:
        cmp dx,word[min]
        jna min_assign
        next_loop:
            inc ebx
            jmp find_max
        max_assign:
            mov word[max],dx
            jmp min_check
        min_assign:
            mov word[min],dx
            jmp next_loop
    end_find_max:
        mov eax,4
        mov ebx,1
        mov ecx,m3
        mov edx,l3
        int 80h
        ; mov ax,word[max]
        ; call printf

        ;;
        mov edi,freq
        mov esi,nums
        mov eax,0
        print_max:
            cmp eax,100
            je end_print_max
            ; movzx edx,word[esi+2*eax]
            mov cx,word[edi+2*eax]
            cmp cx,word[max]
            je printing
            next_print_max:
                inc eax
                jmp print_max
            printing:
                push ax
                ; mov ax,dx
                call printf
                pop ax
                movzx eax,ax
                jmp next_print_max
        end_print_max:
            mov eax,4
            mov ebx,1
            mov ecx,newline
            mov edx,1
            int 80h
        mov eax,4
        mov ebx,1
        mov ecx,m4
        mov edx,l4
        int 80h
        ; mov ax,word[min]
        ; call printf
        mov edi,freq
        mov esi,nums
        mov eax,0
        print_min:
            cmp eax,100
            je end_print_min
            ; movzx edx,word[esi+2*eax]
            mov cx,word[edi+2*eax]
            cmp cx,word[min]
            je printing2
            next_print_min:
                inc eax
                jmp print_min
            printing2:
                push ax
                ; mov ax,dx
                call printf
                pop ax
                movzx eax,ax
                jmp next_print_min
        end_print_min:
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
		cmp byte[d1],20h
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

