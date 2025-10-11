//////////////////////////////////////////////////////////////////////////////////
// SPI Half-Duplex Slave
//////////////////////////////////////////////////////////////////////////////////
module spi_slave_half_duplex (
    input spi_clk,
    input spi_cs,
    inout spi_io
);
    reg [15:0] rx_shift;
    reg [15:0] tx_shift;
    reg [4:0] counter;
    reg spi_io_dir; // 1=slave drives, 0=slave listens
    reg spi_data_out;

    assign spi_io = (spi_io_dir && !spi_cs) ? spi_data_out : 1'bz;
    wire spi_data_in = spi_io;

    always @(posedge spi_clk or posedge spi_cs) begin
        if(spi_cs) begin
            tx_shift <= 16'hCC33;  // Response data
            counter <= 5'd16;
            spi_io_dir <= 1'b0;    // start as receiver
          //  spi_data_out <= 1'b0;
        end else begin
            if(!spi_io_dir) begin
                // Receive bits from master
                rx_shift <= {rx_shift[14:0], spi_data_in};
                if(counter != 0)
                    counter <= counter - 1;
                // After receiving all bits, switch to transmit
                if(counter == 1)
                    spi_io_dir <= 1'b1;
            end else begin
                // Shift transmit data
                tx_shift <= {tx_shift[14:0], 1'b0};
            end
        end
    end

    always @(negedge spi_clk) begin
        if(!spi_cs && spi_io_dir)
            spi_data_out <= tx_shift[15];
    end

endmodule
