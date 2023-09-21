module my_fifo #(
                   parameter DATA_W           = 128      ,        // Data width
                   parameter DEPTH            = 1024      ,        // Depth of FIFO                   
                   parameter UPP_TH           = 4      ,        // Upper threshold to generate Almost-full
                   parameter LOW_TH           = 2               // Lower threshold to generate Almost-empty
                )

                (
                   input                   clk         ,        // Clock
                   input                   reset        ,        // Active-low Synchronous Reset
                   
                   input                   wr_en      ,        // Write Enable
                  input  [DATA_W - 1 : 0] wr_data    ,        // Write-data
                   output                  almst_full  ,        // Almost-full signal
                   output                  full      ,        // Full signal

                   input                   rd_en      ,        // Read Enable
                  output [DATA_W - 1 : 0] rd_data    ,        // Read-data
                   output                  almst_empty ,        // Almost-empty signal
                   output                  empty              // Empty signal
                );


/*-------------------------------------------------------------------------------------------------------------------------------
   Internal Registers/Signals
-------------------------------------------------------------------------------------------------------------------------------*/
logic [DATA_W - 1        : 0] data_rg [DEPTH] ;        // Data array
logic [$clog2(DEPTH) - 1 : 0] wrptr_rg        ;        // Write pointer
logic [$clog2(DEPTH) - 1 : 0] rdptr_rg        ;        // Read pointer
logic [$clog2(DEPTH)     : 0] dcount_rg       ;        // Data counter
      
logic                         wren_s          ;        // Write Enable signal generated iff FIFO is not full
logic                         rden_s          ;        // Read Enable signal generated iff FIFO is not empty
logic                         full_s          ;        // Full signal
logic                         empty_s         ;        // Empty signal


/*-------------------------------------------------------------------------------------------------------------------------------
   Synchronous logic to write to and read from FIFO
-------------------------------------------------------------------------------------------------------------------------------*/
always @ (posedge clk) begin

  if (!reset) begin      
      
      data_rg   <= '{default: '0} ;
      wrptr_rg  <= 0              ;
      rdptr_rg  <= 0              ;      
      dcount_rg <= 0              ;

   end

   else begin   
            
      /* FIFO write logic */            
      if (wren_s) begin                          
                  
        data_rg [wrptr_rg] <= wr_data ;        // Data written to FIFO

         if (wrptr_rg == DEPTH - 1) begin
            wrptr_rg <= 0               ;        // Reset write pointer  
         end

         else begin
            wrptr_rg <= wrptr_rg + 1    ;        // Increment write pointer            
         end

      end

      /* FIFO read logic */
      if (rden_s) begin         

         if (rdptr_rg == DEPTH - 1) begin
            rdptr_rg <= 0               ;        // Reset read pointer
         end

         else begin
            rdptr_rg <= rdptr_rg + 1    ;        // Increment read pointer            
         end

      end

      /* FIFO data counter update logic */
      if (wren_s && !rden_s) begin               // Write operation
         dcount_rg <= dcount_rg + 1 ;
      end                    
      else if (!wren_s && rden_s) begin          // Read operation
         dcount_rg <= dcount_rg - 1 ;         
      end

   end

end


/*-------------------------------------------------------------------------------------------------------------------------------
   Continuous Assignments
-------------------------------------------------------------------------------------------------------------------------------*/

// Full and Empty internal
assign full_s      = (dcount_rg == DEPTH) ? 1'b1 : 0                ; 
assign empty_s     = (dcount_rg == 0    ) ? 1'b1 : 0                ;

// Write and Read Enables internal
assign wren_s      = wr_en & !full_s                               ;  
assign rden_s      = rd_en & !empty_s                              ;

// Full and Empty to output
assign full      = full_s                            ;
assign empty     = empty_s                                        ;

// Almost-full and Almost-empty to output
assign almst_full  = ((dcount_rg > UPP_TH) ? 1'b1 : 0)              ;
assign almst_empty = (dcount_rg < LOW_TH) ? 1'b1 : 0                ;  

// Read-data to output
assign rd_data    = data_rg [rdptr_rg]                             ;   


endmodule
