typedef virtual output_if output_vif;

class driver_out extends uvm_driver #(transaction_out);
    `uvm_component_utils(driver_out)
    output_vif out_vif;

    function new(string name = "driver_out", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if(!uvm_config_db#(output_vif)::get(this, "", "out_vif", out_vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            drive(phase);
        join
    endtask

    virtual protected task reset_signals();
        wait (out_vif.rst === 1);
        forever begin
            out_vif.ready <= '0;
            @(posedge out_vif.rst);
        end
    endtask

    virtual protected task drive(uvm_phase phase);
        wait(out_vif.rst === 1);
        @(negedge out_vif.rst);
        @(posedge out_vif.clk);
        
        out_vif.ready <= 1;
    endtask
endclass