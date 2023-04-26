; CS 066
; Brian Luu
INCLUDE Irvine32.inc
INCLUDE Macros.inc

.data
    ; define your variables here
    line BYTE 0,27,0,"Superfragilistic Alidocious",0,50,0,0
    line2 BYTE 0,13,0, "Goodbye World", 0, 10,0,0
    textSize DWORD 0
    text BYTE 20 DUP (?)

    loopCounter BYTE 0

.code

main PROC
    inputs:
        inc [loopCounter]                      ;Decremnet counter...
        mov al, [loopCounter]
        cmp al, 10
        je decrement

        mov esi, OFFSET line                  ;[esi] Start of variable string
        mov edi, esi
        add esi, 3
        add edi, 1                          ;[edi] location to the string size

        movzx ecx, BYTE PTR[edi]
        add esi, ecx
        inc esi
    
    ;-------------------------------
    ;COMMENT
    ;Printing original string
    ;-------------------------------
        mov eax, white
        call setTextColor
        mGoToXY BYTE PTR [esi], BYTE PTR [esi+1]        ;Arguments (x-position, y-position)
        mWriteString OFFSET (line+3)                    ;Arguments (address location)
    
    ;-------------------------------
    ;COMMENT
    ;Overlapping string with color matched inputs
    ;-------------------------------
        mov eax, lightMagenta
        call setTextColor
        mGoToXY BYTE PTR [esi], BYTE PTR [esi+1]
        mWriteString OFFSET (text)

        mov eax, 50
        call delay

    ;-------------------------------
    ;COMMENT 
    ;inputs
    ;removing character when fully matched...
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
            mov bl, BYTE PTR [textsize]
            cmp bl, cl
            jb here
                ;clear variable / get next Variable???
                call clearVariable
                mov BYTE PTR [(edi+2)], 0                           ;Maybe find a new method...
        here:

        call clrscr
        
        cmp al, 27d                    ;If escape key we leave
        jne inputs
        je EndOfInput

    Decrement: 
         mov [loopCounter], 0
        inc BYTE PTR [(esi+1)]
        jmp inputs

    EndOfInput:
    INVOKE ExitProcess, 0
main ENDP

keyStroke PROC

    ret
keyStroke ENDP

clearVariable PROC
    push esi
    mov ecx, 5
    mov esi, OFFSET text

    Clearing:
        mov DWORD PTR [esi], 0
        add esi, DWORD
     loop Clearing

     mov [textSize], 0
     pop esi

    ret
clearVariable ENDP 

END main