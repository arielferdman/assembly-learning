section .bss
	BUFFLEN equ 16
	Buff resb BUFFLEN
section .data
	HexStr db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00",10
	HEXLEN equ $-HexStr
	Digits db "0123456789ABCDEF"
section .text
	global _start

_start:
	nop

Read:
	mov eax,3
	mov ebx,0
	mov ecx,Buff
	mov edx,BUFFLEN
	int 80h

	cmp eax,0
	je  Exit	
	
	mov ebp,eax	
	xor ecx,ecx
Scan:
	mov edx,ecx
	shl edx,1
	add edx,ecx	

	mov al, byte [Buff + ecx]
	mov ebx,eax
	and al,0Fh
	shr bl,4
	mov al, byte [Digits + eax]
	mov bl, byte [Digits + ebx]
	mov byte [HexStr + edx + 2],al
  	mov byte [HexStr + edx + 1],bl
	inc ecx
	cmp ecx,ebp
	jb  Scan

	mov eax,4
	mov ebx,1
	mov ecx,HexStr
	mov edx, HEXLEN
	int 80h
	jmp Read

Exit:
	mov eax,1
	mov ebx,0
	int 80h	



