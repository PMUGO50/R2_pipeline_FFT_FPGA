`timescale 1ns / 1ps

module fftstg
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

	wire en_ffwr, en_ffrd; //FIFO write and read enable
	wire signed [width-1:0] ff_in_re;
	wire signed [width-1:0] ff_in_im;
	wire signed [width-1:0] ff_out_re;
	wire signed [width-1:0] ff_out_im; //input and output of FIFO
	
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
	
	wire en_cmp; //complex multiplier enable
	wire [M-2:0] cnt_to_addr;
	wire [N-1:0] rt_addr; //rotation factor address
	wire signed [width-1:0] rt_re; 
	wire signed [width-1:0] rt_im; //rotation factor
	wire signed [width-1:0] cmp_in_re;
	wire signed [width-1:0] cmp_in_im; //value to be multiplied
	wire signed [width-1:0] cmp_out_re;
	wire signed [width-1:0] cmp_out_im; //value has been multiplied
	
//////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////FIFO description/////////////////////////////////
	
	assign en_ffwr = en_in,
		en_ffrd = (&cnt_in[M-2:0]) | cnt_in[M-1] | cnt_bf[M-1];
	
	midfifo FFU(
		.clk(clk),
		.areset(~areset),
		.en_wr(en_ffwr),
		.en_rd(en_ffrd),
		.in_re(ff_in_re),
		.in_im(ff_in_im),
		.out_re(ff_out_re),
		.out_im(ff_out_im),
		.full_re(),
		.full_im(),
		.empty_re(),
		.empty_im()
	);
	//FIFO unit between last stg and this stg
	
	assign ff_in_re = (en_bf)? bf_y1_re : xin_re,
		ff_in_im = (en_bf)? bf_y1_im : xin_im;
	//when bf2 is not enabled, just load in data from bf1
	//when bf2 is enabled, load in bf2_y1 for usage of "muliplied by W"

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////butterfly unit description/////////////////////////////
	
	assign en_bf = cnt_in[M-1];
	
	assign bf_x0_re = (en_bf)? ff_out_re : {width{1'b0}},
		bf_x0_im = (en_bf)? ff_out_im : {width{1'b0}},
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
			if(cnt_in==2**(M-1)-1 && en_in) bf_outing <= 1'b1;
			else if(cnt_bf==2**(N)-1) bf_outing <= 1'b0;
			else bf_outing <= bf_outing;
			
			if(bf_outing) cnt_bf <= cnt_bf + 1'b1;
			else cnt_bf <= {N{1'b0}};
		end
	end
	//count output of butterfly unit

//////////////////////////////////////////////////////////////////////////////////
///////////////////////////complex multiplcation unit/////////////////////////////

	assign en_cmp = cnt_bf[M-1];
	//when butterfly output counts to 2*(M-1), enable cmp
	
	assign cmp_in_re = (en_cmp)? ff_out_re : {width{1'b0}},
		cmp_in_im = (en_cmp)? ff_out_im : {width{1'b0}};
	//when cmp enabled, read value from FIFO
	
	assign cnt_to_addr = cnt_bf[M-2:0]+ 1'b1,
		rt_addr = cnt_to_addr<<(N-M);
	//rotation factor address is proportional to cnt_bf[M-2:0]
	//here 1'b1 represents that load behavior is ahead of multiplication
	
	wnrom WNGEN(
		.clk(clk),
		.addr_re(rt_addr),
		.addr_im(rt_addr),
		.wn_re(rt_re),
		.wn_im(rt_im)
	);
	//get rotation factor from ROM
	
	complexmul CMP(
		.en(en_cmp),
		.in_re(cmp_in_re),
		.in_im(cmp_in_im),
		.wn_re(rt_re),
		.wn_im(rt_im),
		.out_re(cmp_out_re),
		.out_im(cmp_out_im)
	);
	//main complex multipiler
	
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
			if(cnt_bf[M-1]) begin
				yout_re <= cmp_out_re;
				yout_im <= cmp_out_im;
			end
			else begin
				yout_re <= bf_y0_re;
				yout_im <= bf_y0_im;
			end
		end
	end

endmodule
