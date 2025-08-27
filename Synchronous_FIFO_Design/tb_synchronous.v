// Testbench for Synchronous FIFO //

`timescale 1ns / 1ps

module synchronous_fifo_tb;
  parameter DATA_WIDTH = 4;   
  parameter DEPTH      = 8;   
  parameter PTR_WIDTH  = $clog2(DEPTH); // 3 bits 

  reg clk, rst, w_en, r_en;
  reg [DATA_WIDTH-1:0] w_data;
  wire [DATA_WIDTH-1:0] r_data; 
  wire full, empty; 
  wire [PTR_WIDTH:0] w_ptr, r_ptr;
  
  synchronous_fifo dut(.clk(clk), .rst(rst), .w_en(w_en), .r_en(r_en), .w_data(w_data), .r_data(r_data), .full(full), 
                       .empty(empty), .w_ptr(w_ptr), .r_ptr(r_ptr));
                       
  always #1 clk = ~clk; 
  
  initial begin
    clk = 0; rst = 1;
    w_en = 0; r_en = 0; w_data = 0;

    #2 rst = 0;  

    repeat (9) begin
      @(posedge clk);
      if (!full) begin
        w_en = 1;
        w_data = {$random} % 16;  // 0-15 random values 
      end
    end
    @(posedge clk);
    w_en = 0; 

    // Wait a few cycles
    #20;

    repeat (8) begin
      @(posedge clk);
      if (!empty) begin
        r_en = 1;
      end
    end
    @(posedge clk);
    r_en = 0; 

    #50 $finish;
  end
  
  
endmodule
