section .bss
	BUFFLEN equ 1024	; length of r/w buffer
	Buff resb BUFFLEN	; define r/w buffer
section .data
section .text
	
	global _start		; entry point for linux

_start:
	nop			; for debugger
	
Read:	
	mov eax,3		; specify read syscall
	mov ebx,0		; specify fd 0
	mov ecx,Buff		; specify adress to read to
	mov edx,BUFFLEN		; specify num of bytes to read
	int 80h			; call read syscall
	mov esi,eax		; store num of bytes of last read to esi
	cmp eax,0		; check if we reached end of file
	je Done			; if so jump to Done

	mov ecx,esi		; copy num of bytes of last read to ecx for iteration
	mov ebp,Buff		; copy adress of Buff to ebp for iteration
	dec ebp			; decrease starting adress of buffer to sync num of read bytes with 0 indexing

Scan:	
	cmp byte [ebp+ecx],61h	; compare current byte in buffer to lowercase 'a'
	jb Next			; if below then not lowercase and we can move on to Next
	cmp byte [ebp+ecx],7Ah	; compare current byte in buffer to lowercase 'z' 
	ja Next			; if above then not lowercase and we can move on to Next

	sub byte [ebp+ecx],20h	; if we got here then char is lowercase - substract 20h to get its uppercase equivalent

Next:	dec ecx			; dec ecx by 1 to get previous character (we are traversing the buffer end to start)
	jnz Scan		; if havent reached zero then havent finished traversing the buffer - scan the previous byte

Write:
	mov eax,4		; specify write syscall
	mov ebx,1		; specify fd 1
	mov ecx,Buff		; specify adress of buffer to write
	mov edx,esi		; specify num of bytes to write (num of last read bytes)
	int 80h			; call write syscall
	jmp Read		; jump to read
	
Done:
	mov eax,1		; specify exit syscall 
	mov ebx,0		; specify return call
	int 80h			; call exit syscall

	nop
