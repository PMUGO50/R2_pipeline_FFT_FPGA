`timescale 1ns / 1ps

module fftstg_fn
#(
	parameter width=16,
	parameter N=9,
	parameter M=9
)
(
	input clk,
	input areset,
	input en_in,
	input [N-1:0] cnt_in,
	input signed [width-1:0] xin_re,
	input signed [width-1:0] xin_im,
	output reg en_out,
	output reg [N-1:0] cnt_out,
	output reg signed [width-1:0] yout_re,
	output reg signed [width-1:0] yout_im
);

//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////variable definition/////////////////////////////////

	reg signed [width-1:0] reg_out_re;
	reg signed [width-1:0] reg_out_im; //output of register
	
	wire en_bf; //butterfly unit enable
	wire signed [width-1:0] bf_x0_re;
	wire signed [width-1:0] bf_x0_im;
	wire signed [width-1:0] bf_x1_re;
	wire signed [width-1:0] bf_x1_im; //input to butterfly unit
	wire signed [width-1:0] bf_y0_re;
	wire signed [width-1:0] bf_y0_im;
	wire signed [width-1:0] bf_y1_re;
	wire signed [width-1:0] bf_y1_im; //output from butterfly unit
	reg [N-1:0] cnt_bf;
	reg bf_outing;
	
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////register description////////////////////////////////

	always @(posedge clk, negedge areset) begin
		if(!areset) begin
			reg_out_re <= {N{1'b0}};
			reg_out_im <= {N{1'b0}};
		end
		else begin
			if(en_bf) begin
				reg_out_re <= bf_y1_re;
				reg_out_im <= bf_y1_im;
			end
			else begin
				reg_out_re <= xin_re;
				reg_out_im <= xin_im;
			end
		end
	end
	//

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////butterfly unit description/////////////////////////////
	
	assign en_bf = cnt_in[M-1];
	
	assign bf_x0_re = (en_bf)? reg_out_re : {width{1'b0}},
		bf_x0_im = (en_bf)? reg_out_im : {width{1'b0}},
		bf_x1_re = (en_bf)? xin_re : {width{1'b0}},
		bf_x1_im = (en_bf)? xin_im : {width{1'b0}};
		
	butterfly BFU(
		.in0_re(bf_x0_re),
		.in0_im(bf_x0_im),
		.in1_re(bf_x1_re),
		.in1_im(bf_x1_im),
		.out0_re(bf_y0_re),
		.out0_im(bf_y0_im),
		.out1_re(bf_y1_re),
		.out1_im(bf_y1_im)
	);
	//main butterfly unit of 2stgfft
	
	always @(posedge clk, negedge areset) begin
		if(!areset) begin
			cnt_bf <= {N{1'b0}};
			bf_outing <= 1'b0;
		end
		else begin
			if(en_in) bf_outing <= 1'b1;
			else if(cnt_bf==2**(N)-1) bf_outing <= 1'b0;
			else bf_outing <= bf_outing;
			
			if(bf_outing) cnt_bf <= cnt_bf + 1'b1;
			else cnt_bf <= {N{1'b0}};
		end
	end
	//count output of butterfly unit
	
//////////////////////////////////////////////////////////////////////////////////
////////////////////////////////output buffer unit////////////////////////////////
	
	always @(posedge clk, negedge areset) begin
		if(!areset) begin
			en_out <= 1'b0;
			cnt_out <= {N{1'b0}};
			yout_re <= {width{1'b0}};
			yout_im <= {width{1'b0}};
		end
		else begin
			en_out <= bf_outing;
			cnt_out <= cnt_bf;
			if(en_bf) begin
				yout_re <= bf_y0_re;
				yout_im <= bf_y0_im;
			end
			else begin
				yout_re <= reg_out_re;
				yout_im <= reg_out_im;
			end
		end
	end

endmodule
