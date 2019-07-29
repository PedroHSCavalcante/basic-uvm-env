typedef virtual input_if input_vif;

class driver_in extends uvm_driver #(packet_in);
    `uvm_component_utils(driver_in)
    input_vif vif;
    event begin_record, end_record;

    function new(string name = "driver_in", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        assert(uvm_config_db#(input_vif)::get(this, "", "vif", vif));
    endfunction

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        fork
            reset_signals();
            get_and_drive(phase);
            record_tr();
        join
    endtask

    virtual protected task reset_signals();
        wait (vif.rst === 1);
        forever begin
            vif.data_i <= '0;
            vif.enable <= '1;
            vif.valid  <= '0;
            @(posedge vif.rst);
        end
    endtask

    virtual protected task get_and_drive(uvm_phase phase);
        wait(vif.rst === 1);
        @(negedge vif.rst);
        @(posedge vif.clk);

        forever begin
            if(vif.ready) begin
                seq_item_port.try_next_item(tr);
                -> begin_record;
                drive_transfer(tr);
            end
        end
    endtask

    virtual protected task drive_transfer(packet_in tr);
        vif.data_i = tr.data;
        vif.valid  = 1'b1;
        -> end_record;
    endtask

    virtual task record_tr();
        forever begin
            @(begin_record);
            begin_tr(req, "driver_in");
            @(end_record);
            end_tr(req);
        end
    endtask
endclass