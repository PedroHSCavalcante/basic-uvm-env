class env extends uvm_env;

    agent_in    ag_i;
    agent_out   ag_o;
    scoreboard  sb;
    coverage    cov;
    
    `uvm_component_utils(env)

    function new(string name, uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ag_i = agent_in::type_id::create("ag_o", this);
        ag_o = agent_out::type_id::create("ag_i", this);
        sb = scoreboard::type_id::create("sb", this);
        cov = coverage::type_id::create("cov",this);
    endfunction

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        ag_i.agt_req_port.connect(cov.req_port);
        ag_o.agt_resp_port.connect(sb.ap_comp);
        ag_i.agt_req_port.connect(sb.ap_rfm);
    endfunction
endclass