section .data
    m1:db 'Enter number of rows in your matrices : '
    l1:equ $-m1
    m2:db 'Enter number of columns in your matrices : '
    l2:equ $-m2
    m3:db 'Enter your first matrix ',0xa
    l3:equ $-m3
    m4:db 'Enter your second matrix ',0xa
    l4:equ $-m4
    newline: db 0xa
    tab:db 9
    zero:db '0'
    space:db ' '

section .bss
    m:resw 1
    n:resw 1
    num: resw 1
    i:resw 1
    j:resw 1
    k:resw 1
    matrix: resw 200
    matrix1: resw 200
    matrix2: resw 200
    sum_matrix:resw 200
    count: resb 1
    count_printed:resw 1
    temp: resw 1
    d1: resb 1
    print: resw 1

section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 80h
        call scanf
        mov word[m],ax
        mov eax,4
        mov ebx,1
        mov ecx,m2
        mov edx,l2
        int 80h
        call scanf
        mov word[n],ax
        mov eax,4
        mov ebx,1
        mov ecx,m3
        mov edx,l3
        int 80h
        mov esi,matrix1
        call matrix_input
        ; mov eax,matrix1
        ; mov [eax],ebx
        ; mov ebx,matrix1
        ; call print_matrix
        mov eax,4
        mov ebx,1
        mov ecx,m4
        mov edx,l4
        int 80h
        mov esi,matrix2
        call matrix_input
        ; calculate_sumof_matrices:
        ;     mov word[i],0
        ;     mov word[j],0
        ;     mov word[k],0
        ;     i_loop:
        ;         mov ax,word[m]
        ;         cmp ax,word[i]
        ;         je end_i_loop
        ;         j_loop:
        ;             mov ax,word[n]
        ;             cmp ax,word[j]
        ;             je end_j_loop

        mov ebx,[matrix1]
        call print_matrix
        mov ebx,[matrix2]
        call print_matrix
       
    exit:
        mov eax,1
        mov ebx,0
        int 80h


print_matrix:
    mov word[i],0
    mov word[j],0
    mov word[k],0
    mov [matrix],ebx
    print_matrix_i_loop:
        mov ax,word[i]
        cmp word[m],ax
        je end_print_matrix_i_loop
        mov word[j],0
        print_matrix_j_loop:
            mov ax,word[j]
            cmp word[n],ax
            je end_print_matrix_j_loop
            mov ebx,matrix
            movzx eax,word[k]
            mov ax,word[ebx+2*eax]
            call printf        
            inc word[k]
            inc word[j]
            jmp print_matrix_j_loop
        end_print_matrix_j_loop:
            mov eax,4
            mov ebx,1
            mov ecx,newline
            mov edx,1
            int 80h
            inc word[i]
            jmp print_matrix_i_loop
    end_print_matrix_i_loop:
        mov eax,4
        mov ebx,1
        mov ecx,newline
        mov edx,1
        int 80h
        ret

matrix_input:
    mov word[i],0
    mov word[j],0
    mov word[k],0
    while_i_lessthan_m:
        mov ax,word[m]
        cmp word[i],ax
        je end_while_i_lessthan_m
        mov word[j],0
        while_j_lessthan_n:
            mov ax,word[n]
            cmp word[j],ax
            je end_while_j_lessthan_n
            call scanf
            mov cx,ax
            movzx eax,word[k]
            ; mov ebx,matrix
            mov word[esi+2*eax],cx
            inc word[k]
            inc word[j]
            jmp while_j_lessthan_n
        end_while_j_lessthan_n:
            inc word[i]
            jmp while_i_lessthan_m
    end_while_i_lessthan_m:
        ret

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
	mov word[num],0
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

