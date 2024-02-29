section .text
global _start
_start:
mov eax,3
mov ebx,0
mov ecx,name
mov edx,8
int 80h

mov eax,4
mov ebx,1
mov ecx,hy
mov edx,len
int 80h

mov eax,4
mov ebx,1
mov ecx,name
mov edx,8
int 80h

mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h

mov eax,1
mov ebx,0
int 80h

section .bss
name: resw 1

section .data
hy: db 'Hello ,'
newline: db 0Ah
len: equ 7
