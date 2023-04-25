; CS 066
; Brian Luu
INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
	; define your variables here
	line BYTE 0,11,0,"Hello World",0,50,2,0
	textSize DWORD 0
	text BYTE 20 DUP (?)

.code

main PROC
	inputs:
		mov esi, OFFSET line
		mov edi, esi
		add esi, 3
		add edi, 1

		movzx ecx, BYTE PTR[edi]
		add esi, ecx
		inc esi
	
	;-------------------------------
	;COMMENT
	;Printing original string
	;-------------------------------
		mov eax, white
		call setTextColor
		mGoToXY BYTE PTR [esi], BYTE PTR [esi+1]		;Arguments (x-position, y-position)
		mWriteString OFFSET (line+3)					;Arguments (address location)
	
	;-------------------------------
	;COMMENT
	;Overlapping string with color matched inputs
	;-------------------------------
		mov eax, lightMagenta
		call setTextColor
		mGoToXY BYTE PTR [esi], BYTE PTR [esi+1]
		mWriteString OFFSET (text)

		mov eax, 500
		call delay

	;-------------------------------
	;COMMENT 
	;inputs
	;need a way to make sure it matches the string.
	;-------------------------------
		call readKey
		mov ebx, OFFSET text
		mov edx, textSize
		add ebx, edx
		mov edx, edi
		add edx, 2
		add edx, [textSize]
		cmp al, [edx]
		jne here
			mov [ebx], al
			inc [textSize]
		here:

		call clrscr
		inc BYTE PTR [esi+1]
		
		cmp al, 27d					;If escape key we leave
		jne inputs

	INVOKE ExitProcess, 0
main ENDP
END main