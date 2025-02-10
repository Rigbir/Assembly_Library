%ifndef STR_TO_INT_DEFINED    ; We check whether the data block has been
%define STR_TO_INT_DEFINED    ; initialized at least once. If not, then we
                              ; read this data block, else skip
   section .data              ; Constants value segment
      ten dw 10               ; Initialize const divider
      space db " $"           ; Space for several message
   section .bss               ; Segment of uninitialized variables
      for_length dw ?
      buffer resb 6           ; Reserve buffer for string
      result resb 256         ; Reserve memory for concatination string 
%endif 
;-------------------------------------------------------------------------------
%macro str_to_int 1           ; Macros for input string to integer value
   push ax                    ; Save AX value in memory
   push bx                    ; Save BX value in memory
  
   mov bx, 0                  ; Initialize BX (used to store the number)

   %%convert_loop:            ; Start loop to convert each character to a digit
      mov ah, 1h              ; Read a character from input
      int 21h                 ; DOS interupt to get character
      cmp al, 13              ; Check if Enter (Carriage Return) is pressed
      je %%save_number        ; If Enter, exit the loop

      cmp al, '0'             ; Check if the character is bellow '0' (invalid input)
      jb %%convert_loop       ; If below '0', ignore and wait for next input
      cmp al, '9'             ; Check if the character is above '9'  (invalid input)
      ja %%convert_loop       ; If above '9', ignore and wait for next input
   
      sub al, '0'             ; Convert ASCII digit ('5' -> 5)
      mov ah, 0               ; Zero AH to prepare for multiplication  
                  
      push ax                 ; Save AX value in stack memory

      mov ax, bx              ; Move BX value into AX for multiplication (AX = BX)
      mul word [ten]          ; AX = AX * 10, result stored in AX (upper byte in DX)
      mov bx, ax              ; Stored result back into BX (BX = AX)

      pop ax                  ; Restore AX value from stack
      add bx, ax              ; BX = BX + AX

      jmp %%convert_loop      ; Repeat the process for the next character

   %%save_number:
      mov [%1], bx            ; Save final BX value
   
   pop bx                     ; Get previous BX value from memory
   pop ax                     ; Get previous AX value from memory
%endmacro
;-------------------------------------------------------------------------------
%macro int_to_str 2           ; Macros for transfer Integer value to ASCII
   push ax                    ; Save AX value in memory
   push bx                    ; Save BX value in memory
   push dx                    ; Save DX value in memory
   push cx                    ; Save CX value in memory
   push di                    ; Save DI value in memory

   xor cx, cx                 ; CX = 0
   mov ax, [%2]               ; Load the integer value into AX
   mov bx, ax                 ; Save number in BX 

   %%count_digit:             ; Loop for count length number
      xor dx, dx              ; DX = 0
      div word [ten]          ; Divide AX by 10 
      inc cx                  ; Increment CX
      test ax, ax             ; Check if AX have any digit
      jnz %%count_digit       ; If yes, return loop 

   mov ax, %1                 ; Move buffer in AX
   add ax, cx                 ; Adding number length and buffer, result in AX 
   mov di, ax                 ; Move pointer DI to position buffer + CX
   mov byte [di], '$'         ; Set end-string-character
   dec di                     ; Move DI pointer to the previous character

   mov ax, bx                 ; Return number from BX to AX

   %%to_string:
      xor dx, dx              ; Clear DX (used for division result)
      div word [ten]          ; Divide AX by 10, result in AL, remainder in DL 
      add dl, '0'             ; Convert remainder (digit) to ASCII
      mov [di], dl            ; Store the ASCII character at the current position
      dec di                  ; Move DI pointer to the next character (backwards)
      test ax, ax             ; Check if AX is zero (if the number is fully converted)  
      jnz %%to_string         ; If not zero, continue with the next digit

   pop di                     ; Return previous DI value
   pop cx                     ; Return previous CX value
   pop dx                     ; Return previous DX value
   pop bx                     ; Return previous BX value
   pop ax                     ; Return previous AX value
%endmacro
;------------------------------------------------------------------------------
%macro print_newline 0        ; Macros for moving the cursor to a new line 
   push ax                    ; Save AX value in memory
   push dx                    ; Save DX value in memory

   mov ah, 02h                ; DOS function to print character 
   mov dl, 0Dh                ; DL = Carriage Return
   int 21h                    ; DOS interrupt
   mov dl, 0Ah                ; DL = Line Feed 
   int 21h                    ; DOS interrupt

   pop ax                     ; Return previous AX value
   pop dx                     ; Return previous DX value
%endmacro
;------------------------------------------------------------------------------
%macro print_str 1            ; Macros for print output string on screen
   push ax                    ; Save AX value im stack memory
   push dx                    ; Save DX value in stack memory

   mov dx, %1                 ; Mov message to DX
   mov ah, 9h                 ; DOS function to display string
   int 21h                    ; DOS interrupt to pring the string

   pop dx                     ; Return previous DX value from memory
   pop ax                     ; Return previous AX value from memory
%endmacro
;------------------------------------------------------------------------------
%macro print_strln 1          ; Macros for print string in newline
   print_newline              ; Moving cursor to newline
   print_str %1               ; Print string to screen
%endmacro
;------------------------------------------------------------------------------
%macro print_strs 2-*         ; Macros for min 2 string 
   %rep %0                    ; Reading the number of arguments:
      print_strln %1          ; msg1, msg2, msg3 -> %0 == 3 
      %rotate 1               ; Print string
   %endrep                    ; And %0 -= 1
%endmacro
;------------------------------------------------------------------------------
%macro print_strs_line 2-*    ; Macros for min 2 string in 1 line with space
   print_newline
   %rep %0                    ; Reading the number of arguments
      print_str %1            ; Print string 
      %if %0 > 1              ; If count arguments above 1 executing the body  
         print_str space      ; After each one word space 
      %endif                  
      %rotate 1               ; %0 -= 1
   %endrep
%endmacro 
;------------------------------------------------------------------------------
%macro print_char 1           ; Macros for print char
   push ax                    ; Save AX value to memory
   push dx                    ; Save DX value to memory
   push bx                    ; Save BX value to memory

   mov bl, %1                 ; Save DL value, if passing arguments is register

   mov ah, 02h                ; DOS function to print character 
   mov dl, 0Dh                ; DL = Carriage Return 
   int 21h                    ; Interrupt (output on screen)

   mov dl, 0Ah                ; DL = Line Feed
   int 21h                    ; Interrupt (output on screen)

   mov dl, bl                 ; Move character to DL 
   int 21h                    ; DOS interrupt

   pop bx                     ; Restore BX register
   pop dx                     ; Restore DX register
   pop ax                     ; Restore AX register
%endmacro
;------------------------------------------------------------------------------
%macro concat_strs 2-*        ; Macros for concatenate 2+ strings
   push di                    ; Save DI value to memory
   push si                    ; Save SI value to memory

   mov di, result             ; Set DI to the beginning of the result buffer
   %assign i 0                ; Use a local variable to create unique loop labels

   %rep %0                    ; Loop over the arguments
      mov si, %1              ; Set SI to point to the current string
      %rotate 1               ; Move to the next argument

      %%copy_str_ %+ i:       ; Loop for copying the current string to the result buffer
         lodsb                ; Load byte from SI into AL, increment SI
         cmp al, '$'          ; Check if the current byte is the end-of-string marker
         jz %%done_ %+ i      ; If end of string, jump to the next argument
         stosb                ; Store the byte in the result string (DI points here)
         jmp %%copy_str_ %+ i ; Repeat for the next byte
      %%done_ %+ i:           
         %assign i i+1        ; Increment i for the next unique loop label
   %endrep                    ; End the loop for all arguments

   mov byte [di], '$'         ; Mark the end of the concatenated string with '$'
   print_str result           ; Print the concatenated result string 
                                                 
   pop si                     ; Restore the SI register
   pop di                     ; Restore the DI register 
%endmacro
;------------------------------------------------------------------------------
%macro length_str 2           ; Macros for count string length
   push ax                    ; Save AX value in memory
   push cx                    ; Save CX value in memory
   push si                    ; Save SI value in memory

   xor cx, cx                 ; CX = 0
   mov si, %2                 ; Set SI point to start string 
   %%count_loop:              
      lodsb                   ; Load byte from SI to AL, increment SI
      cmp al, '$'             ; Check string to end-string-character
      jz %%end                ; If the string finished, go to the end
      inc cx                  ; If not, increment CX value 
      jmp %%count_loop        ; And go to next character position
   %%end:
      mov [%2], cx              ; Move CX value to reserve variable 
      int_to_str %1, %2       ; Call function for transform integer value to string 

   pop si                     ; Return previous SI value 
   pop cx                     ; Return previous CX value
   pop ax                     ; Return previous AX value
%endmacro
;------------------------------------------------------------------------------

