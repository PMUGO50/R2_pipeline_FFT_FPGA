# R2_pipeline_FFT_FPGA

Here is an implementation of **Radix-2 pipeline FFT on FPGA** with Verilog.

FFT of this program has **512 inputs**, so it's resolution is fs/512. The width of data is **16 and signed**.

The program it has not been tested on FPGA yet, it has just passed the behavioral simulation and RTL synthesis. Summary part of synthesis report is 'topmodule.syr', and explanation to some synthesis warnings is in 'warningexp.md'.

## Implementation code

Main verilog implementation code is in 'verilog_main', where 'IPdcp.md' list settings of IP core used in this program, including Complex multiplier, FIFO, Block RAM, Block ROM.

## Aided MATLAB code

Some aided matlab code is in 'matlab_aid'. These files are used for sampled wave generation, twiddle(rotation) factor generation.

## Testbench code

Testbench code is in 'verilog_tb'. Where simulation can be done with 'top_tb.v'. Sampled signal is rectangular signal with period $T=1\mathrm{s}$ .And sampling frequency is 128Hz.

Testbench will give a result 'fftout_fpga_sim.csv', and 'wave_generator.m' will also give a result 'fftout_matlab.csv'. The two will be compared in 'erroraly.m' to indicate the effectiveness of this program.

'erroraly.m' will plot the result of fft from both matlab and verilog simulation, which is 'fft_pic.png'. Meanwhile, 'erroraly.m' will also use both fft result to do inverse fft and restore sampled wave, which is 'ifft_pic.png'. 

