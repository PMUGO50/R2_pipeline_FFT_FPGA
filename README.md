# R2_pipeline_FFT_FPGA

Here is an implementation of **Radix-2 pipeline FFT on FPGA** with Verilog.

FFT of this program has **512 inputs**, so it's resolution is fs/512. The width of data is **16 and signed**.

**Note that input amplitude can not be too large. As an example, if input is $A\sin(2\pi f_0 t)$, then $A$ should be smaller than around 550**, otherwise an overflow will occur.

- [x] Behavioral simulation

- [x] RTL systhesis

- [x] FPGA board test

- [ ] Try to solve overflow problem with a self-adaptative method

Summary part of synthesis report is 'topmodule.syr', and explanation to some synthesis warnings is in 'warningexp.md'.

本仓库是用 Verilog 对基2 FFT 在 FPGA 上的实现。

本程序的 FFT 是 **512 点**的，分辨率为采样频率的 1/512 ，全程数据位宽是 **16 位符号数**。

**注意输入信号的幅值不能太大。一个例子是，如果输入 $A\sin(2\pi f_0 t)$, 那么 $A$ 应当小于 550 左右**，否则会有数据溢出现象。

- [x] 通过行为仿真

- [x] 通过逻辑综合

- [x] 通过上板测试

- [ ] 尝试自适应解决数据溢出问题

综合报告的总结部分放在 'topmodule.syr' 中，对综合过程中出现的 warning 在 'warningexp.md' 中有解释。

## Implementation code

Main verilog implementation code is in 'verilog_main', where 'IPdcp.md' list settings of IP core used in this program, including Complex multiplier, FIFO, Block RAM, Block ROM.

Verilog 主程序代码在 'verilog_main' 中，其中 'IPdcp.md' 列出了所用到的 IP 核的配置，包括复数乘法器，FIFO ，BRAM ，BROM 。

## Aided MATLAB code

Some aided MATLAB code is in 'matlab_aid'. This MATLAB file is used for sampled, twiddle(rotation) factor generation.

一些辅助的 MATLAB 代码在 'twiddle_gen' 中。这个 MATLAB 文件是用来生成旋转因子的。

## Testbench code

Testbench code is in 'verilog_tb', where simulation can be done with 'top_tb.v'. Sampled signal can be generated from 'wave_generator.m'.And **sampling frequency is $f_s=40\mathrm{MHz}$, which is also clock frequency of FPGA in testbench**.

Testbench will give a result 'fftout_fpga_sim.csv'.  'postchecker.m' will post-process the csv and plot frequency spectrum.

When sampled signal is rectangular signal with frequency $f_0=1\mathrm{MHz}$ , simulation result is 'fft_amplitude.png' here.

仿真代码在 'verilog_tb' 中，可以启动 'top_tb.v' 来完成仿真。采样信号可以由 'wave_generator.m' 生成。**采样频率是 $f_s=40\mathrm{MHz}$ ，也是测试的 FPGA 的时钟频率**。

仿真文件将给出一个仿真结果 'fftout_fpga_sim.csv' ，'postchecker.m' 将对其进行后处理并画出频谱图。

当采样信号是一个频率为 $f_0=1\mathrm{MHz}$ 的方波信号时，仿真结果是这里的 'fft_amplitude.png'。
