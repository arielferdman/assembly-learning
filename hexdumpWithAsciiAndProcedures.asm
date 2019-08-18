section .bss
	
	BUFFLEN	equ	10h
	Buff	resb	BUFFLEN

section .data
	
	Dumpline:	db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 "
	DUMPLEN		equ $-Dumpline
	Ascline:	db "|................|",10
	ASCLEN		equ $-Ascline
	FULLLEN		equ $-Dumpline
	HexDigits:	db "0123456789ABCDEF"

	DotXlat: 
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
			db 20h,21h,22h,23h,24h,25h,26h,27h,28h,29h,2Ah,2Bh,2Ch,2Dh,2Eh,2Fh
			db 30h,31h,32h,33h,34h,35h,36h,37h,38h,39h,3Ah,3Bh,3Ch,3Dh,3Eh,3Fh
			db 40h,41h,42h,43h,44h,45h,46h,47h,48h,49h,4Ah,4Bh,4Ch,4Dh,4Eh,4Fh
			db 50h,51h,52h,53h,54h,55h,56h,57h,58h,59h,5Ah,5Bh,5Ch,5Dh,5Eh,5Fh
			db 60h,61h,62h,63h,64h,65h,66h,67h,68h,69h,6Ah,6Bh,6Ch,6Dh,6Eh,6Fh
			db 70h,71h,72h,73h,74h,75h,76h,77h,78h,79h,7Ah,7Bh,7Ch,7Dh,7Eh,2Eh
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh
			db 2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh,2Eh

section .text


ClearLine:
	push rdx
	push rax
	mov edx,15
.poke:	mov eax,0
	call DumpChar
	sub edx,1
	jae .poke
	pop rax
	pop rdx
	ret

DumpChar:
	push rbx
	push rdi
	mov bl,byte [DotXlat+eax]
	mov byte [Ascline+edx+1],bl
	lea edi,[edx*2+edx]
	mov ebx,eax
	and eax,0000000Fh
	and ebx,000000F0h
	shr ebx,4
	mov al,byte [HexDigits+eax]
	mov bl,byte [HexDigits+ebx]
	mov byte [Dumpline+edi+2],al
	mov byte [Dumpline+edi+1],bl
	pop rdi
	pop rbx
	ret

PrintLine:
	push rax
	push rbx
	push rcx
	push rdx
	mov eax,4
	mov ebx,1
	mov ecx,Dumpline
	mov edx,FULLLEN
	int 80h
	pop rax
	pop rbx
	pop rcx
	pop rdx
	ret

LoadBuff:
	push rax
	push rbx
	push rdx
	mov eax,3
	mov ebx,0
	mov ecx,Buff
	mov edx,BUFFLEN
	int 80h
	mov ebp,eax
	xor ecx,ecx
	pop rdx
	pop rbx
	pop rax
	ret


GLOBAL _start

_start:
	nop
	xor esi,esi
	call LoadBuff
	cmp ebp,0
	jbe Exit

Scan:
	xor eax,eax
	mov al,byte [Buff+ecx]
	mov edx,esi
	and edx,0000000Fh
	call DumpChar
	inc esi
	inc ecx
	cmp ecx,ebp
	jb .modTest
	call LoadBuff
	cmp ebp,0
	jbe Done

.modTest:
	test esi,0000000Fh
	jnz Scan
	call PrintLine
	call ClearLine
	jmp Scan

Done:
	call PrintLine

Exit:
	mov eax,1
	mov ebx,0
	int 80h


























