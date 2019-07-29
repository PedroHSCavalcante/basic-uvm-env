interface input_if(input clk, rstn);
    logic [7:0] data_i;
    logic enable;
    
    modport port(input clk, rst, data, enable);
endinterface