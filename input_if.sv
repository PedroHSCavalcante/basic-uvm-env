interface input_if(input clk, rst);
    logic [7:0] data_i;
    logic       enable;
    logic       valid;
    logic       ready;
    
    modport port(input clk, rst, ready, output data_i, enable, valid);
endinterface