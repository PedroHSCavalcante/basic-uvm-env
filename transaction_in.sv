class transaction_in extends uvm_sequence_item;
  rand bit [7:0] data;

  function new(string name = "");
    super.new(name);
  endfunction

  `uvm_object_param_utils_begin(transaction_in)
    `uvm_field_int(data, UVM_ALL_ON)
  `uvm_object_utils_end

  function string convert2string();
    return $sformatf("{data = %d}",data;
  endfunction
endclass