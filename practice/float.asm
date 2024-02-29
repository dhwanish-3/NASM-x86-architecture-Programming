section .data
	newline: db 0xa
	zero: db '0'
	neg: db '-'
	dot:db '.'

section .bss
	num:resw 1
	n:resw 1
	temp:resb 1
	d1: resb 1
	d2:resb 1
	print:resw 1
	neg_num:resw 1
	count:resb 1
	count_num:resb 1
	negative:resb 1
	sum:resw 1
	mean:resw 1
	rem:resb 1

section .text
global _start
_start:
	call scanf
	mov word[n],ax
	mov byte[count_num],al
	
	mov word[sum],0
	read_nums:
		call scanf
		add word[sum],ax
		;mov ax,word[sum]
		;call printf
		dec byte[count_num]
		cmp byte[count_num],0
		ja read_nums
	;mov ax,word[sum]
	;call printf
	find_mean:
		mov ax,word[sum]
		mov dx,0
		mov bx,word[n]
		div bx
		mov word[mean],ax
		mov si,dx
		call printf
		cmp si,0
		je exit
		print_dot:
			mov eax,4
			mov ebx,1
			mov ecx,dot
			mov edx,1
			int 80h
		mov dx,si
		mov byte[rem],dl ;rem stores the reminder
		mov al,byte[rem]
		mov bl,100
		mul bl
		;mov word[mean],ax
		mov dx,0
		mov bx,word[n]
		div bx
		call printf
	exit:
		mov eax,4
		mov ebx,1
		mov ecx,newline
		mov edx,1
		int 80h

	
		mov eax,1
		mov ebx,0
		int 80h


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
		mov ecx,neg
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
		;mov eax,4
		;mov ebx,1
		;mov ecx,newline
		;mov edx,1
		;int 80h		
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
		cmp byte[d1],45
		jne continue
		mov byte[negative],1
		jmp read_digit
		continue:
			sub byte[d1],30h
			mov ax,word[num]
			mov bl,10
			mul bl
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
			
