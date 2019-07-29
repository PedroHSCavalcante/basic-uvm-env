class monitor_in extends uvm_monitor;
    input_vif  in_vif;
    event begin_record, end_record;
    transaction_in tr;
    uvm_analysis_port #(transaction_in) item_collected_port;
    `uvm_component_utils(monitor_in)
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
        item_collected_port = new ("item_collected_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(input_vif)::get(this, "", "in_vif", in_vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
        tr = transaction_in::type_id::create("tr", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_transactions(phase);
            record_tr();
        join
    endtask

    virtual task collect_transactions(uvm_phase phase);
        forever begin
            do begin
                @(posedge in_vif.clk);
            end while (in_vif.valid === 0 || in_vif.ready === 0);
            -> begin_record;
            
            tr.data = in_vif.data_i;
            item_collected_port.write(tr);

            @(posedge in_vif.clk);
            -> end_record;
        end
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(tr, "monitor_in");
            @(end_record);
            end_tr(tr);
        end
    endtask
endclass
