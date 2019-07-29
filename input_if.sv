interface input_if(input clk, rstn);
    logic [7:0] data_i;
    logic       enable;
    logic       valid;
    logic       ready;
    
    modport port(input clk, rst, ready, output data, enable, valid);
endinterface