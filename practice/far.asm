section .bss 
temp:resw 1
count:resw 1
num:resw 1
arr: resw 50
arr1:resw 100
n:resw 1
high: resw 1
low:resw 1
min: resw 1
max:resw 1
n1:resw 1
section .text
m1: db 'highest: ',0ah
l1:equ $-m1
m2: db 'lowest: ',0ah
l2:equ $-m2
m3:db 'Enter n: ',0ah
l3:equ $-m3
m4:db 'Enter array: ',0ah
l4:equ $-m4
newline:db 0ah
zero:db '0'

section .text
global _start
_start:
mov eax,4
mov ebx,1
mov ecx,m3
mov edx,l3
int 80h

call take_input
mov word[n],cx
mov eax,4
mov ebx,1
mov ecx,m4
mov edx,l4
int 80h
mov word[count],0
for:
mov cx,word[n]
cmp word[count],cx
je end_for
call take_input
mov ebx,arr
movzx eax,word[count]
mov word[ebx+2*eax],cx
inc word[count]
jmp for

end_for:
mov word[count],0
mov word[high],0
mov word[low],0
mov word[n1],100

while:
mov cx,word[n]
cmp word[count],cx
je end_while
mov ebx,arr
movzx eax,word[count]
movzx edi,word[ebx+2*eax]
mov esi,arr1
inc word[esi+2*edi]
inc word[count]
jmp while

end_while:

mov word[count],0
mov word[max],0
mov word[min],100

while1:
mov cx,word[n1]
cmp word[count],cx
je end_while1
mov esi,arr1
movzx edi,word[count]
mov cx,word[esi+2*edi]
cmp word[min],cx
ja min_assign
minret:
cmp word[max],cx
jb max_assign
maxret:
inc word[count]
jmp while1

max_assign:
mov word[max],cx
mov ax,word[count]
mov word[high],ax
jmp maxret

min_assign:
mov word[min],cx
mov ax,word[count]
mov word[low],ax
jmp minret

end_while1:

mov eax,4
mov ebx,1
mov ecx,m1
mov edx,l1
int 80h

mov ax,word[high]
mov word[num],ax
call print_num
mov eax,4
mov ebx,1
mov ecx,m2
mov edx,l2
int 80h
mov ax,word[low]
mov word[num],ax
call print_num

mov eax,1
mov ebx,0
int 80h

print_num:

mov word[count],0
cmp word[num],0
je print_zero
extract_num:
cmp word[num],0
je print
inc word[count]
mov ax,word[num]
mov bx,10
mov dx,0
div bx
push dx
mov word[num],ax
jmp extract_num

print:
cmp word[count],0
je end_print
pop dx
mov word[temp],dx
add word[temp],30h
dec word[count]
mov eax,4
mov ebx,1
mov ecx,temp
mov edx,1
int 80h
jmp print

print_zero:
mov eax,4
mov ebx,1
mov ecx,zero
mov edx,1
int 80h

end_print:
mov eax,4
mov ebx,1
mov ecx,newline
mov edx,1
int 80h
ret

take_input:
mov word[num],0

read:
mov eax,3
mov ebx,0
mov ecx,temp
mov edx,1
int 80h

cmp word[temp],0xa
je end_read

mov ax,word[num]
mov bx,10
mul bx
sub word[temp],30h
add ax,word[temp]
mov word[num],ax
jmp read

end_read:
mov cx,word[num]
ret
