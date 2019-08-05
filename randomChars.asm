section .bss
	Buff resb 1			; reserve 1 byte in memory for current char to write to file
section .data
	counter dd 0			; this is the counter to know how many chars have already been written
section .text
	global _start			; define program entry point for linux to know

_start:					; program entry point
	  nop				; for the debugger

Generate: rdtsc 			; get cpu watch timestamp into edx:eax
	  mov ecx,1bh			; move 27d to ecx
	  mov edx,0			; zero out edx for div
	  div ecx			; divide eax by 27d in ecx to get a number between 0-26 in edx (the modulo)
					; the numbers 0-25 represent lower case characters and 26 represents a new line char
		
	  cmp edx,1ah			; compare the number in edx with 26d
	  je Newline			; if equal jump to Newline label to write a newline char to stdout
 			
	  add edx,61h			; add the value of edx by 97d (ascii char code of a) 
					; since at this point 0<=edx<=25, the result of the addition is 97('a')<=edx<=122('z')
	  mov [Buff],edx		; mov edx to memory at Buff
	  jmp Write			; jump to Write label
 
Newline:  mov byte [Buff],0ah		; move the ascii char code of a newline char to memory at Buff
	  jmp Write			; jump to Write label

Write:    mov eax,4			; specify sys_write system call
	  mov ebx,1			; specify destination of sys_write to be file descriptor 1 (stdout)
	  mov ecx,Buff			; move adress of memory of the byte to write to ecx
	  mov edx,1			; specify that sys_write should write 1 character
	  int 80h			; call sys_write
	  inc dword [counter]		; increase the counter variable in memory to represent that another character was written
	  cmp dword [counter],1000000	; compare counter variable content with 1000000
	  ja Exit			; if counter passed that number then jump to Exit Label
	  jmp Generate			; if not - jump to Generate label

Exit:	  mov eax,1			; specify sys_exit syscall
	  mov ebx,0			; specify return code 0 (program terminated ok)
	  int 80h			; call sys_exit

	  nop				; for the debugger
