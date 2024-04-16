`timescale 1ns / 100ps

module top_tb;
	parameter width=16;
	parameter N=9;
	parameter fdiv=24'd10;
	parameter halfT_oa = 0.5; //actual clock: period=25ns, freq=40MHz
	
	reg clk;
	reg areset;
	reg signed [width-1:0] din_ad;
	reg din_en;
	wire dout_en;
	wire [N-1:0] dout_cnt;
	wire signed [width-1:0] dout_re, dout_im;
	
	reg signed [width-1:0] dtest [(2**N-1):0];
	reg [N-1:0] index;
	integer fw;
	
	topmodule
	#(
		.width(width),
		.NALL(N),
		.fdiv(fdiv)
	)
	uut (
		.clk(clk),
		.areset(areset),
		.din_en(din_en),
		.din_ad(din_ad),
		.dout_en(dout_en),
		.dout_cnt(dout_cnt),
		.dout_re(dout_re),
		.dout_im(dout_im)
	);
	
	initial #(40000*halfT_oa) $stop;

	initial begin
		clk <= 1'b1;
		forever #(halfT_oa) clk <= ~clk;
	end
	
	initial begin
		areset <= 1'b1;
		#(halfT_oa) areset <= 1'b0;
		#(halfT_oa) areset <= 1'b1;
	end
	
	initial $readmemh("wavesamp.txt", dtest);
	initial begin
		#(20*halfT_oa+1) din_en <= 1'b1; 
		//As datasheet says, after FIFO reset, it needs a few clock period to get out of 'RESET state', so input mustn't be enabled in these periods.
		index = {N{1'b1}};
		forever begin
			din_ad <= dtest[index];
			index <= index + 1'b1;
			#(2*halfT_oa);
		end
	end
	
	wire signed [31:0] tout_en, tout_cnt, tout_re, tout_im;
	assign tout_en = {1'b0, dout_en, 30'd0},
		tout_cnt = {1'b0, dout_cnt, 22'd0},
		tout_re = {dout_re, 16'd0},
		tout_im = {dout_im, 16'd0};
	
	initial fw = $fopen("fftout_fpga_sim.csv", "w");
	always @(dout_cnt, dout_en) begin
		if(din_en) $fwrite(fw, "%d,%d,%d,%d\n", tout_cnt, tout_re, tout_im, tout_en);
		else;
	end
	
endmodule

