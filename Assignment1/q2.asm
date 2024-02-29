section .bss
x1:resb 1
x2:resb 1
number:resb 1
count:resb 1
sum:resw 1
temp:resb 1

section .data
space: db ' '
newline:db 0xa

section .text
global _start
_start:
mov eax,3
mov ebx,0
mov ecx,x1
mov edx,1
int 80h
mov eax,3
mov ebx,0
mov ecx,x2
mov edx,2
int 80h

sub byte[x1],30h
sub byte[x2],30h

mov al,byte[x1]
mov bl,10
mul bl ; bl=bl*al ; bl=10*al
add al,byte[x2]
mov byte[number],al

mov byte[count],0
mov word[sum],0

findEvenSum:
	mov ah,byte[count]
	inc ah
	cmp ah,byte[number]
	jnb print_num
	add byte[count],2
	movzx bx,byte[count]
	add bx,word[sum]
	mov word[sum],bx
	mov al,byte[count]
	cmp al,byte[number]
	jb findEvenSum
	
print_num:
mov byte[count],0

extract_num:
cmp word[sum],0
je printSum
inc byte[count]
mov dx,0
mov ax,word[sum]

mov bx,10
div bx
push dx
mov word[sum],ax
jmp extract_num

printSum:
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
	jmp printSum

end_print:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h	
	
mov eax,1
mov ebx,0
int 80h
