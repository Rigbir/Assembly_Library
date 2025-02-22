# Library Capabilities Overview

## Functions for work with Numbers

<details>
<summary>Open the list</summary>

## `read_int`

### Description
Reads an integer from the keyboard. Input ends when the Enter key (Carriage Return) is pressed. The entered characters must be digits from '0' to '9'. The final number is stored in the specified variable.

### Arguments
| Parametrs | Description |
|-----------|-------------|
| **%1**    | Address of the variable where the entered integer will be stored. |

### Usage Example
```assembly
section .data
   user_input dw 0

section .text
   read_int user_input
```

## `str_to_int`

### Description
Converts a string representing an integer into an int value. The string must end with $ and contain only digits from '0' to '9'.

### Arguments
| Parametrs | Description |
|-----------|--------------|
| **%1**    | Address of the string to be converted. |
| **%2**    | Address of the variable where the integer will be stored.|

### Usage Example
```assembly
section .data
   num_str db "123$", 0
   result dw 0

section .text
   str_to_int num_str, result
```

## `int_to_str`

### Description
Converts an integer into an ASCII string. The number can be passed in one of the registers (`AX`, `BX`, `DX`) or as a memory address. The result is stored in string format in the specified buffer, with the string ending in `$`.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1**   | Address of the buffer where the string representing the number will be stored. |
| **%2**   | Register or memory address containing the integer to be converted. Allowed values: `AX`, `BX`, `DX`, or a memory address. |

### Usage Example
```assembly
section .data
   buffer db 10, 0 ; String buffer, must be large enough
   number dw 1234   ; Number to be converted

section .text
   int_to_str buffer, number
```

## `int_to_bin`

### Description
Converts an integer (up to 5 digits) into a binary string. The result is stored in string format in the specified buffer. Each bit of the number is represented by the character '0' or '1'. The string is terminated by the null character `$`.

### Arguments
| Parameter | Description |
|-----------|-------------|
| **%1**    | Address of the integer to be converted to binary format. |
| **%2**    | Address of the buffer where the result (binary string) will be written. |

### Example usage
```assembly
section .data
   number dw 12345        ; Example number for conversion
   bin_result db 17, 0    ; Buffer to store the binary string (16 bits + 1 for null character $)

section .text
   int_to_bin number, bin_result
```

</details>

## Functions for work with Strings

<details>
<summary>Open the list</summary>

## `print`

### Description
Prints a string to the screen using the DOS function for string output. The string must end with the `$` character.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1**   | Address of the string to be printed. |

### Usage Example
```assembly
section .data
   message db "Hello, world!$", 0

section .text
   print message
```

## `println`

### Description
Prints a string to the screen and adds a newline after the output. Uses the `print` macro for output and the `newline` macro for a new line.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1**   | Address of the string to be printed with a newline. |

### Usage Example
```assembly
section .data
   message db "Hey!$", 0

section .text
   println message
```

## `print_multi`

### Description
Prints multiple strings to the screen. Uses the `println` macro to print each string with a newline. Supports a variable number of arguments and requires at least two arguments.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1, %2, ...** | Variable number of strings to be printed. |

### Usage Example
```assembly
section .data
   msg1 db "Hello,", 0
   msg2 db "world!", 0
   msg3 db "How are you?", 0

section .text
   print_multi msg1, msg2, msg3
```

## `print_inline`

### Description
Prints multiple strings in a single line, separating them with spaces. Each argument is printed with a space between them, except for the last one. Supports a variable number of arguments and requires at least two arguments.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1, %2, ...** | Variable number of strings to be printed in one line, separated by spaces. |

### Usage Example
```assembly
section .data
   msg1 db "Hello,", 0
   msg2 db "world!", 0
   msg3 db "How are you?", 0

section .text
   print_inline msg1, msg2, msg3
```

## `print_char`

### Description
Prints a character to the screen followed by a newline. First prints a newline (Carriage Return and Line Feed), then prints the specified character.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1**   | Character to be printed. |

### Usage Example
```assembly
section .data
   char db 'A'  ; Character to print

section .text
   print_char char
```

## `concat`

### Description
Concatenates two or more string arguments into a single string. The result is stored in the first provided parameter, which must be a buffer for storing the result. Each string must end with the `$` character.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1**   | Address of the buffer where the concatenated string will be stored. |
| **%2, %3, ...** | Strings to concatenate. Each string must end with `$`. |

### Usage Example
```assembly
section .data
   str1 db "Hello$", 0
   str2 db "World$", 0
   result db 100 dup(0) ; Buffer for result

section .text
   concat result, str1, str2
```

## `strlen`

### Description
Calculates the length of a string, including only characters up to the first `$` character. The result is stored in the variable passed as the first argument. The string must end with `$`.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1**   | Address of the variable where the string length (integer) will be stored. |
| **%2**   | Address of the string whose length is to be calculated. The string must end with `$`. |

### Usage Example
```assembly
section .data
   my_str db "Hello$", 0
   length dw 0

section .text
   strlen length, my_str
```

## `strcopy`

### Description
Copies the content of the second string into the first string. Both strings must end with the `$` character. The second string is copied into the first, including the end-of-string `$` character.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1**   | Address of the first buffer where the string will be copied. |
| **%2**   | Address of the second buffer (string) whose content will be copied. |

### Usage Example
```assembly
section .data
   str1 db "Old string$", 0
   str2 db "New string$", 0

section .text
   strcopy str1, str2
```

## `strcmp`

### Description
Compares two strings and stores the comparison result (whether they are equal or not) in a buffer (must be at least 5 bytes). Both strings must end with the `$` character. If the strings are equal, `"True"` is copied into the buffer; otherwise, `"False"` is copied.

### Arguments
| Parameter | Description |
|----------|----------|
| **%1**   | Address of the buffer where the comparison result will be stored. |
| **%2**   | Address of the first string to compare. |
| **%3**   | Address of the second string to compare with the first. |

### Usage Example
```assembly
section .data
   result db 5
   str1 db "Hello$", 0
   str2 db "Hello$", 0

section .text
   strcmp result, str1, str2
```

## `substr`

### Description
Extracts a substring from a string using two numbers that indicate the start and end positions. If the indices are incorrect (e.g., the end index is greater than the length of the string or the start index is greater than the end), an empty string is written to the buffer, and an error message is displayed.

### Arguments
| Parameter | Description |
|-----------|-------------|
| **%1**    | Address of the buffer where the substring will be written. |
| **%2**    | Address of the source string from which the substring will be extracted. |
| **%3**    | Start position of the substring (index of the first character to extract). |
| **%4**    | End position of the substring (index of the last character to include in the substring). |

### Example usage
```assembly
section .data
   str db "Hello, World$", 0
   result db 10, 0
   error_msg db "Invalid indices!", 0

section .text
   substr result, str, 7, 12
```

</details>
