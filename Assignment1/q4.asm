section .data
yes:db 'prime number',0xa
l1:equ $-yes
no:db 'not a prime',0xa
l2:equ $-no

section .bss
dig1:resb 1
dig2:resb 1
num1:resb 1
temp:resb 1
num:resb 1
numby2:resb 1

section .text
global _start
_start:
mov byte[dig1],0
read_digit:
mov eax,3
mov ebx,0
mov ecx,dig2
mov edx,1
int 0x80
cmp byte[dig2],0xa
je end_read
mov al,byte[dig1]
mov bl,10
mul bl
sub byte[dig2],0x30
add al,byte[dig2]
mov byte[dig1],al ;number in dig1
jmp read_digit

mov al,byte[dig1]
mov bl,2
mov ah,0
div bl
mov byte[dig1],al

end_read:
mov bl,2

loop1:
mov al,byte[dig1]
cmp bl,byte[dig1]
jnb print_yes
mov ah,0
div bl
cmp ah,0
je print_no
inc bl
jmp loop1

print_yes:
mov eax,4
mov ebx,1
mov ecx,yes
mov edx,l1
int 0x80
jmp exit

print_no:
mov eax,4
mov ebx,1
mov ecx,no
mov edx,l2
int 0x80

exit:
mov eax,1
mov ebx,0
int 80h
