`timescale 1ns / 1ps

module midfifo
#(
	parameter width=16,
	parameter depth=512
)
(
	input clk,
	input areset,
	input en_wr,
	input en_rd,
	input signed [width-1:0] in_re,
	input signed [width-1:0] in_im,
	output signed [width-1:0] out_re,
	output signed [width-1:0] out_im,
	output full_re,
	output full_im,
	output empty_re,
	output empty_im
);
	//FIFO with first-word-fall-through
	fifo FRE(
		.clk(clk),
		.rst(areset),
		.wr_en(en_wr),
		.din(in_re),
		.rd_en(en_rd),
		.dout(out_re),
		.full(full_re),
		.empty(empty_re)
	);
	
	fifo FIM(
		.clk(clk),
		.rst(areset),
		.wr_en(en_wr),
		.din(in_im),
		.rd_en(en_rd),
		.dout(out_im),
		.full(full_im),
		.empty(empty_im)
	);
	
endmodule
