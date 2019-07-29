module top;
  import uvm_pkg::*;
  import pkg::*;
  
  logic clk;
  logic rst;
  
  initial begin
    clk = 1;
    rst = 1;
    #20 rst = 0;
    #20 rst = 1;
  end
  
  always #10 clk = !clk;
  
  input_if in(.clk(clk), .rst(rst));
  output_if out(.clk(clk), .rst(rst));
  
  sqrt sqrt(.clk_i(clk),
            .enb_i(in.enable),
            .dt_i(in.data_i),
            .valid_i(in.valid),
            .ready_o(in.ready),
            .dt_o(out.data_o),
            .valid_o(out.valid),
            .ready_i(out.ready)
            );

  initial begin
    `ifdef XCELIUM
       $recordvars();
    `endif
    `ifdef VCS
       $vcdpluson;
    `endif
    `ifdef QUESTA
       $wlfdumpvars();
       set_config_int("*", "recording_detail", 1);
    `endif
    
    uvm_config_db#(virtual input_if)::set(uvm_root::get(), "*", "in_vif", in);
    uvm_config_db#(virtual output_if)::set(uvm_root::get(), "*",  "out_vif", out);
    
    run_test("simple_test");
  end
endmodule