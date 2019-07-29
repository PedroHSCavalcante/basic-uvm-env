class monitor_out extends uvm_monitor;
    `uvm_component_utils(monitor_out)
    output_vif  out_vif;
    event begin_record, end_record;
    transaction_out tr;
    uvm_analysis_port #(transaction_out) item_collected_port;
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new ("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(output_vif)::get(this, "", "out_vif", out_vif)) begin
            `uvm_fatal("NOout_VIF", "failed to get virtual interface")
        end
        tr = transaction_out::type_id::create("tr", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_transactions(phase);
            record_tr();
        join
    endtask

    virtual task collect_transactions(uvm_phase phase);
        wait(out_vif.rst === 1);
        @(negedge out_vif.rst);
        
        forever begin
            do begin
                @(posedge out_vif.clk);
            end while (out_vif.valid === 0 || out_vif.ready === 0);
            -> begin_record;
            
            tr.result = out_vif.data_o;
            item_collected_port.write(tr);

            @(posedge out_vif.clk);
            -> end_record;
        end
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(tr, "monitor_out");
            @(end_record);
            end_tr(tr);
        end
    endtask
endclass