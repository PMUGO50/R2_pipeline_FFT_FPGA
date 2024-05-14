`timescale 1ns / 1ps

module reage
#(
	parameter width=16,
	parameter N=9,
	parameter fdiv=24'd400000
)
(
	input clk, //40MHz
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
	reg [23:0] freq_cnt; //make output data hold for (400000/40M) = (1/100) second
	
	assign addr_rd[N-1] = reage_cnt[0],
		addr_rd[N-2] = reage_cnt[1],
		addr_rd[N-3] = reage_cnt[2],
		addr_rd[N-4] = reage_cnt[3],
		addr_rd[N-5] = reage_cnt[4],
		addr_rd[N-6] = reage_cnt[5],
		addr_rd[N-7] = reage_cnt[6],
		addr_rd[N-8] = reage_cnt[7],
		addr_rd[N-9] = reage_cnt[8];
	
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
		if(!areset) enout <= 1'b0;
		else begin
			if(&cnt_fft) enout <= 1'b1;//that is cnt_fft==9'd511
			else if(reage_cnt[N]) enout <= 1'b0;
			else enout <= enout;
		end
	end
	
	always @(posedge clk, negedge areset) begin
		if(!areset) begin
			reage_cnt <= 1'b0;
			freq_cnt <= 24'd0;
		end
		else begin
			if(enout) begin
				if(freq_cnt==fdiv) begin
					reage_cnt <= reage_cnt + 1'b1;
					freq_cnt <= 24'd0;
				end
				else freq_cnt <= freq_cnt + 24'd1;
			end
			else begin
				reage_cnt <= 1'b0;
				freq_cnt <= 24'd0;
			end
		end
	end
	assign cnt_ram_out = reage_cnt - 1'b1;
endmodule
