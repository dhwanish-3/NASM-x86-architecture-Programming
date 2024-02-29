section .bss
x:resb 1
count:resb 1

section .data
space: db ' '

section .text
global _start
_start:
mov eax,3
mov ebx,0
mov ecx,x
mov edx,1
int 80h

sub byte[x],30h
mov byte[count],0

dhwanyfor:
	add byte[count],0x30
	mov eax,4
	mov ebx,1
	mov ecx,count
	mov edx,1
	int 80h
	mov eax,4
	mov ebx,1
	mov ecx,space
	mov edx,1
	int 0x80
	sub byte[count],0x30
	add byte[count],1
	mov al,byte[count]
	cmp al,byte[x]
	jna dhwanyfor
	
mov eax,1
mov ebx,0
int 80h
