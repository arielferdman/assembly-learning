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
	mov ecx,ADDITIONLENGTH
	dec ecx	
Insert:
	mov al, byte [Addition + ebx]
	mov byte [Buff + ebp - 1 + ebx], al
	inc ebx
	cmp ebx,ecx
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

	
