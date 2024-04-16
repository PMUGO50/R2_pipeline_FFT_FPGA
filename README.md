# R2_pipeline_FFT_FPGA

Here is an implementation of **Radix-2 pipeline FFT on FPGA** with Verilog.

FFT of this program has **512 inputs**, so it's resolution is fs/512. The width of data is **16 and signed**.

The program it has not been tested on FPGA yet, it has just passed the behavioral simulation and RTL synthesis. Summary part of synthesis report is 'topmodule.syr', and explanation to some synthesis warnings is in 'warningexp.md'.

本仓库是用 Verilog 对基2 FFT 在 FPGA 上的实现。

本程序的 FFT 是 **512 点**的，分辨率为采样频率的 1/512 ，全程数据位宽是 **16 位符号数**。

本程序暂时还未通过上板测试，只是通过了行为级仿真与逻辑综合。综合报告的总结部分放在 'topmodule.syr' 中，对综合过程中出现的 warning 在 'warningexp.md' 中有解释。

## Implementation code

Main verilog implementation code is in 'verilog_main', where 'IPdcp.md' list settings of IP core used in this program, including Complex multiplier, FIFO, Block RAM, Block ROM.

Verilog 主程序代码在 'verilog_main' 中，其中 'IPdcp.md' 列出了所用到的 IP 核的配置，包括复数乘法器，FIFO ，BRAM ，BROM 。

## Aided MATLAB code

Some aided MATLAB code is in 'matlab_aid'. These files are used for sampled wave generation, twiddle(rotation) factor generation.

一些辅助的 MATLAB 代码在 'matlab_aid' 中。这些文件是用来生成测试波形和旋转因子的。

## Testbench code

Testbench code is in 'verilog_tb', where simulation can be done with 'top_tb.v'. Sampled signal is rectangular signal with frequency $f_0=1\mathrm{MHz}$ .And **sampling frequency is $f_s=40\mathrm{MHz}$, which is also clock frequency of FPGA in testbench**.

Testbench will give a result 'fftout_fpga_sim.csv'.  'postchecker.m' will post-process the csv and plot frequency spectrum.

仿真代码在 'verilog_tb' 中，可以启动 'top_tb.v' 来完成仿真。采样信号是一个频率为 $f_0=1\mathrm{MHz}$ 的方波信号。**采样频率是 $f_s=40\mathrm{MHz}$ ，也是测试的 FPGA 的时钟频率**。

仿真文件将给出一个仿真结果 'fftout_fpga_sim.csv' ，'postchecker.m' 将对其进行后处理并画出频谱图。

