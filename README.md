# R2_pipeline_FFT_FPGA

Here is an implementation of **Radix-2 pipeline FFT on FPGA** with Verilog.

FFT of this program has **512 inputs**, so it's resolution is fs/512. The width of data is **16 and signed**. Output frequency can be changed by adjust FDIV in 'fftpara.v', which satisfies $f_{out} = f_{clk}/\mathrm{FDIV}$.

- [x] Behavioral simulation

- [x] RTL systhesis

- [x] FPGA board test

- [X] Solve overflow by scaling data

Summary part of synthesis report is 'topmodule.syr'.

本仓库是用 Verilog 对基2 FFT 在 FPGA 上的实现。

本程序的 FFT 是 **512 点**的，分辨率为采样频率的 1/512 ，全程数据位宽是 **16 位符号数**。可以通过调整 'fftpara.v' 中的 FDIV 来调整输出频率，二者的关系是 $f_{out} = f_{clk}/\mathrm{FDIV}$ 。

- [x] 通过行为仿真

- [x] 通过逻辑综合

- [x] 通过上板测试

- [X] 通过缩放数据解决溢出问题

综合报告的总结部分是 'topmodule.syr'。

## Implementation code

Main verilog implementation code is in 'verilog_main', where 'IPdcp.md' list settings of IP core used in this program, including Complex multiplier, FIFO, Block RAM, Block ROM.

Verilog 主程序代码在 'verilog_main' 中，其中 'IPdcp.md' 列出了所用到的 IP 核的配置，包括复数乘法器，FIFO ，BRAM ，BROM 。

Some aided MATLAB code is in 'matlab_aid'. This MATLAB file is used for sampled, twiddle(rotation) factor generation.

一些辅助的 MATLAB 代码在 'twiddle_gen' 中。这个 MATLAB 文件是用来生成旋转因子的。

## Simulation and Test

Testbench code is 'verilog_tb/top_tb.v'. Input signalis a sine signal with frequency $f_0=S\mathrm{MHz}$, **whose sampling frequency is $f_s=40\mathrm{MHz}$, which is also clock frequency of FPGA in testbench**. Simu result is 'behavior_sim.png'.

Board test result is 'board_test.png'.

仿真代码是 'verilog_tb/top_tb.v'。输入信号是一个频率为 $f_0=5\mathrm{MHz}$ 的正弦信号，**采样该信号的频率是 $f_s=40\mathrm{MHz}$ ，也是测试的 FPGA 的时钟频率**。仿真结果是 'behavior_sim.png'。

上板测试结果是 'board_test.png'。
