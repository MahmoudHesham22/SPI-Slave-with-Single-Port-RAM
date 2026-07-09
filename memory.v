module RAM (din,rx_valid,dout,tx_valid,clk,rst_n);
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;

input [ADDR_SIZE+1:0] din; input rx_valid,clk,rst_n;
output reg [ADDR_SIZE-1:0] dout; output reg tx_valid;
reg [ADDR_SIZE-1:0] read_address,write_address;
reg[ADDR_SIZE-1:0]mem[MEM_DEPTH-1:0];

always @(posedge clk) begin
//resetting
 if(~rst_n) begin
 dout<=0; tx_valid<=0; write_address<=0; read_address<=0;
 end

//allow recieving data
 else if(rx_valid)begin
  case (din[ADDR_SIZE+1:ADDR_SIZE])
// write command
  2'b00:begin
    write_address<=din[ADDR_SIZE-1:0];  tx_valid<=0;
    end 
  2'b01:begin
    mem[write_address]<=din[ADDR_SIZE-1:0]; tx_valid<=0;
    end
//read command
  2'b10:begin
    read_address<=din[ADDR_SIZE-1:0]; tx_valid<=1; 
    end
  2'b11:begin
    dout<=mem[read_address];  tx_valid<=1;
    end
  endcase
 end
end
endmodule