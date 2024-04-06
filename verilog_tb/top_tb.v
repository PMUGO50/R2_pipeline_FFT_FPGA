`timescale 1ns / 1ps

module top_tb;
	parameter width=16;
	parameter N=9;
	
	reg clk;
	reg areset;
	reg signed [width-1:0] din;
	reg din_en;
	wire dout_en;
	wire [N-1:0] dout_cnt;
	wire signed [width-1:0] dout_re, dout_im;
	
	reg signed [width-1:0] dtest [(2**N-1):0];
	integer i, fw;
	
	corefft uut (
		.clk(clk),
		.areset(areset),
		.din_en(din_en),
		.din_re(din),
		.din_im({width{1'b0}}),
		.dout_en(dout_en),
		.dout_cnt(dout_cnt),
		.dout_re(dout_re),
		.dout_im(dout_im)
	);
	
	initial #32000 $stop;

	initial begin
		clk <= 1;
		forever begin
			#10;
			clk <= ~clk;
		end
	end
	
	initial begin
		areset <= 1;
		#20; areset <= 0;
		#20; areset <= 1;
	end
	
	initial $readmemh("wavesamp.txt", dtest);
	initial begin
		#41; din_en <= 1;
		for(i=0;i<(2**N-1);i=i+1) begin
			din <= dtest[i];
			#20;
		end
		din <= {width{1'b0}};
		din_en <= 0;
	end
	
	initial fw = $fopen("fftout_fpga_sim.csv", "w");
	always @(posedge clk) begin
		if(dout_en) $fwrite(fw, "%d,%d,%d\n", dout_cnt, dout_re, dout_im);
		else;
	end
	
endmodule

