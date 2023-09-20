class fifo_sequence extends uvm_sequence#(fifo_sequence_item);

fifo_sequence_item item;
  `uvm_object_utils(fifo_sequence)

  function new(string name = "fifo_sequence");
 super.new(name);
endfunction



virtual task body();

//ideal
repeat(10) begin
item= fifo_sequence_item::type_id::create("item");
start_item(item);
  assert(item.randomize() with {wr_en==0;rd_en==0;});
finish_item(item);
end

//write
repeat(10) begin
item= fifo_sequence_item::type_id::create("item");
start_item(item);
  assert(item.randomize() with {wr_en==1;rd_en==0;});
finish_item(item);
end

//Read
repeat(10) begin
item=fifo_sequence_item::type_id::create("item");
start_item(item);
  assert(item.randomize() with {wr_en==0;rd_en==1;});
finish_item(item);
end

//alternate write read
  repeat(10) begin
item=fifo_sequence_item::type_id::create("item");
start_item(item);
repeat(10) begin
  assert(item.randomize() with {wr_en==0;rd_en==1;});
  assert(item.randomize() with {wr_en==1;rd_en==0;});

finish_item(item);
  end
  end

//simultaneous write and read
repeat(10) begin
item=fifo_sequence_item::type_id::create("item");
start_item(item);
  assert(item.randomize() with {wr_en==1;rd_en==1;});
finish_item(item);
end
endtask
endclass
