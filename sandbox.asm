section .bss
	BUFFLEN equ 1024
	Buff resb BUFFLEN
section .data
	Welcome db "Hello, Please enter your name",10
	WELCOMELENGTH equ  $-Welcome
	Addition db " is a very nice name!",10
	ADDITIONLENGTH equ $-Addition
section .text
	global _start

_start:
	nop

	mov eax,4
	mov ebx,1
	mov ecx,Welcome
	mov edx,WELCOMELENGTH
	int 80h

	mov eax,3
	mov ebx,0
	mov ecx,Buff
	mov edx,BUFFLEN
	int 80h

	mov ebp,eax
	xor ebx,ebx
	
Insert:
	mov ax, byte [Addition + ebx]
	mov byte [Buff + ebp + ebx], ax
	inc ebx
	cmp ebx,ADDITIONLENGTH
	jna Insert
	
	add ebp,ebx
	mov eax,4
	mov ebx,1
	mov ecx,Buff
	mov edx,ebp
	int 80h

	mov eax,1
	mov ebx,0
	int 80h

	
