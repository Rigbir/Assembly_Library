# 🏗️ Assembly Library for x86 (i8086)

**Assembly Library for x86** — It is a macro library for the i8086 assembler, designed for user-friendly operation. It simplifies the development of assembly language programs by providing ready-made solutions for basic operations. 

## ✨ Features  
- 🔹 **Easy to use** — minimizes routine in assembly programming.  
- 🔹 **Runs on NASM** — compatible with **Mac OS**, **Linux**, **Windows**.  
- 🔹 **C-like syntax** — makes assembly code more readable.  

## 🛠️ Demonstration  
💡 **Want to see the library in action?**  
📌 Check out the 👉 [**Test Program**](https://github.com/Rigbir/Assembly_Library/blob/main/TestLib.asm), which demonstrates most of the library's functions. 

## 📄 Documentation  

📚 **Explore the full documentation for detailed descriptions of all available macros.**  
🌐 [**Online Documentation**](https://rigbir.github.io/Assembly_Library/) (powered by MkDocs)
🔹 [**English Version**](https://github.com/Rigbir/Assembly_Library/blob/main/docs/README_EN.md)  
🔹 [**Russian Version**](https://github.com/Rigbir/Assembly_Library/blob/main/docs/README_RU.md)  

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
2. **Move the library file to your project folder**:
   ```sh
   mv MarLib.asm /path_to_your_work-folder
   ```
3. **Use library in your code**:
   ```asm
   %include "MarLib.asm"
   ```
4. **Use the macros you need**:
   ```asm
   section .data
      msg db "Hey, this is MarLib function$!"
   section .text
      print msg
   ```
5. **After, compile your file and run**:
   ```sh
   nasm -f bin examples.asm -o examples.com 
  
   dosbox examples.com
   ```

## 💬 Get Involved & Feedback  

💡 Have suggestions, found an issue, or want to improve the library?  
Feel free to contribute, ask questions, or start discussions!  

📌 **Ways to connect:**  
🔹 Open an [Issue](https://github.com/Rigbir/Assembly_Library/issues) to report a bug or suggest an improvement.  
🔹 Start a discussion in the [Discussions](https://github.com/Rigbir/Assembly_Library/discussions) section.  
🔹 Feel free to fork and submit a **Pull Request** with your contributions!  

Your feedback and contributions help make this library better! 🚀  
