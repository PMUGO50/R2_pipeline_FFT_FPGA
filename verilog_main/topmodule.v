`timescale 1ns / 1ps
`include "fftpara.v"

module topmodule(
	input clk, //40MHz
	input areset,
	input din_en,
	input signed [`WIDTH-1:0] din_ad,
	output dout_en,
	output [`NALL-1:0] dout_cnt,
	output signed [`WIDTH-1:0] dout_re,
	output signed [`WIDTH-1:0] dout_im
);

	reg signed [`WIDTH-1:0] dcore;
	reg en_core;
	reg [`NALL-1:0] cnt_core;
	
	always @(posedge clk, negedge areset) begin
		if(!areset) begin
			dcore <= {`WIDTH{1'b0}};
			en_core <= 1'b0;
			cnt_core <= {`NALL{1'b1}};
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
	defparam u_corefft.width = `WIDTH;
	defparam u_corefft.NALL = `NALL; //point=512
	defparam u_corefft.fdiv = `FDIV;
	defparam u_corefft.scale0 = `SCALE0;
	defparam u_corefft.scale1 = `SCALE1;
	defparam u_corefft.scale2 = `SCALE2;
	defparam u_corefft.scale3 = `SCALE3;
	defparam u_corefft.scale4 = `SCALE4;
	defparam u_corefft.scale5 = `SCALE5;
	defparam u_corefft.scale6 = `SCALE6;
	defparam u_corefft.scale7 = `SCALE7;
	defparam u_corefft.scale8 = `SCALE8;
endmodule
