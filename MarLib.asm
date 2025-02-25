%ifndef STR_TO_INT_DEFINED    ; We check whether the data block has been
%define STR_TO_INT_DEFINED    ; initialized at least once. If not, then we
                              ; read this data block, else skip
   section .data              ; Constants value segment
      ten dw 10               ; Initialize const divider
      space db " $"           ; Space for several message
      true_msg db "True$"     ; True string tags
      false_msg db "False$"   ; False string tags
      error_msg db "Error!$"  ; Error string tags

   section .bss               ; Segment of uninitialized variables
      for_length dw ?         ; Reserve memory for length string
      buffer resb 6           ; Reserve buffer for string
      result resb 256         ; Reserve memory for concatination string

%endif
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;
;              The Macro block used for help operations
;
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
%macro multipush 1-*          ; Macros for push more one arguments
   %rep %0                    ; Repeat for the number of arguments passed
      push %1                 ; Push the current argument onto the stack
      %rotate 1               ; Rotate arguments to move the next one into position
   %endrep                    ; End the repetition loop
%endmacro
;------------------------------------------------------------------------------
%macro multipop 1-*           ; Define the macro multipop that accepts one or more arguments
   %rep %0                    ; Repeat for the number of arguments passed
      %rotate -1              ; Rotate arguments in the opposite direction to prepare for popping
      pop %1                  ; Pop the current value from the stack into the current argument
   %endrep                    ; End the repetition loop
%endmacro
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;
;   The Macro block used for numbers and operations with them
;
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
%macro read_int 1             ; Macros for input integer value
   
   ; Save registers to preserve their original values
   multipush ax, bx

   xor bx, bx                 ; Clear BX (used to store the input number)

   %%input_loop:
      mov ah, 01h             ; DOS interrupt to read a single character
      int 21h

      cmp al, 13              ; Check if Enter (Carriage Return) is pressed
      jz %%saved_value        ; If yes, exit the loop
      cmp al, '0'             ; Check if the character is bellow '0' (invalid input)
      jb %%input_loop         ; If below '0', ignore and wait for next input
      cmp al, '9'             ; Check if the character is above '9'  (invalid input)
      ja %%input_loop         ; If above '9', ignore and wait for next input
 
      sub al, '0'             ; Convert ASCII character to numeric value
      mov ah, 0               ; Clear AH for multiplication
      push ax                 ; Save the current digit

       mov ax, bx             ; Load the accumulated number into AX
       mul byte [ten]         ; Multiply by 10 (shift left by one decimal place)
       mov bx, ax             ; Store result back in BX

      pop ax                  ; Retrieve the last input digit
      add bx, ax              ; Add it to the accumulated number

      jmp %%input_loop        ; Continue reading input

   %%saved_value:
      mov [%1], bx            ; Store the final result in the priveded memory location

   ; Restore original registers values
   multipop ax, bx
%endmacro
;------------------------------------------------------------------------------
%macro str_to_int 2           ; Macros for convert string to integer value
   
   ; Save registers to preserve their original values
   multipush ax, bx
  
   xor bx, bx                 ; Clear BX (used to store the number)
   mov si, %1                 ; Load the address of the input string into SI
   mov di, %2                 ; Load the address where the result should be stored

   ; Start loop to convert each character to a digit
   %%convert_loop:
      lodsb                   ; Load character from SI into AL and increment SI
      cmp al, '$'             ; Check for the end-string character
      jz %%save_number        ; If yes, exit the loop
      
      sub al, '0'             ; Convert ASCII digit to number value
      mov ah, 0               ; Clear AH for multiplication

      push ax                 ; Save the current digit
       mov ax, bx             ; Load the accumlated number into AX
       mul byte [ten]         ; Multiplay by 10 (shift left by one decimal place)
       mov bx, ax             ; Store result back in BX
      pop ax                  ; Retrieve the last input digit

      add bx, ax              ; Add it to the accumulated number

      jmp %%convert_loop      ; Continue processing the next character

   %%save_number:
      mov [%2], bx            ; Store the final integer value in the
                              ; given memory location
   
   ; Restore original registers values
   multipop ax, bx
%endmacro
;------------------------------------------------------------------------------
%macro int_to_str 2           ; Macros to convert an integer to an ASCII string
   
   ; Save registers to preserve their original values
   multipush ax, bx, dx, cx, di

   xor cx, cx                 ; Clear CX (digit counter)

   ; Load the integer value from the given register or memory location into AX
   %ifidn %1, ax
      mov ax, ax              ; If the input is AX, keep it as is
   %elifidn %1, bx
      mov ax, bx              ; If the input is BX, move BX to AX
   %elifidn %1, dx
      mov ax, dx              ; If the input is DX, move DX to AX
   %else
      mov ax, [%1]            ; Otherwise, load the integer value from memory
   %endif

   mov bx, ax                 ; Save the original number in BX

   ; Count the number of digits in the integer
   %%count_digit:             ;
      xor dx, dx              ; Clear DX (high part of division)
      div word [ten]          ; Divide AX by 10 (DX:AX / 10, remainder in DX)
      inc cx                  ; Increment the digit counter CX
      test ax, ax             ; Check if AX is zero (no more digits left)
      jnz %%count_digit       ; If not, repeat the loop

   ; Compute the position in the buffer where the ASCII string should be stored
   mov ax, %2                 ; Move buffer address into AX
   add ax, cx                 ; Add the digit count to buffer address
   mov di, ax                 ; Store the final pointer in DI
   mov byte [di], '$'         ; Append end-of-string marker
   dec di                     ; Move DI one position back for digit storage

   mov ax, bx                 ; Restore the original number from BX

   ; Convert the number to ASCII characters (processing digits form right to left)
   %%to_string:
      xor dx, dx              ; Clear DX (for division)
      div word [ten]          ; Divide AX by 10, result in AL, remainder in DL
      add dl, '0'             ; Convert remainder (digit) to ASCII
      mov [di], dl            ; Store the ASCII character at the current position
      dec di                  ; Move DI back for the next digit
      test ax, ax             ; Check if there are more digits left
      jnz %%to_string         ; If AX is not zero, repeat

   ; Restore original registers values
   multipop ax, bx, dx, cx, di
%endmacro
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;
;             The Macro block used for number system translations
;
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
%macro int_to_bin 2           ; Macros for convert 2-byte integer to binary number
   
   ; Save registers to preserve their original values
   multipush ax, cx, dx, di

   mov dx, %1                 ; Load the 16-bit integer into DX
   lea di, %2                 ; Load the address of the output buffer into DI
   mov ah, '0'/2              ; Set AH to half of ASCII '0' (0x30 / 2 = 0x18)
   mov cx, 16                 ; Set loop counter for 16 bits

   %%conversion:
      mov al, ah              ; Load base value ('0'/2) into AL
      shl dx, 1               ; Shift DX left, moving the highest bit into CF
      adc al, al              ; Add AL + AL + CF (turns '0' into '1' if CF=1)
      stosb                   ; Store AL in [DI] and increment DI
      dec cx                  ; Decrement loop counter
      jnz %%conversion        ; Repeat until CX reaches 0
  
   mov byte [di], '$'         ; Null-terminate the string

   ; Restore original registers values
   multipop ax, cx, dx, di
%endmacro
;------------------------------------------------------------------------------
%macro bin_to_int 2           ; Macros to convert binary number to integer

   ; Save registers to preserve their original values
   multipush ax, bx, dx, cx, si

   mov dx, %1                 ; Load the input binary number into DX
   mov cx, 16                 ; Set CX to 16 (for 16 bits of input binary)
   mov si, 1                  ; Set SI to 1 (initial place value)

   %%conversion:
      test dx, 1              ; Test the least significant bit of DX
      jz %%skip               ; If the bit is 0, skip adding to AX

      add ax, si              ; Add the current place value (SI) to AX if the bit is 1
   %%skip:
      shr dx, 1               ; Shift the bits in DX right by 1 (moving to next bit)
      shl si, 1               ; Shift the place value (SI) left by 1 (doubling the value)
      dec cx                  ; Decrease the bit counter (CX)
      jnz %%conversion        ; If CX is not zero, repeat the conversion process

   int_to_str ax, %2          ; Convert the final result in AX to a string (calls the int_to_str macro)

   ; Restore original registers values
   multipop ax, bx, dx, cx, si
%endmacro
;------------------------------------------------------------------------------
%macro int_to_hex 2           ; Macros for convert unsigned number to hexadecimal

   ; Save registers to preserve their original values
   multipush ax, dx, cx, di

   mov ax, %1                 ; Load unsigned number into AX
   mov di, %2                 ; Load the address of the output buffer into DI
   mov cx, 4                  ; Set loop counter to 4 (processing 4 hex digits)

   %%conversion:
      rol ax, 4               ; Rotate left by 4 bits to extract the next hex digit
      mov dx, ax              ; Copy the result to DX
      and dx, 0xF             ; Mask out only the lowest 4 bits (hex digit)
      
      cmp dx, 9               ; Check if the digit is in the range 0-9
      jle %%less              ; If yes, jump to %%less to convert it to ASCII
      add dx, 'A' - 10        ; Convert 10-15 to ASCII ('A'-'F')
      jmp %%store             ; Jump to %%store to save the character
   %%less:
      add dx, '0'             ; Convert 0-9 to ASCII ('0'-'9')
   %%store:
      mov byte [di], dl       ; Store the character in the output buffer
      inc di                  ; Move to the next buffer position
      loop %%conversion       ; Repeat for all 4 hex digits

   mov byte [di], '$'         ; Null-terminate the string

   ; Restore original registers values
   multipop ax, dx, cx, di
%endmacro
;------------------------------------------------------------------------------
%macro hex_to_int 2
   multipush ax, bx, cx, dx
%endmacro
;------------------------------------------------------------------------------
%macro int_to_oct 2

   ; Save registers to preserve their original values
   multipush ax, dx, cx, di

   mov ax, %1                 ; Load unsigned number into AX
   mov di, %2                 ; Load the address of the output buffer into DI
   mov cx, 6                  ; Set loop counter to 6 (processing 6 octal digits)
   
   add di, cx                 ; Move DI to the end of the buffer
   mov byte [di], '$'         ; Null-terminate the string
   dec di                     ; Move back one position for the first digit
         
   %%conversion:
      mov dx, ax              ; Copy AX to DX
      and dx, 0x7             ; Get the least sigificant 3 bits (octal digit)
      add dx, '0'             ; Convert to ASCII
      mov byte [di], dl       ; Store the digit in the buffer
      dec di                  ; Move buffer pointer left

      shr ax, 3               ; Shift AX right by 3 (divide by 8)
      loop %%conversion       ; Repeat for all digits

   ; Restore original registers values
   multipop ax, dx, cx, di
%endmacro
;------------------------------------------------------------------------------
%macro oct_to_int 2

   ; Save registers to preserve their original values
   multipush ax, bx, cx, dx, si

   mov ax, %1                 ; Load the unsigned octal number into AX
   mov cx, 6                  ; Set the loop counter to 6 (processing up to 6 octal digits)
   xor bx, bx                 ; Clear BX (used for storing the final integer result)

   mov si, 1                  ; SI will be used as the positional multiplier (1, 8, 64, ...)

   %%conversion:
      mov dx, ax              ; Copy AX to DX
      and dx, 0x7             ; Extract the lowest octal digit (AX & 7)

      imul dx, si             ; Multiply the digit by the current position multiplier
      shl si, 3               ; Multiply SI by 8 (shift left by 3 bits)
      add bx, dx              ; Accumulate the result in BX

      shr ax, 3               ; Shift AX right by 3 bits to process the next octal digit
      dec cx                  ; Decrease the loop counter
      jnz %%conversion        ; Repeat until all 6 digits are processed

   int_to_str bx, %2          ; Convert the final integer result to a string and store in %2

   ; Restore original register values
   multipop ax, bx, cx, dx, si
%endmacro
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
;
;   The Macro block used for strings and operations with them
;
;------------------------------------------------------------------------------
;------------------------------------------------------------------------------
%macro newline 0              ; Macros for moving the cursor to a new line
   
   ; Save registers to preserve their original values
   multipush ax, dx

   mov ah, 02h                ; DOS function to print character
   mov dl, 0Dh                ; DL = Carriage Return
   int 21h                    ; DOS interrupt
   mov dl, 0Ah                ; DL = Line Feed
   int 21h                    ; DOS interrupt

   ; Restore original registers values
   multipop ax, dx
%endmacro
;------------------------------------------------------------------------------
%macro print 1                ; Macros for print output string on screen
   
   ; Save registers to preserve their original values
   multipush ax, dx

   mov dx, %1                 ; Mov message to DX
   mov ah, 9h                 ; DOS function to display string
   int 21h                    ; DOS interrupt to pring the string

   ; Restore original registers values
   multipop ax, dx
%endmacro
;------------------------------------------------------------------------------
%macro println 1              ; Macros for print string in newline
   newline                    ; Moving cursor to newline
   print %1                   ; Print string to screen
%endmacro
;------------------------------------------------------------------------------
%macro print_multi 2-*        ; Macros for min 2 string
   %rep %0                    ; Reading the number of arguments:
      println %1              ; msg1, msg2, msg3 -> %0 == 3
      %rotate 1               ; Print string
   %endrep                    ; Repeat while count of the argument don't equal zero
%endmacro
;------------------------------------------------------------------------------
%macro print_inline 2-*       ; Macros for min 2 string in 1 line with space
   newline                    ; Print newline
   %rep %0                    ; Reading the number of arguments
      print %1                ; Print string
      %if %0 > 1              ; If count arguments above 1 executing the body
         print space          ; After each one word space
      %endif
      %rotate 1               ; Repeat while count of the argument don't equal zero
   %endrep
%endmacro
;------------------------------------------------------------------------------
%macro print_char 1           ; Macros for print char
   
   ; Save registers to preserve their original values
   multipush ax, dx, bx

   mov bl, %1                 ; Save DL value, if passing arguments is register

   mov ah, 02h                ; DOS function to print character
   mov dl, 0Dh                ; DL = Carriage Return
   int 21h                    ; Interrupt (output on screen)

   mov dl, 0Ah                ; DL = Line Feed
   int 21h                    ; Interrupt (output on screen)

   mov dl, bl                 ; Move character to DL
   int 21h                    ; DOS interrupt

   ; Restore original registers values
   multipop ax, dx, bx
%endmacro
;------------------------------------------------------------------------------
%macro concat 2-*             ; Macros for concatenate 2+ strings
   
   ; Save registers to preserve their original values
   multipush di, si
                  
   mov di, %1                 ; Set DI to the beginning of the result buffer
   %assign i 0                ; Local variable to create unique loop labels

   %rep %0-1                  ; Iterate over all string arguments (excluding the result buffer)
      mov si, %2              ; Set SI to point to the current string
      %rotate 1               ; Move to the next argument

      %%copy_str_ %+ i:       ; Loop for copying the current string to the result buffer
         lodsb                ; Load a byte from SI into AL, increment SI
         cmp al, '$'          ; Check if the current byte is the end-of-string marker
         jz %%done_ %+ i      ; If end of string, jump to the next argument
         stosb                ; Store the byte in the result string (DI points here)
         jmp %%copy_str_ %+ i ; Repeat for the next byte
      %%done_ %+ i:
         %assign i i+1        ; Increment i for the next unique loop label
   %endrep                    ; End the loop for all arguments

   mov byte [di], '$'         ; Mark the end of the concatenated string with '$'
                                                 
   ; Restore original registers values
   multipop di, si
%endmacro
;------------------------------------------------------------------------------
%macro strlen 2               ; Macros for count string length
   
   ; Save registers to preserve their original values
   multipush ax, cx, si

   xor cx, cx                 ; CX = 0
   mov si, %2                 ; Set SI point to start string

   %%count_loop:
      lodsb                   ; Load byte from SI to AL, increment SI
      cmp al, '$'             ; Check string to end-string-character
      jz %%end                ; If the string finished, go to the end
      inc cx                  ; If not, increment CX value
      jmp %%count_loop        ; And go to next character position
   %%end:
      mov [%1], cx            ; Move CX value to reserve variable
      int_to_str %1, %1       ; Call function for transform integer value to string
     
   ; Restore original registers values
   multipop ax, cx, si
%endmacro
;------------------------------------------------------------------------------
%macro strcopy 2              ; Macros for copying the second string to the first
   
   ; Save registers to preserve their original values
   multipush ax, si, di

   mov di, %1                 ; Set DI pointer to the beginning first string
   mov si, %2                 ; Set SI pointer to the beginning second string

   %%copy_loop:
      lodsb                   ; Load byte from SI to AL and increment SI
      cmp al, '$'             ; Check end-string-character
      jz %%end                ; If string finally, exit loop
      stosb                   ; Store the byte in the result string (DI points here)
      jmp %%copy_loop         ; Repeat for the next byte
   %%end:
      mov byte [di], '$'      ; Set end-charater-string

   ; Restore original registers values
   multipop ax, si, di
%endmacro
;------------------------------------------------------------------------------
%macro strcmp 3               ; Macros for comparing two string and get compare-result
   
   ; Save registers to preserve their original values
   multipush ax, si, di

   mov di, %2                 ; Set DI pointer to the beginning first string
   mov si, %3                 ; Set SI pointer to the beginning second string

   %%comp_loop:
      mov al, [di]            ; Move value from DI pointer to AL register
      mov bl, [si]            ; Move value from SI pointer to BL register

      cmp al, '$'             ; Check the first string on finally
      jz %%check_end          ; If yes, check second string (exit loop)

      cmp al, bl              ; If SI equal DI, continue loop
      jnz %%not_equal         ; If they not equal, exit loop

      inc di                  ; Move DI pointer to the next character
      inc si                  ; Move SI pointer to the next character
      jmp %%comp_loop         ; Return in the loop and check another charachter

   %%check_end:
     cmp bl, '$'              ; Check BL value, if second string finally
     jz %%equal               ; If first and second string equal, go to equal tag

   %%not_equal:
      strcopy %1, false_msg   ; Copy "False" in to Help buffer argument %1
      jmp %%end               ; Exit from tag

   %%equal:
      strcopy %1, true_msg    ; Copy "True" in to Help buffer argument %1

   %%end:
      ; Restore original registers values
   multipop ax, si, di
%endmacro
;-------------------------------------------------------------------------------
%macro substr 4               ; Macros to extract a substring using two number
   
   ; Save registers to preserve their original values
   multipush ax, bx, cx, di, si

   mov di, %1                 ; Set DI to the destination buffer (ouput substring)
   mov si, %2                 ; Set SI to the beginning of the string
   mov ax, %3                 ; Move the first number (starting position) into AX
   mov bx, %4                 ; Move the second number (ending position) into BX

   ; Count the length of the input string
   xor cx, cx                 ; Clear CX (counter)
   push ax                    ; Save AX value temporarily
   push si                    ; Save SI value temporarily

   %%count_loop:
      lodsb                   ; Load the next character from SI into AL
      cmp al, '$'             ; Check if it is the string terminator
      jz %%end_count          ; If yes, exit the loop
      inc cx                  ; Increment the counter
      jmp %%count_loop        ; Repeat the loop
   
   %%end_count:
      pop si                  ; Restore SI to the original string start
      pop ax                  ; Restore AX (starting position)
  
   ; Validate indices (BX < CX and AX < BX)
   cmp bx, cx
   jg %%error                 ; If BX if greater than the string length
                              ; Jump to error
   cmp ax, bx
   jg %%error                 ; If AX is greater than BX, jump to error

   jmp %%continue             ; Otherwise, proceed with substring extraction

   %%continue:
      xor cx, cx              ; Clear CX (counter)
      sub bx, ax              ; Calculate substring length: BX = BX - AX
      inc bx                  ; Adjust to include the last character
      add si, ax              ; Move SI to the starting position of the string
      mov cx, bx              ; Set CX as the loop counter (length of substring)

      %%sub_loop:
         lodsb                ; Load a character from SI into AL, Increment SI
         stosb                ; Store in the destination buffer (DI)
         loop %%sub_loop      ; Repeat for CX times

      mov byte [di], '$'      ; Add end-string character ('$')
      jmp %%end               ; Jump to the end of the macro

   %%error:
      mov byte [di], '$'      ; Set an empty strings in case of an error
      println error_msg       ; Print an error message
      jmp %%end               ; Jump to the end

   %%end:
   ; Restore original registers values
   multipop ax, bx, cx, di, si
%endmacro
;------------------------------------------------------------------------------
