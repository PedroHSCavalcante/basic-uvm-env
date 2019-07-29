typedef virtual input_if input_vif;

class driver_in extends uvm_driver #(transaction_in);
    `uvm_component_utils(driver_in)
    input_vif in_vif;
    event begin_record, end_record;
    transaction_in tr;

    function new(string name = "driver_in", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
         if(!uvm_config_db#(input_vif)::get(this, "", "in_vif", in_vif)) begin
            `uvm_fatal("NOVIF", "failed to get virtual interface")
        end
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
        forever begin
            @(posedge in_vif.clk) begin
                if(!in_vif.rst) begin
                    in_vif.data_i <= '0;
                    in_vif.enable <= '1;
                    in_vif.valid  <= '0;
                end
            end
        end
    endtask

    virtual protected task get_and_drive(uvm_phase phase);
        wait(in_vif.rst === 1);
        @(negedge in_vif.rst);
        @(posedge in_vif.clk);

        forever begin
            if(in_vif.ready) begin
                seq_item_port.try_next_item(tr);
                -> begin_record;
                drive_transfer(tr);
            end
        end
    endtask

    virtual protected task drive_transfer(transaction_in tr);
        in_vif.data_i = tr.data;
        in_vif.valid  = 1'b1;
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