%include "convert.asm"

section .text
   org 100h

start:
   ; Prompt user for input (prints "Input: ")
   print msg_in                ; Output: "Input: "
   read_int my_num             ; User input: 23
   
   ; Add 100 (from the num variable) to the input and store the result in my_num
   movzx ax, byte [num]        ; Load the number 100
   add ax, [my_num]            ; Add the input value (23)
   mov [my_num], ax            ; Store the result in my_num
   
   ; Print the result of the addition: "Result: 123"
   print msg_out               ; Output: "Result: "
   int_to_str some, my_num     ; Convert the number to string
   print some                   ; Output: "123"

   ; Convert the string "514$" into an integer
   str_to_int num_str, my_num  ; Convert the string to an integer (514)
   
   ; Add 100 to the number and store the result in my_num
   movzx ax, byte [num]        ; Load 100
   add ax, [my_num]            ; Add 514
   mov [my_num], ax            ; Result: 614

   ; Print the new result: "Result: 614"
   println msg_out             ; Output: "Result: "
   int_to_str some, my_num     ; Convert 614 to string
   print some                   ; Output: "614"

   ; Print the strings "first second third"
   print_inline msg_1, msg_2, msg_3 ; Output: "first second third"

   ; Print the strings "fourth fifth sixth"
   print_multi msg_4, msg_5, msg_6 ; Output: "fourth fifth sixth"

   ; Concatenate the strings msg_7, msg_8, and msg_9: "paradise"
   concat special, msg_7, msg_8, msg_9 ; Output: "paradise"
   print special

   ; Concatenate the strings msg_10, msg_11, and msg_12: "you really cooool :)"
   concat special, msg_10, msg_11, msg_12 ; Output: "you really cooool :)"
   print special

   ; Print the character '2'
   mov dl, '2'
   print_char dl              ; Output: "2"

   ; Print the character '3'
   print_char '3'             ; Output: "3"

   ; Print the character '1'
   mov dl, '1'
   print_char dl              ; Output: "1"
   
   ; Calculate the length of the string "length string" and print it
   strlen some, msg_13        ; Output: "13"
   println some

   ; Print the string "length string"
   println msg_13             ; Output: "length string"

   ; Copy the string "length string" to buffer_copy
   strcopy buffer_copy, msg_13
   println buffer_copy         ; Output: "length string"

   ; Compare the strings msg_14 and msg_2 ("some$" and "second$")
   strcmp special, msg_14, msg_2 ; Output: "False"

   ; Apply substring to msg_16: "example$" starting from position 6, length 4
   substr for_sub_str, msg_16, 6, 4 ; Output: "Error!"
   println for_sub_str

   ; Convert the number to binary format and print it
   int_to_bin [num_int], buffer_bin  ; Output: "1011000010101111"
   print buffer_bin

   ret

section .data
   msg_in db "Input: $"          ; Input prompt
   msg_out db "Result: $"        ; Result prompt

   msg_1 db "first$"
   msg_2 db "second$"
   msg_3 db "third$"

   msg_4 db "fourth$"
   msg_5 db "fifth$"
   msg_6 db "sixth$"

   msg_7 db 13, 10, "par$"      ; String with a newline before "par"
   msg_8 db "ad$"
   msg_9 db "ise$"

   %define my_strs msg_7, msg_8, msg_9
   
   msg_10 db 13, 10, "you $"
   msg_11 db "really $"
   msg_12 db "cooool :)$"
   msg_13 db "length string$"   ; Example string for length calculation

   msg_14 db "some$"
   msg_15 db "some$"
   
   msg_16 db "example$"        ; String for substring

   %define my_strs_2 msg_10, msg_11, msg_12

   num_str db "514$"           ; String to convert to number
   num_int dw 45231            ; Example number to convert to string
                     
   num db 100                  ; Number for addition

section .bss
   buffer_copy resb 256        ; Buffer for copying strings
   some resb 6                 ; Buffer for storing string result
   special resb 5              ; Buffer for storing concatenated results
   for_sub_str resb 15         ; Buffer for substring
   buffer_bin resb 17          ; Buffer for binary string
   my_num dw ?                 ; Variable for storing calculation results







































