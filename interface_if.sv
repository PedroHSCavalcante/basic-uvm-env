interface interface_if(input clk, rst);
    logic        enb_i;
    logic [7:0]  dt_i;
    logic        busy_o;
    logic [7:0]  dt_o;
    
    modport mst(input clk, rst, busy_o, dt_o, output dt_i, enb_i);
    modport slv(input clk, rst, dt_i, enb_i, output busy_o, dt_o);
endinterface