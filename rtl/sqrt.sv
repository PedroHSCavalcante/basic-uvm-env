module sqrt
  (
    input  logic        clk_i,
    input  logic        enb_i,
    input  logic [7:0]  dt_i,
    input  logic        valid_i,
    input  logic        ready_o,
    output logic        busy_o,
    output logic [7:0]  dt_o,
    output logic        valid_o,
    output logic        ready_i
  );

  logic clk_gated_w;

  assign clk_gated_w = clk_i && enb_i;

  logic [8:0] s_w;
  logic [7:0] x_w;
  logic       restart_flag_w;
  logic       mux_ctrl1_w;
  logic [1:0] mux_ctrl2_w;
  logic       d_en_w;
  logic       s_en_w;
  logic       r_en_w;
  logic       op_en_w;

  sqrt_ctrl SQRT_CTRL
  (
    .clk_i            (clk_gated_w      ),
    .enb_i            (enb_i            ),
    .s_i              (s_w              ),
    .x_i              (x_w              ),
    .valid_i          (valid_i          ),
    .ready_o          (ready_o          ),
    .restart_flag_o   (restart_flag_w   ),
    .mux_ctrl1_o      (mux_ctrl1_w      ),
    .mux_ctrl2_o      (mux_ctrl2_w      ),
    .d_en_o           (d_en_w           ),
    .s_en_o           (s_en_w           ),
    .r_en_o           (r_en_w           ),
    .op_en_o          (op_en_w          ),
    .busy_o           (busy_o           ),
    .valid_o          (valid_o          ),
    .ready_i          (ready_i          )
  );

  sqrt_proc SQRT_PROC 
  (
    .clk_i            (clk_gated_w      ),
    .dt_i             (dt_i             ),
    .restart_flag_i   (restart_flag_w   ),
    .mux_ctrl1_i      (mux_ctrl1_w      ),
    .mux_ctrl2_i      (mux_ctrl2_w      ),
    .d_en_i           (d_en_w           ),
    .s_en_i           (s_en_w           ),
    .r_en_i           (r_en_w           ),
    .op_en_i          (op_en_w          ),
    .s_o              (s_w              ),
    .x_o              (x_w              ),
    .dt_o             (dt_o             )
  );

endmodule

