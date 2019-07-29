module top;
  logic clk;
  logic rst;
  
  initial begin
    clk = 0;
    rst = 1;
    #22 rst = 0;
    
  end
  
  always #5 clk = !clk;
  
  input_if in(clk, rst);
  output_if out(clk, rst);
  
  sqrt sqrt(.clk_i(in.clk),
            .enb_i(in.enable),
            .dt_i(in.data_i),
            .valid_i(in.valid),
            .ready_o(in.ready),
            .dt_o(out.data_o),
            .valid_o(out.valid),
            .ready_i(out.ready)
            );

  initial begin
    `ifdef INCA
       $recordvars();
    `endif
    `ifdef VCS
       $vcdpluson;
    `endif
    `ifdef QUESTA
       $wlfdumpvars();
       set_config_int("*", "recording_detail", 1);
    `endif
    
    uvm_config_db#(input_vif)::set(uvm_root::get(), "*.env_h.ag_i.*", "vif", in);
    uvm_config_db#(output_vif)::set(uvm_root::get(), "*.env_h.ag_o.*",  "vif", out);
    
    run_test("simple_test");
  end
endmodule