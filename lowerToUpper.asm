section .bss
	Buff resb 1	; reserve a 1 byte uninitialized char buffer named - Buff
section .data
section .text
	global _start	; specify for linux the program entry point

_start:
	nop

Read:	mov eax,3	; specify sys_read syscall
	mov ebx,0	; specify file descriptor 0 (stdin)
	mov ecx,Buff	; pass adress of Buff to ecx
	mov edx,1	; specify sys_read should read 1 byte
	int 80h		; call sys_read syscall
	
	cmp eax,0	; compare eax to 0 (eof code)
	je Exit		; if we reached end of file - jump to Exit label

	cmp byte [Buff],61h ; compare read char code to lowercase 'a'
	jb Write	    ; if below 'a' - not lowercase, jump to Write label
	cmp byte [Buff],7Ah ; compare read char code to lowercase 'z'
	ja Write	    ; if above 'z' - not lowercase, jump to Write label
	
	sub byte [Buff],20h ; if we got here - read char is lowercase
			    ; substract 36d from its ascii code to get the matching uppercase char
	
Write:  mov eax,4	; specify sys_write syscall
	mov ebx,1	; specify file descriptor 1 (stdout)
	mov ecx,Buff	; pass char to write to ecx
	mov edx,1	; specify for sys_write to write 1 byte
	int 80h		; call sys_write syscall
	jmp Read	; go to Read label to read the next character

Exit:	mov eax,1	; specify sys_exit syscall
	mov ebx,0	; specify return code 0 (ok program termination)
	int 80h

	nop
