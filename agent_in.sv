class agent_in extends uvm_agent;
    
    typedef uvm_sequencer#(transaction_in) sequencer;
    sequencer  sqr;
    driver_in   drv;
    monitor_in  mon;

    uvm_analysis_port #(transaction_in) agt_req_port;

    `uvm_component_utils(agent_in)

    function new(string name = "agent_in", uvm_component parent = null);
        super.new(name, parent);
        agt_req_port = new("agt_req_port", this);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        mon = monitor_in::type_id::create("mon", this);
        sqr = sequencer::type_id::create("sqr", this);
        drv = driver_in::type_id::create("drv", this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.item_collected_port.connect(agt_req_port);
        drv.seq_item_port.connect(sqr.seq_item_export);
    endfunction
endclass: agent_in