module sqrt_proc
	(
    input  logic        clk_i,
		input  logic [7:0]	dt_i,
    input  logic        restart_flag_i,
    input  logic        mux_ctrl1_i,
    input  logic [1:0]  mux_ctrl2_i,
		input  logic				d_en_i,
		input  logic				s_en_i,
    input  logic        r_en_i,
		input  logic				op_en_i,
    output logic [8:0]  s_o,
    output logic [7:0]  x_o,
		output logic [7:0]	dt_o
	);

	logic [4:0]	d_r;
	logic [8:0] s_r;
	logic [7:0] x_r;
  logic [3:0] r_r;

	localparam D_TWO = 8'd2;
	localparam S_ONE = 8'd1;

	logic [7:0]	mux_output1_w;
  logic [7:0] mux_output2_w;
	logic [7:0] operand1_r;
	logic [7:0] operand2_r;
	logic [8:0] sum_result_w;

	always_ff @(posedge clk_i)
	begin
		if(restart_flag_i)
			d_r <= 5'h02;
		else if(d_en_i)
			d_r <= sum_result_w;
	end

	always_ff @(posedge clk_i)
	begin
		if(restart_flag_i)
			s_r <= 9'h04;
		else if(s_en_i)
			s_r <= sum_result_w;
	end

  always_ff @(posedge clk_i)
  begin 
    if(restart_flag_i)
      x_r <= dt_i;
  end

  always_ff @(posedge clk_i)
  begin
    if(restart_flag_i)
      r_r <= 8'h00;
    else if(r_en_i)
      r_r <= d_r >> 1;
  end

	always_comb
	begin
		unique case(mux_ctrl1_i)
			1'b0:		  mux_output1_w = s_r;
			1'b1:		  mux_output1_w = d_r;
		endcase
	end

  always_comb
  begin
    unique case(mux_ctrl2_i)
      2'b00:    mux_output2_w = d_r;
      2'b01:    mux_output2_w = S_ONE;
      2'b10:    mux_output2_w = D_TWO;
      default:  mux_output2_w = 8'h00;
    endcase
  end

	always_ff @(posedge clk_i)
	begin
		if(op_en_i)
    begin
			operand1_r <= mux_output1_w;
      operand2_r <= mux_output2_w;
    end
	end

	assign sum_result_w = operand1_r + operand2_r;

  assign s_o = s_r;
  assign x_o = x_r;
  assign dt_o = (x_r == 8'h00) ? (8'h00) : (r_r);

endmodule