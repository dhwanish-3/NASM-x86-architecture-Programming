section .data
m1:db 'Enter n : '
l1:equ $-m1
m2:db 'Enter n numbers : ',
l2:equ $-m2
m3:db 'Maximum is : '
l3:equ $-m3
newline:db 0xa

section .bss
dig:resb 1
n:resb 1
max:resb 1
count:resb 1
temp:resb 1
nums:resb 1

section .text
global _start
_start:
mov eax,4
mov ebx,1
mov ecx,m1
mov edx,l1
int 0x80

call take_input
mov [n],al

mov byte[max],0
mov byte[count],0

read_n_numbers:
mov eax,4
mov ebx,1
mov ecx,m2
mov edx,l2
int 0x80

looping:
call take_input
mov [nums],al
mov bl,[max]
cmp bl,[nums]
ja decrease

max_assign:
mov bl,[temp]
mov [max],bl

decrease:
dec byte[n]
cmp byte[n],0
ja looping

print_max:
mov eax,4
mov ebx,1
mov ecx,m3
mov edx,l3
int 0x80
mov byte[count],0

extract_num:
cmp byte[max],0
je printMax
inc byte[count]
mov dx,0
mov al,byte[max]
mov bx,10
div bx
push dx
mov byte[max],al
jmp extract_num


printMax:
	cmp byte[count],0
	je end_print
	dec byte[count]
	pop dx
	mov byte[temp],dl
	add byte[temp],30h
	mov eax,4
	mov ebx,1
	mov ecx,temp
	mov edx,1
	int 80h
	jmp printMax

end_print:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h

mov eax,1
mov ebx,0
int 80h

;;subprogram
take_input:
mov byte[temp],0

read_n:
mov eax,3
mov ebx,0
mov ecx,dig
mov edx,1
int 0x80
cmp byte[dig],0xa
je end_read
mov al,byte[temp]
mov bl,10
mul bl
sub byte[dig],0x30
add al,byte[dig]
mov [temp],al
jmp read_n

end_read:
mov al,[temp]
ret
