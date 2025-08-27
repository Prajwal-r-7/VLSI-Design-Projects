// Testbench for Asynchronous FIFO // 

`timescale 1ns / 1ps

module asynchronous_fifo_tb;

  parameter DATA_WIDTH = 4;
  parameter DEPTH      = 8;
  parameter PTR_WIDTH  = $clog2(DEPTH);

  reg  w_clk, w_rst, r_clk, r_rst;
  reg  w_en, r_en;
  reg  [DATA_WIDTH-1:0] w_data;
  wire [DATA_WIDTH-1:0] r_data;
  wire full, empty;
  wire [PTR_WIDTH:0] w_ptr, r_ptr;

  Asynchronous_fifo #(.DATA_WIDTH(DATA_WIDTH),.DEPTH(DEPTH),.PTR_WIDTH(PTR_WIDTH)) dut (.w_clk(w_clk), .w_rst(w_rst),.r_clk(r_clk), .r_rst(r_rst),
    .w_en(w_en), .r_en(r_en),.w_data(w_data),.r_data(r_data),.full(full), .empty(empty),.w_ptr(w_ptr), .r_ptr(r_ptr)
  );

  // Write clock = 10ns
  always #5 w_clk = ~w_clk;
  // Read clock = 17ns 
  always #8.5 r_clk = ~r_clk;

  initial begin
    w_clk = 0; r_clk = 0;
    w_rst = 1; r_rst = 1;
    w_en = 0; r_en = 0; w_data = 0;

    #20; w_rst = 0; r_rst = 0;

    // Write 6 values into FIFO
    repeat(9) begin
      @(posedge w_clk);
      if (!full) begin
        w_data <= $random % 16;
        w_en <= 1;
      end
    end
    @(posedge w_clk) w_en <= 0;
    
    #20;

    // Start reading
    repeat(10) begin
      @(posedge r_clk);
      if (!empty) r_en <= 1;
    end
    @(posedge r_clk) r_en <= 0;

    // Finish
    #100;
    $finish;
  end

endmodule


