// SYNCHRONOUS FIFO // 

`timescale 1ns / 1ps

module synchronous_fifo #(
  parameter DATA_WIDTH = 4,    
  parameter DEPTH      = 8,   
  parameter PTR_WIDTH  = $clog2(DEPTH) // 3 bits 
)(
  input clk, rst, w_en, r_en, 
  input [DATA_WIDTH-1:0] w_data,
  output reg  [DATA_WIDTH-1:0] r_data, 
  output full, empty, 
  output reg [PTR_WIDTH :0] w_ptr, r_ptr
);

  reg [DATA_WIDTH-1 : 0] fifo_mem [DEPTH-1 : 0];
  
  // writing logic 
  always @(posedge clk)
    begin 
      if(rst)
          w_ptr <= 0;
      else 
        begin 
          if(w_en == 1 && !full)
            begin 
              fifo_mem[w_ptr[PTR_WIDTH-1:0]] <= w_data; 
              w_ptr <= w_ptr + 1;  
            end 
        end 
    end 
    
  // reading block 
  always @(posedge clk)
    begin 
      if(rst) begin 
          r_ptr <= 0; 
          r_data <= 0;
        end 
      else 
        begin 
          if(r_en == 1 && !empty)
            begin 
              r_data <= fifo_mem[r_ptr[PTR_WIDTH-1:0]];
              r_ptr <= r_ptr + 1; 
            end 
        end 
    end  

  // full and empty logic 
  assign empty = (w_ptr == r_ptr);
  assign full = ({~w_ptr[PTR_WIDTH], w_ptr[PTR_WIDTH-1:0]} == r_ptr);

endmodule
