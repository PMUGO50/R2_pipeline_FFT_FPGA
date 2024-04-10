`timescale 1ns / 1ps
module topmodule
#(
	parameter width=16,
	parameter NALL=9
)
(
	input clk,
	input areset,
	input din_en,
	input signed [width-1:0] din_ad,
	output dout_en,
	output [NALL-1:0] dout_cnt,
	output signed [width-1:0] dout_re,
	output signed [width-1:0] dout_im
);

	reg signed [width-1:0] dcore;
	reg en_core;
	reg [NALL-1:0] cnt_core;
	
	always @(posedge clk, negedge areset) begin
		if(!areset) begin
			dcore <= {width{1'b0}};
			en_core <= 1'b0;
			cnt_core <= {NALL{1'b1}};
		end
		else if (din_en) begin
			dcore <= din_ad;
			en_core <= din_en;
			cnt_core <= cnt_core + 1'b1;
		end
		else begin
			en_core <= din_en;
		end
	end
	
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
