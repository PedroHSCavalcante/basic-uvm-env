typedef virtual interface_if.mst interface_vif;

class driver extends uvm_driver #(transaction_in);
    `uvm_component_utils(driver)
    interface_vif vif;
    event begin_record, end_record;
    transaction_in tr;

    function new(string name = "driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(interface_vif)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
    endfunction

    task run_phase (uvm_phase phase);
        fork
            reset_signals();
            get_and_drive(phase);
        join
    endtask

    virtual task reset_signals();    
        wait (vif.rst === 0);
        forever begin
            vif.enb_i <= '0;  
            vif.dt_i  <= '0;
            @(negedge vif.rst);
        end
    endtask : reset_signals

    virtual task get_and_drive(uvm_phase phase);
        wait (vif.rst === 0);
        @(posedge vif.rst);
        forever begin
            seq_item_port.get_next_item(tr);
            driver_transfer(tr);
            seq_item_port.item_done();
        end
    endtask : get_and_drive

    virtual task driver_transfer(transaction_in tr);
        @(posedge vif.clk);
        $display("",);
        vif.dt_i <= tr.data;
        vif.enb_i   <= '1;
        @(posedge vif.busy_o);
    endtask : driver_transfer

endclass