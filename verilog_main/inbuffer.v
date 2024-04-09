`timescale 1ns / 1ps
module inbuffer
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
	output signed [width-1:0] dcore,
	output reg en_core,
	output reg [NALL-1:0] cnt_core
);
	reg [NALL:0] cnt_ad;
	reg en_core_pre;
	
	fifoin INBUFF(
		.wr_clk(clk_ad),
		.rd_clk(clk),
		.rst(~areset),
		.wr_en(en_ad),
		.din(din_ad),
		.rd_en(en_core_pre),
		.dout(dcore),
		.full(),
		.empty()
	);
	
	always @(posedge clk_ad, negedge areset) begin
		if(!areset) cnt_ad <= {(NALL+1){1'b0}};
		else if(cnt_ad[NALL]) cnt_ad <= 1'b1; 
		else if(en_ad) cnt_ad <= cnt_ad + 1'b1;
		else;
	end
	
	always @(posedge clk, negedge areset) begin
		if(!areset) begin
			cnt_core <= {NALL{1'b0}};
			en_core <= 1'b0;
			en_core_pre <= 1'b0;
		end
		else if(&cnt_core) begin
			en_core <= 1'b0;
			en_core_pre <= 1'b0;
			cnt_core <= {NALL{1'b0}};
		end
		else if(en_core) cnt_core <= cnt_core + 1'b1;
		else if(en_core_pre) en_core <= en_core_pre;
		else if(cnt_ad[NALL]) en_core_pre <= 1'b1;
		else;
	end
endmodule
