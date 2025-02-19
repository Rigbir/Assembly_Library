# Welcome to the MarLib Assembly Documentation! 🚀

## About the Library  
**MarLib** is a collection of useful functions written in **NASM assembly for i8086**, designed for working with numbers, strings, and input/output operations.  
It simplifies low-level programming by providing ready-to-use tools for everyday tasks.

## Features (just a few of them)  
✅ Simplified number and string input/output  
✅ Conversion between numeric and string formats  
✅ Basic memory operations  
✅ Optimized algorithms for fast execution 
 
## How to use?  
1) Include the library in your project. 

```assembly
%include "MarLib.asm"
``` 

2) Call the required function as described in the documentation.  

```assembly
section .data
   user_input dw 0

section .text
   read_int user_input
```

3) Compile and run your program in **DOS/DOSBox + NASM**.  

```
nasm -f bin my_program.asm -o my_program.com

dosbox my_program.com
```


## 📬 Feedback 

If you have any questions, suggestions, or feedback on improving the library, feel free to contact me:

📧 **Email:** [m.brezin@yandex.ru](mailto:m.brezin@yandex.ru)  
🐙 **GitHub Issues:** [Открыть обращение](https://github.com/Rigbir/Assembly_Library/issues)  

I appreciate your feedback and suggestions! 🚀  
