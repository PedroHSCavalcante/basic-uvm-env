interface input_if(input clk, rst);
    logic [7:0] data;
    logic enable;
    
    modport in(input clk, rst, data, enable);
endinterface