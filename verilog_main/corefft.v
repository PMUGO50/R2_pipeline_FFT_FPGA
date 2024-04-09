`timescale 1ns / 1ps

module corefft
#(
	parameter width=16,
	parameter NALL=9 //2^9=512
)
(
	input clk,
	input areset,
	input din_en,
	input signed [width-1:0] din,
	input [NALL-1:0] din_cnt,
	output dout_en,
	output [NALL-1:0] dout_cnt,
	output signed [width-1:0] dout_re,
	output signed [width-1:0] dout_im
);
	
	wire mod0_out_en, mod1_out_en, mod2_out_en,
		mod3_out_en, mod4_out_en, mod5_out_en,
		mod6_out_en, mod7_out_en, mod8_out_en;
		
	wire [NALL-1:0] mod0_out_cnt, mod1_out_cnt, mod2_out_cnt,
		mod3_out_cnt, mod4_out_cnt, mod5_out_cnt,
		mod6_out_cnt, mod7_out_cnt, mod8_out_cnt;
		
	wire signed [width-1:0] mod0_out_re, mod0_out_im,
		mod1_out_re, mod1_out_im,
		mod2_out_re, mod2_out_im,
		mod3_out_re, mod3_out_im,
		mod4_out_re, mod4_out_im,
		mod5_out_re, mod5_out_im,
		mod6_out_re, mod6_out_im,
		mod7_out_re, mod7_out_im,
		mod8_out_re, mod8_out_im;
	
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////fft stage instance//////////////////////////////////
	
	fftstg mod0(
		.clk(clk),
		.areset(areset),
		.en_in(din_en),
		.cnt_in(din_cnt),
		.xin_re(din),
		.xin_im({width{1'b0}}),
		.en_out(mod0_out_en),
		.cnt_out(mod0_out_cnt),
		.yout_re(mod0_out_re),
		.yout_im(mod0_out_im)
	);
	defparam mod0.width = width;
	defparam mod0.N = NALL; //point=512
	defparam mod0.M = NALL; //resolution=512
	
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
	defparam mod1.N = NALL; //point=512
	defparam mod1.M = (NALL-1); //resolution=256
	
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
	defparam mod2.N = NALL; //point=512
	defparam mod2.M = (NALL-2); //resolution=128
	
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
	defparam mod3.N = NALL; //point=512
	defparam mod3.M = (NALL-3); //resolution=64
	
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
	defparam mod4.N = NALL; //point=512
	defparam mod4.M = (NALL-4); //resolution=32
	
	fftstg mod5(
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
	defparam mod5.N = NALL; //point=512
	defparam mod5.M = (NALL-5); //resolution=16
	
	fftstg mod6(
		.clk(clk),
		.areset(areset),
		.en_in(mod5_out_en),
		.cnt_in(mod5_out_cnt),
		.xin_re(mod5_out_re),
		.xin_im(mod5_out_im),
		.en_out(mod6_out_en),
		.cnt_out(mod6_out_cnt),
		.yout_re(mod6_out_re),
		.yout_im(mod6_out_im)
	);
	defparam mod6.width = width;
	defparam mod6.N = NALL; //point=512
	defparam mod6.M = (NALL-6); //resolution=8
	
	fftstg mod7(
		.clk(clk),
		.areset(areset),
		.en_in(mod6_out_en),
		.cnt_in(mod6_out_cnt),
		.xin_re(mod6_out_re),
		.xin_im(mod6_out_im),
		.en_out(mod7_out_en),
		.cnt_out(mod7_out_cnt),
		.yout_re(mod7_out_re),
		.yout_im(mod7_out_im)
	);
	defparam mod7.width = width;
	defparam mod7.N = NALL; //point=512
	defparam mod7.M = (NALL-7); //resolution=4
	
	fftstg_fn mod8(
		.clk(clk),
		.areset(areset),
		.en_in(mod7_out_en),
		.cnt_in(mod7_out_cnt),
		.xin_re(mod7_out_re),
		.xin_im(mod7_out_im),
		.en_out(mod8_out_en),
		.cnt_out(mod8_out_cnt),
		.yout_re(mod8_out_re),
		.yout_im(mod8_out_im)
	);
	defparam mod8.width = width;
	defparam mod8.N = NALL; //point=512
	defparam mod8.M = (NALL-8); //resolution=2
	
//////////////////////////////////////////////////////////////////////////////////
///////////////////////////////output rearranger//////////////////////////////////

	reage out_reager(
		.clk(clk),
		.areset(areset),
		.en_fft(mod8_out_en),
		.cnt_fft(mod8_out_cnt),
		.din_ram_re(mod8_out_re),
		.din_ram_im(mod8_out_im),
		
		.enout(dout_en),
		.cnt_ram_out(dout_cnt),
		.dout_ram_re(dout_re),
		.dout_ram_im(dout_im)
	);
	defparam out_reager.width = width;
	defparam out_reager.N = NALL; //point=512
	
endmodule
