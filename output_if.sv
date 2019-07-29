interface output_if(input clk, rst);
    logic [7:0] data_o;
    
    modport port(input clk, rst, output data_o);
endinterface