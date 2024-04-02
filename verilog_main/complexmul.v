`timescale 1ns / 1ps

module complexmul
#(
	parameter width=16
)
(
	input en,
	input signed [width-1:0] in_re,
	input signed [width-1:0] in_im,
	input signed [width-1:0] wn_re,
	input signed [width-1:0] wn_im,
	output signed [width-1:0] out_re,
	output signed [width-1:0] out_im
);
	wire [79:0] prod;
	
	compmul CM0(
		.s_axis_a_tvalid(en),
		.s_axis_a_tdata({in_im,in_re}),
		.s_axis_b_tvalid(en),
		.s_axis_b_tdata({wn_im,wn_re}),
		.m_axis_dout_tvalid(),
		.m_axis_dout_tdata(prod)
	);
	
	assign out_re = prod[30:15],
		out_im = prod[70:55];
	
endmodule
