`timescale 1ns / 1ps

module top_tb;
	parameter width=16;
	parameter N=9;
	parameter halfT_oa = 10; //period=20ns, freq=50MHz
	
	reg clk;
	reg areset;
	reg signed [width-1:0] din_ad;
	reg din_en;
	wire dout_en;
	wire [N-1:0] dout_cnt;
	wire signed [width-1:0] dout_re, dout_im;
	
	reg signed [width-1:0] dtest [(2**N-1):0];
	integer i, fw;
	
	topmodule uut (
		.clk(clk),
		.areset(areset),
		.din_en(din_en),
		.din_ad(din_ad),
		.dout_en(dout_en),
		.dout_cnt(dout_cnt),
		.dout_re(dout_re),
		.dout_im(dout_im)
	);
	
	initial #(3200*halfT_oa) $stop;

	initial begin
		clk <= 1;
		forever #(halfT_oa) clk <= ~clk;
	end
	
	initial begin
		areset <= 1;
		#(halfT_oa); areset <= 0;
		#(halfT_oa); areset <= 1;
	end
	
	initial $readmemh("wavesamp.txt", dtest);
	initial begin
		#(20*halfT_oa+1); din_en <= 1;
		//As datasheet says, after FIFO reset, it needs a few clock period to get out of 'RESET state', so input mustn't be enabled in these periods.
		
		for(i=0;i<(2**N);i=i+1) begin
			din_ad <= dtest[i];
			#(2*halfT_oa);
		end
		din_ad <= {width{1'b0}};
		din_en <= 0;
	end
	
	initial fw = $fopen("fftout_fpga_sim.csv", "w");
	always @(posedge clk) begin
		if(dout_en) $fwrite(fw, "%d,%d,%d\n", dout_cnt, dout_re, dout_im);
		else;
	end
	
endmodule

