module SPI (MOSI_s,MISO_s,SS_n_s,clk,rst_n_s);
input MOSI_s,SS_n_s,clk,rst_n_s ;
output MISO_s ;
wire [9:0] rx_data_s ;
wire [7:0] tx_data_s ;
wire  rx_valid_s,tx_valid_s ;
SPI_SLAVE a1(MOSI_s,MISO_s,SS_n_s,clk,rst_n_s,rx_data_s,rx_valid_s,tx_data_s,tx_valid_s) ;
RAM a2(rx_data_s,rx_valid_s,tx_data_s,tx_valid_s,clk,rst_n_s) ;
  
endmodule
