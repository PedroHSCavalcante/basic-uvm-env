class monitor extends uvm_monitor;

    interface_vif  vif;
    event begin_record, end_record;
    transaction_in tr_in;
    transaction_out tr_out;
    uvm_analysis_port #(transaction_in) req_port;
    uvm_analysis_port #(transaction_out) resp_port;
    `uvm_component_utils(monitor)
   
    function new(string name, uvm_component parent);
        super.new(name, parent);
        req_port = new ("req_port", this);
        resp_port = new ("resp_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(interface_vif)::get(this, "", "vif", vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
        tr_in = transaction_in::type_id::create("tr_in", this);
        tr_out = transaction_out::type_id::create("tr_out", this);
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            collect_transactions(phase);
        join
    endtask

    virtual task collect_transactions(uvm_phase phase);
        forever begin

            @(posedge vif.clk) begin
                
                if(!vif.busy_o) begin
                    @(posedge vif.busy_o);
                    begin_tr(tr_in, "req");
                    tr_in.data = vif.dt_i;
                    req_port.write(tr_in);
                    @(posedge vif.clk);
                    end_tr(tr_in);
                end
                else if(vif.busy_o)begin
                    @(negedge vif.busy_o);
                    begin_tr(tr_out, "resp");
                    tr_out.result = vif.dt_o;
                    resp_port.write(tr_out);
                    end_tr(tr_out);
                end
            end
        end
    endtask
endclass
