//////////////////////////////////////////////////////////////////////////////////
// SPI Master-Slave Top-Level Connection
//////////////////////////////////////////////////////////////////////////////////
module spi_top_half_duplex (
    input clk,
    input rst,
    input [15:0] data_in,
    output [15:0] data_out
);
    wire spi_clk, spi_cs;
    wire spi_io;

    spi_master_half_duplex master_inst (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .spi_cs(spi_cs),
        .spi_clk(spi_clk),
        .spi_io(spi_io),
        .spi_data(data_out)
    );

    spi_slave_half_duplex slave_inst (
        .spi_clk(spi_clk),
        .spi_cs(spi_cs),
        .spi_io(spi_io)
    );

endmodule