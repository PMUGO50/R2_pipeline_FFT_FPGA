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

## Aided MATLAB code

Some aided MATLAB code is in 'matlab_aid'. This MATLAB file is used for sampled, twiddle(rotation) factor generation.

一些辅助的 MATLAB 代码在 'twiddle_gen' 中。这个 MATLAB 文件是用来生成旋转因子的。

## Testbench code

Testbench code is in 'verilog_tb', where simulation can be done with 'top_tb.v'. Here input signal for testbench is a rectangular signal with frequency $f_0=1\mathrm{MHz}$, **whose sampling frequency is $f_s=40\mathrm{MHz}$, which is also clock frequency of FPGA in testbench**.

Testbench will give a result 'fftout_fpga_sim.csv'. 'postchecker.m' will post-process the csv and plot frequency spectrum, which is 'FPGAFFT_RECT.png' here.

仿真代码在 'verilog_tb' 中，可以启动 'top_tb.v' 来完成仿真。这里 testbench 的输入信号是一个频率为 $f_0=1\mathrm{MHz}$ 的方波信号，**采样该信号的频率是 $f_s=40\mathrm{MHz}$ ，也是测试的 FPGA 的时钟频率**。

testbench 将给出一个仿真结果 'fftout_fpga_sim.csv' ，'postchecker.m' 将对其进行后处理并画出频谱图，即这里的 'FPGAFFT_RECT.png'。
