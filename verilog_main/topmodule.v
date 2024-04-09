`timescale 1ns / 1ps
module topmodule
#(
	parameter width=16,
	parameter NALL=9
)
(
	input clk,
	input areset,
	input clk_ad,
	input en_ad,
	input signed [width-1:0] din_ad,
	output dout_en,
	output [NALL-1:0] dout_cnt,
	output signed [width-1:0] dout_re,
	output signed [width-1:0] dout_im
);

	wire signed [width-1:0] dcore;
	wire en_core;
	wire [NALL-1:0] cnt_core;
	
	inbuffer u_inbuffer(
		.clk(clk),
		.areset(areset),
		.clk_ad(clk_ad),
		.en_ad(en_ad),
		.din_ad(din_ad),
		.dcore(dcore),
		.en_core(en_core),
		.cnt_core(cnt_core)
	);
	defparam u_inbuffer.width = width;
	defparam u_inbuffer.NALL = NALL; //point=512
	
	corefft u_corefft(
		.clk(clk),
		.areset(areset),
		.din_en(en_core),
		.din(dcore),
		.din_cnt(cnt_core),
		.dout_en(dout_en),
		.dout_cnt(dout_cnt),
		.dout_re(dout_re),
		.dout_im(dout_im)
	);
	defparam u_corefft.width = width;
	defparam u_corefft.NALL = NALL; //point=512
endmodule
