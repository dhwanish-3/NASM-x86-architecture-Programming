section .data
    m1:db 'Enter your sentence : '
    l1: equ $-m1
    m2:db 'Enter your word : '
    l2:equ $-m2
    m3:db 'Number of occurances of your word : '
    l3:equ $-m3
    m4:db 'Your word is not present in your sentence',0xa
    l4:equ $-m4
    newline:db 0xa
    space:db ' '
    zero:db '0'

section .bss
    char: resb 1
    i:resw 1
    j:resw 1
    count:resw 1
    strlen: resw 1
    sentence: resb 100
    sentence_len:resw 1
    words: resb 20
    word_len:resw 1
    print:resw 1
    temp:resb 1


section .text
    global _start
    _start:
        mov eax,4
        mov ebx,1
        mov ecx,m1
        mov edx,l1
        int 80h
        mov esi,sentence
        call scan_string
        mov word[sentence_len],ax

        mov eax,4
        mov ebx,1
        mov ecx,m2
        mov edx,l2
        int 80h
        mov esi,words
        call scan_string
        mov word[word_len],ax

        ;finding the word in the sentence
        mov esi,sentence
        mov edi,words
        mov word[i],0
        mov word[count],0
        sentence_loop:
            mov cx,word[i]
            cmp cx,word[sentence_len]
            je end_sentence_loop
            mov al,byte[esi]
            cmp al,byte[edi]
            jne next_loop
            mov word[j],1
            continue_checking:
                mov cx,word[j]
                cmp cx,word[word_len]
                je increase_count
                inc esi
                inc edi
                mov ah,byte[esi]
                cmp ah,byte[edi]
                jne next_loop
                inc word[j]
                inc word[i]
                jmp continue_checking

            increase_count:
                inc word[count]
            next_loop:
                inc esi
                mov edi,words
                inc word[i]
                jmp sentence_loop
        end_sentence_loop:
            cmp word[count],0
            je print_none
        print_count:
            mov eax,4
            mov ebx,1
            mov ecx,m3
            mov edx,l3
            int 80h
            mov ax,word[count]
            call printf
            jmp exit
    print_none:
        mov eax,4
        mov ebx,1
        mov ecx,m4
        mov edx,l4
        int 80h

    exit:
        mov eax,1
        mov ebx,0
        int 80h


scan_string:
    mov word[strlen],0
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
        mov ax,word[strlen]
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
		mov ecx,newline
		mov edx,1
		int 80h		
		ret

