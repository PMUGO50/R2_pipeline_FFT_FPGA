`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer:
// 
// Create Date:    13:21:59 03/30/2024 
// Design Name: 
// Module Name:    wnrom 
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
module wnrom
#(
	parameter width=16,
	parameter addrw=6
)
(
	input clk,
	input [addrw-1:0] addr_re,
	input [addrw-1:0] addr_im,
	output signed [width-1:0] wn_re,
	output signed [width-1:0] wn_im
);
	rom_re wnrerom(
		.clka(clk),
		.addra(addr_re),
		.douta(wn_re)
	);
	rom_im wnimrom(
		.clka(clk),
		.addra(addr_im),
		.douta(wn_im)
	);

endmodule
