module sqrt_ctrl
  (
    input  logic        clk_i,
    input  logic        enb_i,
    input  logic [8:0]  s_i,
    input  logic [7:0]  x_i,
    input  logic        valid_i,
    input  logic        ready_o,
    output logic        restart_flag_o,
    output logic        mux_ctrl1_o,
    output logic [1:0]  mux_ctrl2_o,
    output logic        d_en_o,
    output logic        s_en_o,
    output logic        r_en_o,
    output logic        op_en_o,
    output logic        busy_o,
    output logic        valid_o,
    output logic        ready_i
  );

  enum {
    IDLE,
    COMP,
    DSUM,
    SSUM1,
    SSUM2,
    SSUM3,
    SSUM4,
    END
  } state, state_next;

  always_ff @(posedge clk_i, negedge enb_i)
  begin
    if(!enb_i)
      state <= IDLE;
    else
      state <= state_next;
  end

  always_comb
  begin
    unique case(state)
      IDLE:     state_next = (valid_i) ? (COMP) : (IDLE);
      COMP:     state_next = (s_i > x_i) ? (END) : (DSUM);
      DSUM:     state_next = SSUM1;
      SSUM1:    state_next = SSUM2;
      SSUM2:    state_next = SSUM3;
      SSUM3:    state_next = SSUM4;
      SSUM4:    state_next = COMP;
      END:      state_next = IDLE ;
      default:  state_next = (ready_o) ? IDLE : END;
    endcase
  end

  always_comb
  begin
    unique case(state)
      IDLE: // Ambiguo de IDLE e RESTART - Inserindo valores iniciais
      begin
        restart_flag_o  = valid_i;
        mux_ctrl1_o     = 1'b0;
        mux_ctrl2_o     = 2'b00;
        d_en_o          = 1'b0;
        s_en_o          = 1'b0;
        r_en_o          = 1'b0;
        op_en_o         = 1'b0;
        valid_o         = 1'b0;
        ready_i         = 1'b1;     
      end
      COMP: // Bifurcação entre DSUM e END - Inserindo D e 2 nos operandos
      begin
        restart_flag_o  = 1'b0;
        mux_ctrl1_o     = 1'b1;
        mux_ctrl2_o     = 2'b10;
        d_en_o          = 1'b0;
        s_en_o          = 1'b0;
        r_en_o          = 1'b0;
        op_en_o         = 1'b1;
        ready_i         = 1'b0; 
      end
      DSUM: // Inserindo resultado da som em D
      begin
        restart_flag_o  = 1'b0;
        mux_ctrl1_o     = 1'b0;
        mux_ctrl2_o     = 2'b00;
        d_en_o          = 1'b1;
        s_en_o          = 1'b0;
        r_en_o          = 1'b0;
        op_en_o         = 1'b0;
      end  
      SSUM1: // Inserindo S e D nos operandos
      begin
        restart_flag_o  = 1'b0;
        mux_ctrl1_o     = 1'b0;
        mux_ctrl2_o     = 2'b00;
        d_en_o          = 1'b0;
        s_en_o          = 1'b0;
        r_en_o          = 1'b0;
        op_en_o         = 1'b1;
      end     
      SSUM2: // Inserindo resultado da soma em S
      begin
        restart_flag_o  = 1'b0;
        mux_ctrl1_o     = 1'b0;
        mux_ctrl2_o     = 2'b01;
        d_en_o          = 1'b0;
        s_en_o          = 1'b1;
        r_en_o          = 1'b0;
        op_en_o         = 1'b0;
      end
      SSUM3: // Inserindo S + D + 1 nos operandos
      begin
        restart_flag_o  = 1'b0;
        mux_ctrl1_o     = 1'b0;
        mux_ctrl2_o     = 2'b01;
        d_en_o          = 1'b0;
        s_en_o          = 1'b0;
        r_en_o          = 1'b0;
        op_en_o         = 1'b1;
      end
      SSUM4: // Inserindo resultado da soma em S
      begin
        restart_flag_o  = 1'b0;
        mux_ctrl1_o     = 1'b0;
        mux_ctrl2_o     = 2'b01;
        d_en_o          = 1'b0;
        s_en_o          = 1'b1;
        r_en_o          = 1'b0;
        op_en_o         = 1'b0;
      end
      END: // Atualizando valor de R
      begin
        restart_flag_o  = 1'b0;
        mux_ctrl1_o     = 1'b0;
        mux_ctrl2_o     = 2'b00;
        d_en_o          = 1'b0;
        s_en_o          = 1'b0;
        r_en_o          = 1'b1;
        op_en_o         = 1'b0;
        valid_o         = 1'b1;
      end
      default:
      begin
        restart_flag_o  = 1'b0;
        mux_ctrl1_o     = 1'b0;
        mux_ctrl2_o     = 2'b00;
        d_en_o          = 1'b0;
        s_en_o          = 1'b0;
        r_en_o          = 1'b0;
        op_en_o         = 1'b0;
      end
    endcase
  end

  assign busy_o = (state != IDLE);

endmodule