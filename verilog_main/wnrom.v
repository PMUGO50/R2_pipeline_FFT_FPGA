`timescale 1ns / 1ps

module wnrom
#(
	parameter width=16,
	parameter addrw=9
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
