`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: N/A
// Engineer:
//
// Create Date:   20:01:46 03/29/2024
// Design Name:   corefft
// Module Name:   top_tb.v
// Project Name:  R2_FFT
// Target Device:  UNKNOWN
// Tool versions:  ISE14.7
// Description: 
//
// Verilog Test Fixture created by ISE for module: corefft
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_tb;
	reg clk;
	reg areset;
	reg signed [15:0] din;
	reg din_en;
	wire dout_en;
	wire [5:0] dout_cnt;
	wire signed [15:0] dout_re, dout_im;
	
	wire signed [15:0] dtest [63:0];
	integer i;
	
	corefft uut (
		.clk(clk),
		.areset(areset),
		.din_en(din_en),
		.din_re(din),
		.din_im(16'd0),
		.dout_en(dout_en),
		.dout_cnt(dout_cnt),
		.dout_re(dout_re),
		.dout_im(dout_im)
	);
	
	assign dtest[0]=16'd1559,
		dtest[1]=16'd1472,
		dtest[2]=16'd648,
		dtest[3]=16'd1000,
		dtest[4]=16'd2311,
		dtest[5]=16'd2555,
		dtest[6]=16'd1168,
		dtest[7]=16'd0,
		dtest[8]=16'd403,
		dtest[9]=16'd1141,
		dtest[10]=16'd463,
		dtest[11]=-16'd1000,
		dtest[12]=-16'd1200,
		dtest[13]=16'd58,
		dtest[14]=16'd793,
		dtest[15]=16'd0,
		dtest[16]=-16'd793,
		dtest[17]=-16'd58,
		dtest[18]=16'd1200,
		dtest[19]=16'd1000,
		dtest[20]=-16'd463,
		dtest[21]=-16'd1141,
		dtest[22]=-16'd403,
		dtest[23]=16'd0,
		dtest[24]=-16'd1168,
		dtest[25]=-16'd2555,
		dtest[26]=-16'd2311,
		dtest[27]=-16'd1000,
		dtest[28]=-16'd648,
		dtest[29]=-16'd1472,
		dtest[30]=-16'd1559,
		dtest[31]=16'd0,
		dtest[32]=16'd1559,
		dtest[33]=16'd1472,
		dtest[34]=16'd648,
		dtest[35]=16'd1000,
		dtest[36]=16'd2311,
		dtest[37]=16'd2555,
		dtest[38]=16'd1168,
		dtest[39]=16'd0,
		dtest[40]=16'd403,
		dtest[41]=16'd1141,
		dtest[42]=16'd463,
		dtest[43]=-16'd1000,
		dtest[44]=-16'd1200,
		dtest[45]=16'd58,
		dtest[46]=16'd793,
		dtest[47]=16'd0,
		dtest[48]=-16'd793,
		dtest[49]=-16'd58,
		dtest[50]=16'd1200,
		dtest[51]=16'd1000,
		dtest[52]=-16'd463,
		dtest[53]=-16'd1141,
		dtest[54]=-16'd403,
		dtest[55]=16'd0,
		dtest[56]=-16'd1168,
		dtest[57]=-16'd2555,
		dtest[58]=-16'd2311,
		dtest[59]=-16'd1000,
		dtest[60]=-16'd648,
		dtest[61]=-16'd1472,
		dtest[62]=-16'd1559,
		dtest[63]=16'd0;


	initial #2400 $stop;

	initial begin
		clk <= 1;
		forever begin
			#5;
			clk <= ~clk;
		end
	end
	
	initial begin
		areset <= 1;
		#10; areset <= 0;
		#10; areset <= 1;
	end
	
	initial begin
		#21; din_en <= 1;
		for(i=0;i<64;i=i+1) begin
			din <= dtest[i];
			#10;
		end
		din <= 16'd0;
		din_en <= 0;
	end
	
endmodule

