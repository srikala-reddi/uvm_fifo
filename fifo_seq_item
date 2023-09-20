class fifo_sequence_item extends uvm_sequence_item;
  //signals
  
  rand bit[127:0]wr_data;
   bit [127:0]rd_data;
  rand bit wr_en;
   rand bit rd_en;
  bit full;
  bit empty;
  bit almst_full;
  bit almst_empty;
  
  //utility macros
  
  `uvm_object_utils_begin(fifo_sequence_item)
  `uvm_field_int(wr_data, UVM_ALL_ON)
  `uvm_field_int(rd_data, UVM_ALL_ON)
  `uvm_field_int(wr_en, UVM_ALL_ON)
  `uvm_field_int(rd_en, UVM_ALL_ON)
  `uvm_field_int(full, UVM_ALL_ON)
  `uvm_field_int(empty, UVM_ALL_ON)
  `uvm_field_int(almst_full, UVM_ALL_ON)
  `uvm_field_int(almst_empty, UVM_ALL_ON)
  `uvm_object_utils_end
  
  //constraints
  
 // constraint c1{ rd_en!=wr_en;};
  
  //pre_randomize function
  
//   function void pre_randomize();
//     if(rd_en)
//       wr_data.rand_mode(0);
//   endfunction
  
  //constructor
  
  function new(string name="fifo_sequence_item");
    super.new(name);
  endfunction
  
endclass
