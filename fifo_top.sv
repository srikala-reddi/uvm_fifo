import uvm_pkg::*;
`include "uvm_macros.svh"

`include "fifo_interface.sv"
`include "fifo_sequence_item.sv"
`include "fifo_sequence.sv"
`include "fifo_sequencer.sv"
`include "fifo_driver.sv"
`include "fifo_monitor.sv"
`include "fifo_agent.sv"
`include "fifo_scoreboard.sv"
`include "fifo_environment.sv"
`include "fifo_test.sv"

module tb;
  bit clk;
  bit reset;
  
  always #5 clk = ~clk;
  
   initial begin
    clk = 1;
    reset = 0;
    #5;
    reset = 1;
  end
 
  fifo_interface tif(clk, reset);
  
  my_fifo dut(.clk(tif.clk),   //instantiate the interface and pass it to design
               .reset(tif.reset),
             .wr_data(tif.wr_data),
             .wr_en(tif.wr_en),
             .rd_en(tif.rd_en),
               .full(tif.full),
               .empty(tif.empty),
             .almst_full(tif.almst_full),
             .almst_empty(tif.almst_empty),
             .rd_data(tif.rd_data));
  
 initial begin
   uvm_config_db#(virtual fifo_interface)::set(null, "", "vif", tif);
    $dumpfile("dump.vcd"); 
    $dumpvars;
   run_test("fifo_test");
  end
endmodule 
