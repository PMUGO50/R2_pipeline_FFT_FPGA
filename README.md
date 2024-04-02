# R2_pipeline_FFT_FPGA

Here is an implemntation of **Radix-2 pipeline FFT on FPGA** with Verilog.

FFT of this program has **512 inputs**, so it's resolution is fs/512. The width of data is **16 and signed**.

The program it has not been tested on FPGA yet, it has just passed the behavioral simulation and RTL synthesis. Synthesis report is 'corefft.syr', and explanation to warnings in report is in 'warningexp.md'.

## program code

Main verilog code is in 'verilog_main', where 'IPdcp.md' list settings of IP core used in this program, including Complex multiplier, FIFO, Block RAM, Block ROM.

Some aided matlab file is in 'matlab_aid'. These files are used for sampled wave generation, twiddle(rotation) factor generation.

## simulation

Simulation can be done with 'top_tb.v'. Sampled signal is $x(t) = 50[\sin(2\pi t) + \sin(14\pi t) + \sin(52\pi t)]$, that is a superposition of 1Hz, 7Hz, 26Hz sine wave. And sampling frequency is 128Hz.

testbench will give a result, and 'wave_generator.m' will also give a result. The two can be compared to indicate the effectiveness of this program.

