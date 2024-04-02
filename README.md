# R2FFT_FPGA

Here is an implemntation of **Radix-2 pipeline FFT on FPGA** with Verilog

Main verilog code is in 'verilog_main', where IPdcp.md list settings of IP core used in this program, including Complex multiplier, FIFO, Block RAM, Block ROM.

Some aided matlab file is in 'matlab_aid'. These files are used for sampled wave generation, twiddle(rotation) factor generation.

Simulation can be done with 'top_tb.v', which will sample a signal $x(t) = \sin(2\pi t) + \sin(4\pi t) + \sin(14\pi t)$ with 32Hz sampling frequency. And matlab aided file will also give a result, which can be compared with result from FPGA simulation.

FFT of this program has **512 inputs**, so it's resolution is fs/512. But it has not been tested on FPGA yet.