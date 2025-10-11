//////////////////////////////////////////////////////////////////////////////////
// SPI Half-Duplex Master
//////////////////////////////////////////////////////////////////////////////////
module spi_master_half_duplex (
    input  clk,
    input  rst,
    input  [15:0] data_in,      // Data to transmit
    output reg spi_cs,          // Chip select (active low)
    output reg spi_clk,         // SPI clock
    inout  wire spi_io,         // Shared data line (MOSI+MISO)
    output reg [15:0] spi_data  // Received data from slave
);

    // Internal registers
    reg [15:0] MOSI;           
    reg [15:0] MISO;           
    reg [4:0] counter;
    reg spi_io_dir;             // 1 = master drives, 0 = slave drives
    reg [2:0] pres_st, next_st;
    reg spi_data_out;

    // Tri-state assignment
    assign spi_io = (spi_io_dir) ? spi_data_out : 1'bz;
    wire spi_data_in = spi_io;

    // FSM state encoding
    parameter IDLE        = 3'd0;
    parameter LOAD        = 3'd1;
    parameter TX_LOW      = 3'd2;
    parameter TX_HIGH     = 3'd3;
    parameter SWITCH_DIR  = 3'd4;
    parameter RX_LOW      = 3'd5;
    parameter RX_HIGH     = 3'd6;
    parameter DONE        = 3'd7;

    // Sequential logic: present state
    always @(posedge clk or posedge rst) begin
        if(rst)
            pres_st <= IDLE;
        else
            pres_st <= next_st;
    end

    // Next state logic
    always @(*) begin
        case(pres_st)
            IDLE:       next_st = (data_in != 0) ? LOAD : IDLE;
            LOAD:       next_st = TX_LOW;
            TX_LOW:     next_st = TX_HIGH;
            TX_HIGH:    next_st = (counter == 0) ? SWITCH_DIR : TX_LOW;
            SWITCH_DIR: next_st = RX_LOW;
            RX_LOW:     next_st = RX_HIGH;
            RX_HIGH:    next_st = (counter == 0) ? DONE : RX_LOW;
            DONE:       next_st = IDLE;
            default:    next_st = IDLE;
        endcase
    end

    // Output & control logic
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            MOSI        <= 16'd0;
            MISO        <= 16'd0;
            counter     <= 5'd16;
            spi_cs      <= 1'b1;
            spi_clk     <= 1'b0;
            spi_data    <= 16'd0;
            spi_data_out <= 1'b0;
            spi_io_dir  <= 1'b1; // master drives by default
        end else begin
            case(pres_st)
                IDLE: begin
                    spi_clk <= 1'b0;
                    spi_cs <= 1'b1;
                    spi_io_dir <= 1'b1;
                    counter <= 5'd16;
                end

                LOAD: begin
                    spi_clk <= 1'b0;
                    spi_cs <= 1'b0;
                    MOSI <= data_in;
                    counter <= 5'd16;
                    spi_io_dir <= 1'b1; // drive line to send data
                end

                TX_LOW: begin
                    spi_clk <= 1'b0;
                    spi_data_out <= MOSI[15]; // output MSB
                end

                TX_HIGH: begin
                    spi_clk <= 1'b1;
                    MOSI <= {MOSI[14:0], 1'b0};
                    if(counter != 0)
                        counter <= counter - 1;
                end

                SWITCH_DIR: begin
                    spi_clk <= 1'b0;
                    spi_io_dir <= 1'b0; // release line, slave drives
                    counter <= 5'd16;   // prepare to receive
                    MISO <= 16'd0;      // clear receive register
                end

                RX_LOW: begin
                    spi_clk <= 1'b0;
                    MISO <= {MISO[14:0], spi_data_in};
                    if(counter != 0)
                        counter <= counter - 1;
                end

                RX_HIGH: begin
                    spi_clk <= 1'b1;
                end

                DONE: begin
                    spi_clk <= 1'b0;
                    spi_cs <= 1'b1;
                    spi_io_dir <= 1'b1;    // master drives again
                    spi_data <= MISO;       // store received data
                end

                default: ;
            endcase
        end
    end

endmodule


