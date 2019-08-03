sandbox : sandbox.o
	ld -o sandbox sandbox.o
sandbox.o: sandbox.asm
	nasm -f elf64 -g -F dwarf sandbox.asm -o sandbox.o
	
