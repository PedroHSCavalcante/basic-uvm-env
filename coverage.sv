class coverage extends uvm_component;

  `uvm_component_utils(coverage)

  transaction_in req;
  uvm_analysis_imp#(transaction_in, coverage) req_port;

  int min_tr;
  int n_tr = 0;

  function new(string name = "coverage", uvm_component parent= null);
    super.new(name, parent);
    req_port = new("req_port", this);
    req=new;
    min_tr = 1000;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase (phase);
  endfunction

  protected uvm_phase running_phase;
  task run_phase(uvm_phase phase);
    running_phase = phase;
    running_phase.raise_objection(this);
  endtask: run_phase

  
  function void write_req(transaction_in t);
    n_tr = n_tr + 1;
    if(n_tr >= min_n_tr)begin
      running_phase.drop_objection(this);
    end
  endfunction: write_req

endclass : coverage