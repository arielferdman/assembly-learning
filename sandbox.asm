section .bss
	Buff resb 1
section .data
section .text
	global _start

_start:
	nop

Read:	mov eax,3 	; specify sys_read call
	mov ebx,0	; specify file descriptor 0: standard input
	mov ecx,Buff	; pass adress of the buffer to read to 
	mov edx,1	; tell sys_read to read 1 char from stdin
	int 80h		; call sys_read

	cmp eax,0	; look at sys_read return value in eax
	je Exit		; jump if equal to 0 (EOF CHAR) to exit
			; or fall through to test for lowercase

	cmp byte [Buff],61h ; test input char against lower case 'a'
	jb Write	; if below 'a' in ASCII chart, not lowercase
	
	cmp byte [Buff],7Ah ; test input char against lower case 'z'
	ja Write	; if above 'z' in ASCII char, not lowercase
			; at this point we have a lowercase character
	sub byte [Buff],20h ; substract 20h from lowercase to get uppercase
			; and then write the char to stdout
Write:	mov eax,4	; specify sys_write system call
	mov ebx,1	; specify file descriptor 1 stdout
	mov ecx,Buff	; pass address of the character to write
	mov edx,1	; pass number of chars to write
	int 80h		; call sys_write
	jmp Read	; then go to the beggining to get another character

Exit:	mov eax, 1	; code for Exit syscall
	mov ebx, 0	; return code 0 (program terminated without errors)
	int 80h		; make a kernel call to exit program



	nop


