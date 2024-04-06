# R2_pipeline_FFT_FPGA

Here is an implemntation of **Radix-2 pipeline FFT on FPGA** with Verilog.

FFT of this program has **512 inputs**, so it's resolution is fs/512. The width of data is **16 and signed**.

The program it has not been tested on FPGA yet, it has just passed the behavioral simulation and RTL synthesis. Summary part of synthesis report is 'corefft.syr', and explanation to some synthesis warnings is in 'warningexp.md'.

## Implementation code

Main verilog implementation code is in 'verilog_main', where 'IPdcp.md' list settings of IP core used in this program, including Complex multiplier, FIFO, Block RAM, Block ROM.

## Aided MATLAB code

Some aided matlab code is in 'matlab_aid'. These files are used for sampled wave generation, twiddle(rotation) factor generation.

## Testbench code

Testbench code is in 'verilog_tb'. Where simulation can be done with 'top_tb.v'. Sampled signal is $x(t) = 50[\sin(2\pi t) + \sin(14\pi t) + \sin(52\pi t)]$, that is a superposition of 1Hz, 7Hz, 26Hz sine wave. And sampling frequency is 128Hz.

testbench will give a result 'fftout_fpga_sim.csv', and 'wave_generator.m' will also give a result 'fftout_matlab.csv'. The two will be compared in 'erroraly.m' to indicate the effectiveness of this program.

