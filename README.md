# ALU_WITH_ML/MATH_OPERATIONS

This project implements a Custom Arithmetic Logic Unit (ALU) in Verilog, designed not only for traditional operations like addition, subtraction, bitwise logic, but also for machine learning and mathematical functions like MAC (Multiply-Accumulate), ReLU, Sigmoid, Tanh, Absolute value, and more.
Features
Standard ALU Operations:
Addition
Subtraction
Bitwise AND, OR, XOR, NOT
Increment, Decrement

Machine Learning / Mathematical Operations:
MAC (Multiply-Accumulate) - full 2×WIDTH result
ReLU (Rectified Linear Unit)
Sigmoid Activation
Tanh Activation
Absolute Value
Clipping
Squaring

Flag Generation:
Carry Flag
Borrow Flag
Zero Flag

Parameterizable Width:
Default: 8-bit inputs
Output for MAC: 2×WIDTH (16 bits for WIDTH=8)

Synchronous modules with clk, rst, and enable controls where necessary
