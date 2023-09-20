interface fifo_interface(input clk,reset);
  logic wr_en;
  logic rd_en;
  logic [127:0]wr_data;
  logic full;
  logic empty;
  logic [127:0]rd_data;
  logic almst_full;
  logic almst_empty;
  
  clocking d_cb @(posedge clk);
  default input #1 output #1;
    output wr_en;
    output rd_en;
    output wr_data;
    input reset;
  endclocking  
  
   clocking m_cb @(posedge clk);
  default input #1 output #1;
    input wr_en;
    input rd_en;
    input wr_data;
    input full;
    input empty;
    input rd_data;
    input almst_full;
    input almst_empty;
  endclocking  
  
  modport d_mp (input clk, reset, clocking d_cb);
  modport m_mp (input clk, reset, clocking m_cb);
    
endinterface
