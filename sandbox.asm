section .bss
	
	BUFFLEN equ 10h
	DumpLineBytes equ 10h
	Buff resb BUFFLEN

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

ReadLine:
	push rax
	push rbx
	push rcx
	push rdx
	
	mov rax,3
	mov rbx,0
	mov rcx,Buff
	mov rdx,BUFFLEN
	int 80h
	mov rbp,rax
	mov r12,rax

	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret

DumpBuff:
	push rax
	
	xor rax,rax
	xor rcx,rcx
.scanChar:
	mov al, byte [Buff + ecx]
	mov r8,rax
	call DumpChar
	inc rcx
	inc rsi
	mov r8,rsi
	call TestIfPrint
	cmp r12,1h
	je .print
.resume:	
	mov r8,rcx
	call TestIfEndOfBuff
	cmp r12,1h
	je .return
	jmp .scanChar
.print:
	call PrintLine
	call ClearOutputLines
	jmp .resume
.return:
	pop rax
	ret

DumpChar:
	push rdi
	push rax
		
	call GetHighNibble
	mov rdi,rcx
	lea edi,[edi*2 + edi]
	mov rax,r12
	mov byte [Dumpline + edi + 1],al
	call GetLowNibble
	mov rax,r12
	mov byte [Dumpline + edi + 2],al
	mov rax,r8
	mov al,byte [DotXlat + eax]
	mov byte [Ascline + ecx + 1],al
	
	pop rax
	pop rdi
	ret
	
ClearOutputLines:
	push rax
	push rbx
	push rcx
	push rdi
	
	xor rcx,rcx
	mov rax,2Eh
	mov rbx,30h
	mov rdi,rcx
.clearChar:
	lea edi, [edi*2 + edi]	
	mov byte [Ascline + ecx + 1],al
	mov byte [Dumpline + edi + 1],bl
	mov byte [Dumpline + edi + 2],bl
	inc rcx
	mov rdi,rcx
	cmp rcx,10h
	jb .clearChar
	
	pop rdi
	pop rcx
	pop rbx
	pop rax
	ret


TestIfPrint:
	push rax

	mov rax,r8
	and eax,0000000Fh
	cmp eax,0
	je .shouldPrint
	mov r12,0h
	jmp .return
.shouldPrint:
	mov r12,1h
.return:
	pop rax
	ret

TestIfEndOfBuff:
	push rcx	

	mov rcx,r8
	cmp rcx,rbp
	je .markEndOfBuff
	mov r12,0h
        jmp .return
.markEndOfBuff:
	mov r12,1h
.return:
	pop rcx
	ret

PrintLine:
	push rax
	push rbx
	push rcx
	push rdx	

	mov rax,4
	mov rbx,1
	mov rcx,Dumpline
	mov rdx,FULLLEN
	int 80h	

	pop rdx
	pop rcx
	pop rbx
	pop rax
	ret

GetHighNibble:
	push rax
	
	mov rax,r8
	shr al,4
	and eax,0000000Fh
	mov al,byte [HexDigits + eax]
	mov r12,rax
	
	pop rax
	ret

GetLowNibble:
	push rax

	mov rax,r8
	and eax,0000000Fh
	mov al,byte [HexDigits + eax]
	mov r12,rax
	
	pop rax	
	ret

Global _start

_start:
	nop
	mov rax,Dumpline
	mov rbx,Ascline
	mov rcx,Buff
	xor rsi,rsi
Scan:
	call ReadLine
	xor rcx,rcx
	cmp r12,0h
	je Exit
	call DumpBuff
	jmp Scan


Exit:
	call PrintLine
	mov rax,1
	mov rbx,0
	int 80h
	nop













