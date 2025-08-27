// Asynchronous FIFO Design // 

`timescale 1ns / 1ps

module Asynchronous_fifo #(
  parameter DATA_WIDTH = 4,    
  parameter DEPTH      = 8,   
  parameter PTR_WIDTH  = $clog2(DEPTH) // 3 bits 
)(
  input w_clk, w_rst, r_clk, r_rst, w_en, r_en, 
  input [DATA_WIDTH-1:0] w_data,
  output reg  [DATA_WIDTH-1:0] r_data, 
  output full, empty, 
  output reg [PTR_WIDTH :0] w_ptr, r_ptr
);
  
  reg [DATA_WIDTH-1:0] fifo_mem [DEPTH-1:0];
  
  // writing logic 
  always @(posedge w_clk or posedge w_rst)
    begin 
      if(w_rst)
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
  
  // reading logic 
  always @(posedge r_clk or posedge r_rst)
    begin 
      if(r_rst)
        begin
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
  
  
  ///////////////////////////////////////////////////
  
  function [PTR_WIDTH:0] gray2bin(input [PTR_WIDTH:0] g);
    integer i;
      begin
        gray2bin[PTR_WIDTH] = g[PTR_WIDTH];   
          for(i = PTR_WIDTH-1; i >= 0; i = i-1)
            gray2bin[i] = gray2bin[i+1] ^ g[i];
      end
  endfunction
  
  
  ///////////////////////////////////////////////////
  reg [PTR_WIDTH:0] w_ff1, w_ff2;
  reg [PTR_WIDTH:0] w_bin2gray, w_gray2bin;
  
  // bin2gray conversion of write pointer
  always @(posedge w_clk)
    begin 
      if(w_rst)
        w_bin2gray <= 0; 
      else 
        w_bin2gray <= w_ptr ^ (w_ptr>>1);
    end 
  
  // w_ptr synchronization and gray2bin conversion
  always @(posedge r_clk)
    begin 
      if(r_rst)
        begin
          w_ff1 <= 0;
          w_ff2 <= 0;
        end 
      else 
        begin 
          w_ff1 <= w_bin2gray;
          w_ff2 <= w_ff1;
          w_gray2bin <= gray2bin(w_ff2);
        end 
    end 

  ///////////////////////////////////////////////////  
  reg [PTR_WIDTH:0] r_ff1, r_ff2;
  reg [PTR_WIDTH:0] r_bin2gray, r_gray2bin;
 
  // bin2gray conversion of read pointer
  always @(posedge r_clk)
    begin 
      if(r_rst)
        r_bin2gray <= 0; 
      else 
        r_bin2gray <= r_ptr ^ (r_ptr>>1);
    end 
  
  // r_ptr synchronization and gray2bin conversion
  always @(posedge w_clk)
    begin 
      if(w_rst)
        begin
          r_ff1 <= 0;
          r_ff2 <= 0;
        end 
      else 
        begin 
          r_ff1 <= r_bin2gray;
          r_ff2 <= r_ff1;
          r_gray2bin <= gray2bin(r_ff2);
        end 
    end       
  
  
  // full and empty logic 
  assign full = ({~w_ptr[PTR_WIDTH], w_ptr[PTR_WIDTH-1:0]} == r_gray2bin);
  assign empty = (w_gray2bin == r_ptr);
  
endmodule 
  
    