with open('test.txt', 'r') as input:
	with open('result.txt', 'w') as result:
		content = input.read()
		
		for char in content:
			charAscii = ord(char)
			if charAscii >= 97 and charAscii <= 122:
				result.write(chr(charAscii - 32))
			else:
				result.write(char)
			
	
