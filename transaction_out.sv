class transaction_out extends uvm_sequence_item;
  rand bit [7:0] result;

  function new(string name = "");
    super.new(name);
  endfunction

  `uvm_object_param_utils_begin(transaction_out)
    `uvm_field_int(result, UVM_UNSIGNED)
  `uvm_object_utils_end

  function string convert2string();
    return $sformatf("{result = %d}",result);
  endfunction
endclass