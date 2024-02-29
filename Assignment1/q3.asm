section .data
newline: db 0xa

section .bss
dig1:resb 1
dig2:resb 1
dig3:resb 1
dig4:resb 1
num1:resb 1
num2:resb 1
temp:resb 1
num:resb 1
count:resb 1

section .text
global _start
_start:
mov eax,3
mov ebx,0
mov ecx,dig1
mov edx,1
int 0x80
mov eax,3
mov ebx,0
mov ecx,dig2
mov edx,2
int 0x80

mov eax,3
mov ebx,0
mov ecx,dig3
mov edx,1
int 0x80
mov eax,3
mov ebx,0
mov ecx,dig4
mov edx,2
int 0x80

sub byte[dig1],0x30
sub byte[dig2],0x30
mov al,byte[dig1]
mov bl,10
mul bl
add al,byte[dig2]
mov byte[num1],al
;mov cl,byte[num1]

sub byte[dig3],0x30
sub byte[dig4],0x30
mov al,byte[dig3]
mov bl,10
mul bl
add al,byte[dig4]
mov byte[num2],al
;mov ch,byte[num2]

mov al,byte[num1]
mov bl,byte[num2]

loop1:
mov ah,0
div bl
cmp ah,0
je end_loop
mov al,bl
mov bl,ah
jmp loop1

end_loop:
mov byte[num],bl

print_num:
mov byte[count],0


extract_num:
cmp byte[num],0
je print_gcd
inc byte[count]
mov dx,0
mov al,byte[num]
mov bx,10
div bx
push dx
mov byte[num],al
jmp extract_num

print_gcd:
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
	jmp print_gcd

end_print:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h	

mov eax,1
mov ebx,0
int 80h
