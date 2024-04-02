`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer:
// 
// Create Date:    13:01:57 03/25/2024
// Design Name: 
// Module Name:    corefft 
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
module corefft
#(
	parameter width=16,
	parameter NALL=6
)
(
	input clk,
	input areset,
	input din_en,
	input signed [width-1:0] din_re,
	input signed [width-1:0] din_im,
	output dout_en,
	output [NALL-1:0] dout_cnt,
	output signed [width-1:0] dout_re,
	output signed [width-1:0] dout_im
);

	reg signed [width-1:0] mod0_in_re, mod0_in_im;
	reg mod0_in_en;
	reg [NALL-1:0] mod0_in_cnt;
	
	wire mod0_out_en, mod1_out_en, mod2_out_en,
		mod3_out_en, mod4_out_en, mod5_out_en;
		
	wire [NALL-1:0] mod0_out_cnt, mod1_out_cnt, mod2_out_cnt,
		mod3_out_cnt, mod4_out_cnt, mod5_out_cnt;
		
	wire signed [width-1:0] mod0_out_re, mod0_out_im,
		mod1_out_re, mod1_out_im,
		mod2_out_re, mod2_out_im,
		mod3_out_re, mod3_out_im,
		mod4_out_re, mod4_out_im,
		mod5_out_re, mod5_out_im;
		
//////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////input buffer/////////////////////////////////////
	
	always @(posedge clk, negedge areset) begin
		if(!areset) begin
			mod0_in_re <= 16'd0;
			mod0_in_im <= 16'd0;
			mod0_in_en <= 1'b0;
			mod0_in_cnt <= {NALL{1'b0}};
		end
		else begin
			mod0_in_re <= din_re;
			mod0_in_im <= din_im;
			mod0_in_en <= din_en;
			if(mod0_in_en) mod0_in_cnt <= mod0_in_cnt + 1'b1;
			else mod0_in_cnt <= {NALL{1'b0}};
		end
	end
	
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////fft stage instance//////////////////////////////////
	
	fftstg mod0(
		.clk(clk),
		.areset(areset),
		.en_in(mod0_in_en),
		.cnt_in(mod0_in_cnt),
		.xin_re(mod0_in_re),
		.xin_im(mod0_in_im),
		.en_out(mod0_out_en),
		.cnt_out(mod0_out_cnt),
		.yout_re(mod0_out_re),
		.yout_im(mod0_out_im)
	);
	defparam mod0.width = width;
	defparam mod0.N = NALL; //point=64
	defparam mod0.M = NALL; //resolution=64
	
	fftstg mod1(
		.clk(clk),
		.areset(areset),
		.en_in(mod0_out_en),
		.cnt_in(mod0_out_cnt),
		.xin_re(mod0_out_re),
		.xin_im(mod0_out_im),
		.en_out(mod1_out_en),
		.cnt_out(mod1_out_cnt),
		.yout_re(mod1_out_re),
		.yout_im(mod1_out_im)
	);
	defparam mod1.width = width;
	defparam mod1.N = NALL; //point=64
	defparam mod1.M = (NALL-1); //resolution=32
	
	fftstg mod2(
		.clk(clk),
		.areset(areset),
		.en_in(mod1_out_en),
		.cnt_in(mod1_out_cnt),
		.xin_re(mod1_out_re),
		.xin_im(mod1_out_im),
		.en_out(mod2_out_en),
		.cnt_out(mod2_out_cnt),
		.yout_re(mod2_out_re),
		.yout_im(mod2_out_im)
	);
	defparam mod2.width = width;
	defparam mod2.N = NALL; //point=64
	defparam mod2.M = (NALL-2); //resolution=16
	
	fftstg mod3(
		.clk(clk),
		.areset(areset),
		.en_in(mod2_out_en),
		.cnt_in(mod2_out_cnt),
		.xin_re(mod2_out_re),
		.xin_im(mod2_out_im),
		.en_out(mod3_out_en),
		.cnt_out(mod3_out_cnt),
		.yout_re(mod3_out_re),
		.yout_im(mod3_out_im)
	);
	defparam mod3.width = width;
	defparam mod3.N = NALL; //point=64
	defparam mod3.M = (NALL-3); //resolution=8
	
	fftstg mod4(
		.clk(clk),
		.areset(areset),
		.en_in(mod3_out_en),
		.cnt_in(mod3_out_cnt),
		.xin_re(mod3_out_re),
		.xin_im(mod3_out_im),
		.en_out(mod4_out_en),
		.cnt_out(mod4_out_cnt),
		.yout_re(mod4_out_re),
		.yout_im(mod4_out_im)
	);
	defparam mod4.width = width;
	defparam mod4.N = NALL; //point=64
	defparam mod4.M = (NALL-4); //resolution=4
	
	fftstg_fn mod5(
		.clk(clk),
		.areset(areset),
		.en_in(mod4_out_en),
		.cnt_in(mod4_out_cnt),
		.xin_re(mod4_out_re),
		.xin_im(mod4_out_im),
		.en_out(mod5_out_en),
		.cnt_out(mod5_out_cnt),
		.yout_re(mod5_out_re),
		.yout_im(mod5_out_im)
	);
	defparam mod5.width = width;
	defparam mod5.N = NALL; //point=64
	defparam mod5.M = (NALL-5); //resolution=2
	
//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////output rearranger//////////////////////////////////

	reage out_reager(
		.clk(clk),
		.areset(areset),
		.en_fft(mod5_out_en),
		.cnt_fft(mod5_out_cnt),
		.din_ram_re(mod5_out_re),
		.din_ram_im(mod5_out_im),
		
		.enout(dout_en),
		.cnt_ram_out(dout_cnt),
		.dout_ram_re(dout_re),
		.dout_ram_im(dout_im)
	);
	
endmodule
