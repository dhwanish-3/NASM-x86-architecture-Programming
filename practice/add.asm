section .text
global _start
_start:
 mov eax, 3
 mov ebx, 0
 mov ecx, digit1
 mov edx, 1
 int 80h
 
 mov eax, 3
 mov ebx, 0
 mov ecx, digit2
 mov edx, 2
 int 80h
 
 mov eax, 3
 mov ebx, 0
 mov ecx, digit3
 mov edx, 1
 int 80h
 
 mov eax, 3
 mov ebx, 0
 mov ecx, digit4
 mov edx, 2
 int 80h
 
 sub byte[digit1],30h
 sub byte[digit2],30h
 mov ax,word[digit1]
 add ax,word[digit2]
 
mov al,byte[digit1]
mov bl,10
mul bl
movzx bx,byte[digit2]
add ax,bx
mov byte[number1],al
 
 sub byte[digit3],30h
 sub byte[digit4],30h
 mov ax,word[digit3]
 add ax,word[digit4]
 
mov al,byte[digit3]
mov bl,10
mul bl
movzx bx,byte[digit4]
add ax,bx
mov byte[number2],al


 mov bl,10
 mov ah,0
 div bl
 
 mov byte[ans1],al
 mov byte[ans2],ah
 add byte[ans1],30h
 add byte[ans2],30h
 
 mov eax, 4
 mov ebx, 1
 mov ecx, ans1
 mov edx, 1
 int 80h
 
 mov eax, 4
 mov ebx, 1
 mov ecx, ans2
 mov edx, 1
 int 80h
 
 mov eax,1
 mov ebx,0
 int 80h

section .bss
digit1: resb 1
digit2: resb 1
digit3: resb 1
digit4: resb 1
number1: resb 1
number2: resb 1
ans1: resb 1
ans2: resb 1
