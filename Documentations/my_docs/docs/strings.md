## Functions for Strings
<details>
<summary style="font-size: 18px; font-weight: bold; color: #0077cc; padding: 10px; margin-bottom: 15px; cursor: pointer;">Expand the list</summary>

  <ul style="margin-top: 10px;">
    <li style="margin-bottom: 8px;"><a href="#print" style="text-decoration: none; color: #0077cc;">print</a></li>
    <li style="margin-bottom: 8px;"><a href="#println" style="text-decoration: none; color: #0077cc;">println</a></li>
    <li style="margin-bottom: 8px;"><a href="#print_multi" style="text-decoration: none; color: #0077cc;">print_multi</a></li>
    <li style="margin-bottom: 8px;"><a href="#print_inline" style="text-decoration: none; color: #0077cc;">print_inline</a></li>
    <li style="margin-bottom: 8px;"><a href="#print_char" style="text-decoration: none; color: #0077cc;">print_char</a></li>
    <li style="margin-bottom: 8px;"><a href="#concat" style="text-decoration: none; color: #0077cc;">concat</a></li>
    <li style="margin-bottom: 8px;"><a href="#strlen" style="text-decoration: none; color: #0077cc;">strlen</a></li>
    <li style="margin-bottom: 8px;"><a href="#strcopy" style="text-decoration: none; color: #0077cc;">strcopy</a></li>
    <li style="margin-bottom: 8px;"><a href="#strcmp" style="text-decoration: none; color: #0077cc;">strcmp</a></li>
    <li style="margin-bottom: 8px;"><a href="#substr" style="text-decoration: none; color: #0077cc;">substr</a></li>
  </ul>

</details>

## `print` {#print}

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

## `print_multi` {#print_multi}

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

## `print_inline` {#print_inline}

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

## `print_char` {#print_char}

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

## `concat` {#concat}

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

## `strlen` {#strlen}

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

## `strcopy` {#strcmp}

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

## `strcmp` {#strcmp}

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

## `substr` {#substr}

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
