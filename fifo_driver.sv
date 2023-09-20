class fifo_driver extends uvm_driver#(fifo_sequence_item);
  virtual fifo_interface vif;
 
  fifo_sequence_item item_port;
  
  `uvm_component_utils(fifo_driver)
  
  function new(string name = "fifo_driver", uvm_component parent);
    super.new(name, parent);
  endfunction
  
  
  //build phase        //config.db
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual fifo_interface)::get(this, "", "vif", vif))
      `uvm_fatal("Driver: ", "No vif is found!")
  endfunction
      
      
      //run phase
  virtual task run_phase(uvm_phase phase);
    
    vif.d_mp.d_cb.wr_en <= 'b0;
    vif.d_mp.d_cb.rd_en <='b0;
    vif.d_mp.d_cb.wr_data <='b0;
    
    forever begin
      seq_item_port.get_next_item(item_port);  //waiting for data from sequencer
      if(item_port.wr_en == 1)
        main_write(item_port.wr_data);
      
      else if(item_port.rd_en == 1)
        main_read();
      
      seq_item_port.item_done();            //indicating sequencer
    end
  endtask
    
    //write
    virtual task main_write(input [127:0] wr_data);
      @(posedge vif.d_mp.d_cb)
    vif.d_mp.d_cb.wr_en <= 'b1;
    vif.d_mp.d_cb.wr_data <= wr_data;
    @(posedge vif.d_mp.d_cb)
    vif.d_mp.d_cb.wr_en <='b0;
  endtask

    //read
     virtual task main_read();
    @(posedge vif.d_mp.d_cb)
    vif.d_mp.d_cb.rd_en <= 'b1;
    @(posedge vif.d_mp.d_cb)
    vif.d_mp.d_cb.rd_en <= 'b0;
  endtask
    endclass
