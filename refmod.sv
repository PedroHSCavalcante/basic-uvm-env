import "DPI-C" context function bit [7:0] sqrt(bit [7:0] x)

class refmod extends uvm_component;
    `uvm_component_utils(refmod)
    
    transaction_in tr_in;
    transaction_out tr_out;
    
    uvm_get_port #(transaction_in) in;
    uvm_put_port #(transaction_out) out;
    
    function new(string name = "refmod", uvm_component parent);
        super.new(name, parent);
        in = new("in", this);
        out = new("out", this);
    endfunction
    
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        tr_out = transaction_out::type_id::create("tr_out", this);
    endfunction: build_phase
    
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        
        forever begin
            in.get(tr_in);
            tr_out.result = sqrt(tr_in.data);
            out.put(tr_out);
        end
    endtask: run_phase
endclass: refmod