//////////////////////////////////////////////////////////////////////////////////
// Testbench for SPI Master-Slave Half-Duplex
//////////////////////////////////////////////////////////////////////////////////
module tb_spi_half_duplex;

    reg clk, rst;
    reg [15:0] data_in;
    wire [15:0] data_out;

    spi_top_half_duplex DUT (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .data_out(data_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        data_in = 0;
        #20 rst = 0;

        #20 data_in = 16'hA5A5;
        #600;

        #20 data_in = 16'h23A2;
        #600;

        #100 $finish;
    end

endmodule

