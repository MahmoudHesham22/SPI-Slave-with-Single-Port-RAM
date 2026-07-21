module SPI_top (
    input wire clk ,
    input wire  rst_n ,
    input wire MOSI ,
    input wire SS_n , 
    output wire MISO 
);

//========================================================================================
// Internal signals
//========================================================================================    
wire [9:0] rx_data ;
wire rx_valid ;
wire [7:0] tx_data ;
wire tx_valid ;

//========================================================================================
// Instantiate the SPI_slave module
//========================================================================================
SPI_slave SPI_SLAVE (
    .clk(clk),
    .rst_n(rst_n),
    .MOSI(MOSI),
    .SS_n(SS_n),
    .MISO(MISO),
    .rx_data(rx_data),
    .rx_valid(rx_valid),
    .tx_data(tx_data),
    .tx_valid(tx_valid)
);

//========================================================================================
// Instantiate the RAM module
//========================================================================================
RAM RAM_INST (
    .clk(clk),
    .rst_n(rst_n),
    .din(rx_data),
    .rx_valid(rx_valid),
    .dout(tx_data),
    .tx_valid(tx_valid)
);

endmodule
