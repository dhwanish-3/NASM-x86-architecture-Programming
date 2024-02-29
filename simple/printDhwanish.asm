section .text
global _start
_start:
mov eax,4 ;this is a comment
mov ebx,1
mov ecx,name
mov edx,len
int 80h

mov eax,1 ;exit call
mov ebx,0
int 80h

section .data
name:db 'Hello Dhwanish',0Ah
len:equ 12
