


## `read_int` 

**Description** 

Reads an integer from the keyboard. Input ends when the Enter key (Carriage Return) is pressed. The entered characters must be digits from '0' to '9'. The final number is stored in the specified variable.

**Arguments**

| Parametrs | Description |
|-----------|-------------|
| **%1**    | Address of the variable where the entered integer will be stored. |

**Usage Example**

```asm
section .data
   user_input dw 0

section .text
   read_int user_input
```

## `str_to_int` 

**Description**

Converts a string representing an integer into an int value. The string must end with $ and contain only digits from '0' to '9'.

**Arguments **

| Parametrs | Description  |
|-----------|--------------|
| **%1**    | Address of the string to be converted. |
| **%2**    | Address of the variable where the integer will be stored.|

**Usage Example**

```asm
section .data
   num_str db "123$", 0
   result dw 0

section .text
   str_to_int num_str, result
```

## `int_to_str`

**Description**

Converts an integer into an ASCII string. The number can be passed in one of the registers (`AX`, `BX`, `DX`) or as a memory address. The result is stored in string format in the specified buffer, with the string ending in `$`.

**Arguments**

| Parameter | Description |
|----------|--------------|
| **%1**   | Address of the buffer where the string representing the number will be stored. |
| **%2**   | Register or memory address containing the integer to be converted. Allowed values: `AX`, `BX`, `DX`, or a memory address. |

**Usage Example**

```asm
section .data
   buffer db 10, 0 ; String buffer, must be large enough
   number dw 1234   ; Number to be converted

section .text
   int_to_str buffer, number
```

## `int_to_bin`

**Description**

Converts an integer (up to 5 digits) into a binary string. The result is stored in string format in the specified buffer. Each bit of the number is represented by the character '0' or '1'. The string is terminated by the null character `$`.

**Arguments**

| Parameter | Description |
|-----------|-------------|
| **%1**    | Address of the integer to be converted to binary format. |
| **%2**    | Address of the buffer where the result (binary string) will be written. |

**Example usage**

```asm
section .data
   number dw 12345        ; Example number for conversion
   bin_result db 17, 0    ; Buffer to store the binary string (16 bits + 1 for null character $)

section .text
   int_to_bin number, bin_result
```

