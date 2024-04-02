`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer:
// 
// Create Date:    18:02:32 03/31/2024 
// Design Name: 
// Module Name:    reage 
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
module reage
#(
	parameter width=16,
	parameter N=6
)
(
	input clk,
	input areset,
	input en_fft,
	input [N-1:0] cnt_fft,
	input signed [width-1:0] din_ram_re,
	input signed [width-1:0] din_ram_im,
	
	output reg enout,
	output [N-1:0] cnt_ram_out,
	output signed [width-1:0] dout_ram_re,
	output signed [width-1:0] dout_ram_im
);
	wire wea;
	wire [N-1:0] addr;
	wire [N-1:0] addr_rd;
	reg [N:0] reage_cnt;
	assign addr_rd[N-1] = reage_cnt[0],
		addr_rd[N-2] = reage_cnt[1],
		addr_rd[N-3] = reage_cnt[2],
		addr_rd[N-4] = reage_cnt[3],
		addr_rd[N-5] = reage_cnt[4],
		addr_rd[N-6] = reage_cnt[5];
	
	assign wea = en_fft & (!enout);
	assign addr = (wea)? cnt_fft : addr_rd;
	
	outram ram_re(
		.addra(addr),
		.dina(din_ram_re),
		.wea(wea),
		.clka(clk),
		.douta(dout_ram_re)
	);
	
	outram ram_im(
		.addra(addr),
		.dina(din_ram_im),
		.wea(wea),
		.clka(clk),
		.douta(dout_ram_im)
	);
	
	always @(posedge clk, negedge areset) begin
		if(!areset) begin
			enout <= 1'b0;
			reage_cnt <= 1'b0;
		end
		else begin
			if(&cnt_fft) enout <= 1'b1;//that is cnt_fft==6'd63
			else if(reage_cnt[N]) enout <= 1'b0;
			else enout <= enout;
			
			if(enout) reage_cnt <= reage_cnt + 1'b1;
			else reage_cnt <= 1'b0;
		end
	end
	assign cnt_ram_out = reage_cnt - 1'b1;
endmodule
