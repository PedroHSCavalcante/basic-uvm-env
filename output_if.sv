interface output_if(input clk, rst);
    logic [7:0] data_o;
    logic       valid;
    logic       ready;
    
    modport port(input clk, rst, data_o, valid, output ready);
endinterface