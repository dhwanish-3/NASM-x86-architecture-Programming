section .data
p1:db 'Enter 1st number : '
l1:equ $-p1
p2:db 'Enter 2nd number : '
l2:equ $-p2
yes:db 'First number is multiple of second!'
ylen:equ $-yes
no:db 'First number is not a multiple of second!'
nlen:equ $-no
newline:db 0Ah
space: db 20h

section .bss
dig1:resb 1
dig2:resb 1
dig3:resb 1
dig4:resb 1
num1:resb 1
num2:resb 1
ans1:resb 1
ans2:resb 1

section .text
global _start
_start:
mov eax,4
mov ebx,1
mov ecx,p1
mov edx,l1
int 80h

mov eax,3
mov ebx,0
mov ecx,dig1
mov edx,1
int 80h
mov eax,3
mov ebx,0
mov ecx,dig2
mov edx,2
int 80h

mov eax,4
mov ebx,1
mov ecx,p2
mov edx,l2
int 80h

mov eax,3
mov ebx,0
mov ecx,dig3
mov edx,1
int 80h
mov eax,3
mov ebx,0
mov ecx,dig4
mov edx,2
int 80h

sub byte[dig1],30h
sub byte[dig2],30h

mov al,byte[dig1]
mov bl,10
mul bl
add al,byte[dig2]
mov byte[num1],al


sub byte[dig3],30h
sub byte[dig4],30h
mov al,byte[dig3]
mov bl,10
mul bl
add al,byte[dig4]
mov byte[num2],al

movzx ax,byte[num1]
mov bl,byte[num2]
mov ah,0
div bl

mov byte[ans1],al
mov byte[ans2],ah

mov bl,byte[ans2]
cmp bl,0
jne fail

success:
mov eax,4
mov ebx,1
mov ecx,yes
mov edx,ylen
int 80h
jmp end

fail:
mov eax,4
mov ebx,1
mov ecx,no
mov edx,nlen
int 80h


end:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h

mov eax,1
mov ebx,0
int 80h
