`timescale 1ns / 1ps

module top_tb;
	parameter width=16;
	parameter N=9;
	parameter halfT_oa = 10; //period=20ns, freq=50MHz
	parameter halfT_ad = 50; //period=100ns, freq=10MHz
	
	reg clk;
	reg areset;
	reg clk_ad;
	reg signed [width-1:0] din_ad;
	reg en_ad;
	wire dout_en;
	wire [N-1:0] dout_cnt;
	wire signed [width-1:0] dout_re, dout_im;
	
	reg signed [width-1:0] dtest [(2**N-1):0];
	integer i, fw;
	
	topmodule uut (
		.clk(clk),
		.areset(areset),
		.clk_ad(clk_ad),
		.en_ad(en_ad),
		.din_ad(din_ad),
		.dout_en(dout_en),
		.dout_cnt(dout_cnt),
		.dout_re(dout_re),
		.dout_im(dout_im)
	);
	
	initial #(1100*halfT_ad+3200*halfT_oa) $stop;

	initial begin
		clk <= 1;
		forever begin
			#(halfT_oa);
			clk <= ~clk;
		end
	end
	
	initial begin
		clk_ad <= 1;
		forever begin
			#(halfT_ad);
			clk_ad <= ~clk_ad;
		end
	end
	
	initial begin
		areset <= 1;
		#(halfT_ad); areset <= 0;
		#(halfT_ad); areset <= 1;
	end
	
	initial $readmemh("wavesamp.txt", dtest);
	initial begin
		#(20*halfT_ad+1); en_ad <= 1;
		//As datasheet says, after FIFO reset, it needs a few clock period to get out of 'RESET state', so input mustn't be enabled in these periods.
		
		for(i=0;i<(2**N-1);i=i+1) begin
			din_ad <= dtest[i];
			#(2*halfT_ad);
		end
		din_ad <= dtest[2**N-1]; #(2*halfT_ad);
		din_ad <= {width{1'b0}};
		en_ad <= 0;
	end
	
	initial fw = $fopen("fftout_fpga_sim.csv", "w");
	always @(posedge clk) begin
		if(dout_en) $fwrite(fw, "%d,%d,%d\n", dout_cnt, dout_re, dout_im);
		else;
	end
	
endmodule

