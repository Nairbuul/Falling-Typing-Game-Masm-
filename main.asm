; CS 066
; Brian Luu
INCLUDE Irvine32.inc
INCLUDE Macros.inc

;Task List 
;Process string 
;   - initialize string with size, and 4 thingy ma bobbs after
;   - also generate with random x values
;Multiple strings drop
;   - probably gona have a function that prints all the strings...
;Score
;   - two variables # of key strokes
;   -               # of correct key strokes 
;                   add them together div
;                   have constant score show on top left... 

.data
	; define your variables here

    NumberOfKeyStrokes DWORD 0
    CorrectKeyStrokes  DWORD 0

	loopCounter BYTE 0
	textSize DWORD 0
	text BYTE 40 DUP(?)

	marker DWORD 0

	line BYTE 0,11,0, "Hello World", 0,50,0,0,
			  0,13,0, "GoodBye World", 0,15,0,0,
			  0,12,0, "Poker Nights", 0,30,0,0,
              0,10,0, "aaaaaaAaAb",0,54,0,0,
			  0,27,0,"Superfragilistic Alidocious",0,100,0,0
.code

main PROC
	inputs:
        inc [loopCounter]                       ;Decremneting string counter...
        mov al, [loopCounter]
        cmp al, 15
        je decrement

        mov esi, OFFSET line                    ;[esi] Start of variable string
        add esi, [marker]
        mov edi, esi
        add esi, 3
        add edi, 1                              ;[edi] location to the string size

        movzx ecx, BYTE PTR[edi]
        add esi, ecx
        inc esi
    
    ;-------------------------------
    ;COMMENT
    ;Printing original string
    ;Function here to print all string and reset esi to spot???
    ;push esi before func call
    ;-------------------------------
        mov eax, white
        call setTextColor
        mGoToXY BYTE PTR [esi], BYTE PTR [esi+1]        ;Arguments (x-position, y-position)
        mov edx, edi
        add edx, 2
        call WriteString
        ;mWriteString [esi]                                ;Arguments (address location)
    
    ;-------------------------------
    ;COMMENT
    ;Overlapping string with color matched inputs
    ;-------------------------------
        mov eax, lightMagenta
        call setTextColor
        mGoToXY BYTE PTR [esi], BYTE PTR [esi+1]
        mWriteString OFFSET (text)

        mov eax, 10
        call delay

    ;-------------------------------
    ;COMMENT 
    ;inputs
    ;removing character when fully matched...
    ;-------------------------------
        call readKey
        test al, 0
        jnz noInputs
            inc [NumberOfKeyStrokes]
    noInputs:
        mov ebx, OFFSET text
        mov edx, textSize
        add ebx, edx
        mov edx, edi
        add edx, 2
        add edx, [textSize]
        cmp al, [edx]
        jne here
            inc [CorrectKeyStrokes]
            mov [ebx], al
            inc [textSize]
            mov bl, BYTE PTR [textsize]
            cmp bl, cl
            jb here
                ;clear variable / get next Variable???
                call clearVariable
                mov BYTE PTR [(edi+2)], 0                           ;Maybe find a new method...
                mov al, [edi]
                add BYTE PTR [marker], al
                add [marker], 7
        here:

        call clrscr
        
        cmp al, 27d                                                 ;If escape key we leave
        jne inputs
        je EndOfInput

    Decrement: 
        mov [loopCounter], 0
        inc BYTE PTR [(esi+1)]
        jmp inputs

    EndOfInput:
    INVOKE ExitProcess, 0
main ENDP

;-------------------------------------------------------------------------------------
;Procedure to clear the text variable that overwrites the string.
;-------------------------------------------------------------------------------------
clearVariable PROC	
	push esi									;Saving esi	
	mov ecx, 10									;Clearing 4*10 BYTES of memory
	mov esi, OFFSET text						;Setting esi to the address of text (the variable overwriting the string)
	Clearing:								;Start of loop
		mov DWORD PTR[esi],0					; Clearing 4 bytres of memory
		add esi, DWORD							; Moving esi to the next 4 bytes of memory.
	loop Clearing							;End of loop
			
	mov [textSize],0							;setting textSize to zero
	pop esi										;Restoring esi's original value.
	
	ret		
clearVariable ENDP

END main