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
;   - two variables # of key strokes                                ;Done
;   -               # of correct key strokes                        ;Done
;                   add them together div use ch8 parameter
;                   have constant score show on top left...         ;Done

;Parameters
x_param EQU [ebp + 8]
y_param EQU [ebp + 12]

.data
    ; define your variables here
    
    ;Score variables
    ;==================================
    HealthText BYTE "Health: ", 0
    Health BYTE 33h
    
    NumberOfKeyStrokes DWORD 0
    CorrectKeyStrokes  DWORD 0
    ScoreText BYTE "Score: ", 0
    AccuracyText BYTE "Accuracy: ",0
    Accuracy DWORD 0
    AccuracyText2 BYTE "%",0
    ;==================================

	loopCounter BYTE 0             ;Variable to count amount of loop before decrementing string
	textSize DWORD 0               ;Variable that prints over string
	text BYTE 40 DUP(?)            ;Variable that prints over string

	marker DWORD 0                 ;Word location

	line BYTE   0,11,0, "Hello World", 0,50,1,0,
			    0,13,0, "GoodBye World", 0,15,1,0,
		        0,12,0, "Poker Nights", 0,30,1,0,
                0,10,0,"Particular",0,85,1,0,
			    0,27,0,"Superfragilistic Alidocious",0,100,1,0,
                0,10,0, "aaaaaaAaAb",0,54,1,0
    
    endOfDictionary DWORD $
.code

main PROC
	inputs:
        ;Score UI
        ;==================================
        call clrscr
        mov eax, white
        call settextcolor
        mov edx, OFFSET ScoreText
        call WriteString
        mov eax, [CorrectKeyStrokes]
        call WriteInt
        ;DEBUG=======
        mov eax, [NumberOfKeyStrokes]
        call WriteInt
        ;============
        mGoToXY 65, 0
        mov edx, OFFSET accuracyText
        call WriteString
        mov eax, [Accuracy]
        call WriteInt
        mov edx, OFFSET accuracyText2
        call WriteString
        mGoToXY 122 , 0
        mWriteString OFFSET HealthText
        mov al, [Health]
        call WriteChar
        ;==================================

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
        mov eax, LightRed
        call setTextColor
        mGoToXY BYTE PTR [esi], BYTE PTR [esi+1]
        mWriteString OFFSET (text)

        mov eax, 15
        call delay

    ;-------------------------------
    ;COMMENT 
    ;inputs
    ;removing character when fully matched...
    ;-------------------------------
        call readKey
        cmp al, 1
        jle noInputs
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
                call clearVariable
                mov BYTE PTR [(edi+2)], 0                           ;Maybe find a new method...
                push eax
                mov al, [edi]
                add BYTE PTR [marker], al
                add [marker], 7
                pop eax
        here:
        
        push eax
        push ebx
        push edx
        call getAccuracy
        pop edx
        pop ebx
        pop eax

        cmp al, 27d                                                 ;If escape key we leave
        jne inputs
        je EndOfInput

    Decrement: 
        mov [loopCounter], 0
        inc BYTE PTR [(esi+1)]
        jmp inputs

    EndOfInput:

        ;End game ui
        ;===============================================================
        call clrscr                                             ;Formatting
        call clrscr                                             ;Formatting
        mov edx, OFFSET ScoreText                               ;Score
        mGoToXY 65, 15                                          ;Middle of Screen
        mov eax, lightGreen                                     ;TextColor
        call setTextColor                                       ;setting TextColor
        call WriteString                                        ;Printing Score text
        mov eax, [CorrectKeyStrokes]                            ;Printing Score value
        call WriteInt                                           ;Printing Score value
        mGoToXY 65,16                                           ;Moving to next line
        mov edx, OFFSET accuracyText                            ;Accuracy text
        call WriteString                                        ;Printing Accuracy text
        mov eax, [Accuracy]                                     ;Accuracy value
        call WriteInt                                           ;Printing Accuracy Value
        mov edx, OFFSET accuracyText2                           ; % symbol
        call WriteString                                        ;Printing & symbol
        mGoToXY 65, 17                                          ;Moving to next line
        mWriteln "Game Over"                                    ;End Game text
        call crlf                                               ;Formatting
        call crlf                                               ;Formatting
        call crlf                                               ;Formatting
        ;===============================================================
    INVOKE ExitProcess, 0
main ENDP

;-------------------------------------------------------------------------------------
;Procedure to calculate the accuracy.
;-------------------------------------------------------------------------------------
getAccuracy PROC
    cmp [NumberOfKeyStrokes], 0
    je zero
    cmp [CorrectKeyStrokes],0 
    je zero

    mov edx, 0 
    mov eax, [NumberOfKeyStrokes]
    mov ebx, [CorrectKeyStrokes]
    div ebx
    mov accuracy, eax
        
    zero:
    ret
getAccuracy ENDP

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