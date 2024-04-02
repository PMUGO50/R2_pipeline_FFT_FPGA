`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer:
// 
// Create Date:    10:51:13 03/30/2024 
// Design Name: 
// Module Name:    butterfly 
// Project Name: R2_FFT
// Target Devices: UNKNOWN
// Tool versions: ISE14.7
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module butterfly
#(
	parameter width=16
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
	assign out0_re = in0_re + in1_re,
		out0_im = in0_im + in1_im,
		out1_re = in0_re - in1_re,
		out1_im = in0_im - in1_im;
endmodule
