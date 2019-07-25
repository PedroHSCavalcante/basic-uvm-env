module sqrt (
  input logic clk_i,
  input logic rstn_i,
  input logic enb_i,
  input logic [7:0] dt_i,
  output logic [7:0] dt_o
);

  logic [4:0] d;
  logic [8:0] s;

  logic [4:0] d_reg;
  logic [7:0] s_reg;

  logic [1:0] state;

  logic [7:0] dt_i_old;

  always_comb begin
    case (state)
      
      2'b00: begin
        d = 2;
        s = 4;
      end

      2'b01: begin
        d = d_reg + 2;
        s = s_reg + d_reg + 3;
      end
      
      2'b10: begin
        d = d_reg;
        s = s_reg;
      end
      
      2'b11: begin
        s = s_reg;
        d = d_reg;
      end
    endcase
  end

  always_ff @ (posedge clk_i or negedge rstn_i) begin
    if(!rstn_i) begin
      state <= 0;
      dt_o <= 0;
      d_reg <= 0;
      s_reg <= 0;
      dt_i_old <= 0;
    end
    else begin
      if(enb_i) begin
        if(dt_i == 0) begin
          dt_o <= 0;
        end
        else begin
          case (state)
            2'b00: begin
              if(s > dt_i) begin
                state <= 2'b11;
              end
              else begin
                state <= 2'b01;
              end
              d_reg <= d;
              s_reg <= s;

              dt_i_old <= dt_i;
            end
            2'b01: begin
              if(s > dt_i) begin
                state <= 2'b11;
              end 
              d_reg <= d;
              s_reg <= s;
            end
            2'b11: begin
              d_reg <= d;
              s_reg <= s;
              dt_o <= d/2;

              if(dt_i_old != dt_i)
                state <= 2'b00;
            end
            default: begin
              state <= 2'b00;
            end
          endcase
        end
      end
      else begin
        state <= 2'b00;
        dt_o <= dt_o;
      end
    end
  end
endmodule