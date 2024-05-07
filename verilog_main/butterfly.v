`timescale 1ns / 1ps

module butterfly
#(
	parameter width=16,
	parameter scale=0
)
(
	input signed [width-1:0] in0_re,
	input signed [width-1:0] in0_im,
	input signed [width-1:0] in1_re,
	input signed [width-1:0] in1_im,
	output signed [width-1:0] out0_re,
	output signed [width-1:0] out0_im,
	output signed [width-1:0] out1_re,
	output signed [width-1:0] out1_im
);
	wire signed [width-1:0] mid0_re, mid0_im, mid1_re, mid1_im;
	
	assign mid0_re = in0_re + in1_re,
		mid0_im = in0_im + in1_im,
		mid1_re = in0_re - in1_re,
		mid1_im = in0_im - in1_im;
	
	assign out0_re = {{scale{mid0_re[width-1]}}, mid0_re[width-1:scale]},
		out0_im = {{scale{mid0_im[width-1]}}, mid0_im[width-1:scale]},
		out1_re = {{scale{mid1_re[width-1]}}, mid1_re[width-1:scale]},
		out1_im = {{scale{mid1_im[width-1]}}, mid1_im[width-1:scale]};
endmodule
