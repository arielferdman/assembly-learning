section .bss
	BUFFLEN EQU 10
	Buff resb BUFFLEN
section .data

Dumpline:	db " 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 "
DUMPLEN		EQU $-Dumpline
Ascline:	db "|................|",10
ASCLEN		EQU $-Ascline
FULLLEN		EQU $-Dumpline
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

GLOBAL FillBuff, IsEndOfInput, IsEndOfBuff, BuffToLine, IsLineFull, ProcessChar, 
GLOBAL DumpChar, GetAsciCorrectedCharCode, GetNibbleAsciCode, GetLowNibbleAsciCode, GetHighNibbleAsciCode, PrintLine, ClearLine

FillBuff:
	mov rax,3
	mov rbx,0
	mov rcx,Buff
	mov rdx,BUFFLEN
	int 80h
	mov rbp,rax
	ret


IsEndOfInput:
	cmp rbp,0
	je .true
	mov r12,0
	jmp .return
.true:
	mov r12,1
.return:
	ret


IsEndOfBuff:
	cmp rcx,10h
	je .true
	mov r12,0
	jmp .ret
.true:
	mov r12,1
.ret:
	ret


BuffToLine:
	push rax
	push rbx
	push rcx
	push r8
	xor r8,r8
.handleChar:
	mov al, byte [Buff + r8]
	call ProcessChar
	call DumpChar
	inc r8
	inc rcx
	inc rsi
	call IsEndOfBuff
	cmp r12,1
	je .return
	call IsLineFull
	cmp r12,1
	je .printLine
	jmp .handleChar
.printLine:
	call PrintLine
	call ClearLine
	xor rcx,rcx
	jmp .handleChar
.return:
	pop r8
	pop rcx
	pop rbx
	pop rax
	ret


IsLineFull:
	test esi,0000000Fh
	je .true
	mov r12,0
	jmp .return
.true:
	mov r12,1
.return:
	ret


ProcessChar:
	xor rbx,rbx
	xor rdx,rdx
	xor rdi,rdi
	call GetAsciCorrectedCharCode
	mov rsp,0
	call GetNibbleAsciCode
	mov rsp,1
	call GetNibbleAsciCode
	ret


GetAsciCorrectedCharCode:
	mov bl,byte [DotXlat + eax]
	ret


GetNibbleAsciCode:
	cmp rsp,1
	je .getHighNibble
	call GetLowNibbleAsciCode
	jmp .return
.getHighNibble:
	call GetHighNibbleAsciCode
.return:
	ret


GetLowNibbleAsciCode:
	mov rdx,rax
	and dl,0Fh
	ret


GetHighNibbleAsciCode:
	mov rdi,rax
	shr dil,4

DumpChar:
	push rcx
	xor rcx,rcx
	mov byte [Ascline + ecx + 1],bl
	lea ecx,[ecx*2 + ecx]
	mov byte [Dumpline + ecx + 2],dl
	mov byte [Dumpline + ecx + 1],dil
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


ClearLine:
	push rax
	push rcx
	xor rcx,rcx
	mov rbx,0
	mov rdx,0
	mov rdi,0
.clearChar:
	call DumpChar
	inc rcx
	cmp rcx,10h
	je .return
	jmp .clearChar
.return:
	pop rcx
	push rax
	ret

