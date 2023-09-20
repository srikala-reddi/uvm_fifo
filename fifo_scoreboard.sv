class fifo_scoreboard extends uvm_scoreboard;
  uvm_analysis_imp#(fifo_sequence_item, fifo_scoreboard) item_got_export;
  `uvm_component_utils(fifo_scoreboard)
  
  function new(string name = "fifo_scoreboard", uvm_component parent);
    super.new(name, parent);
    item_got_export = new("item_got_export", this);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  bit [127:0] queue[$];
  
  function void write(input fifo_sequence_item item_got);
    bit [127:0] examdata;
    if(item_got.wr_en == 'b1)begin
      queue.push_back(item_got.wr_data);
      `uvm_info("write Data", $sformatf("wr: %0b rd: %0b data_in: %0h full: %0b",item_got.wr_en, item_got.rd_en,item_got.wr_data, item_got.full), UVM_LOW);
    end
    else if (item_got.rd_en == 'b1)begin
      if(queue.size() >= 'd1)begin
        examdata = queue.pop_front();
        `uvm_info("Read Data", $sformatf("examdata: %0h data_out: %0h empty: %0b", examdata, item_got.rd_data, item_got.empty), UVM_LOW);
        
        if(examdata == item_got.rd_data)begin
          $display("Pass!");
        end
        
        else begin
          $display("Fail!");
          $display("Check empty");
        end
      end
      
    end
  endfunction
endclass
