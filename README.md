# Assembly Library for x86 (i8086)

**Assembly Library for x86** — It is a macro library for the i8086 assembler, designed for user-friendly operation. It simplifies the development of assembly language programs by providing ready-made solutions for basic operations. 

## 🔧 A minimal overview of the features

- 📌 Input and Output of strings (`print`, `println`, `print_multi`, `print_inline`)
- 📌 Operations with strings (`strlen`, `strcopy`, `strcmp`, `substr`, `concat`)
- 📌 Various conversions (`int_to_str`, `str_to_int`, `int_to_bin`)
- 📌 And other features

## 🚀 Installation and use

1. **Clone this repository**:
   ```sh
   git clone https://github.com/Rigbir/Assembly_Library.git
   ```
   **Move the library file to your project folder**:
   ```sh
   mv MarLib.asm /path_to_your_work-folder
   ```
   **Use library in your code**:
   ```asm
   %include "MarLib.asm"
   ```
   **Use the macros you need**:
   ```asm
   section .data
      msg db "Hey, this is MarLib function$!"
   section .text
      print msg
   ```
  **After, compile your file and run**:
  ```sh
  nasm -f bin examples.asm -o examples.com 
  
  dosbox examples.com
  ```
