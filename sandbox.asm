section .bss
	BUFFLEN EQU 10h
	Buff resb BUFFLEN

section .data
	
section .text

EXTERN FillBuff, IsEndOfInput, IsEndOfBuff, BuffToLine, IsLineFull, ProcessChar, DumpChar, GetNibbleAsciCode, PrintLine, ClearLine

GLOBAL _start

_start:
	nop

Read:
	call FillBuff
	call IsEndOfInput
	cmp r12,1h
	je Exit
	call BuffToLine
	call IsLineFull
	cmp r12,1h
	jne Read
	call PrintLine
	call ClearLine
	jmp Read

Exit:
	mov eax,1
	mov ebx,0
	int 80h

	nop
