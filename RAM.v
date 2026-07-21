module RAM #(
    parameter MEM_DEPTH = 256,
    parameter ADDR_SIZE = 8
 )
 (
    input wire clk,
    input wire rst_n,
    input wire [9:0]din,
    input wire rx_valid,
    output reg [7:0] dout,
    output reg tx_valid
);

//========================================================================================
// Memory array
//========================================================================================
reg [ADDR_SIZE-1:0] mem [0:MEM_DEPTH-1];
reg [ADDR_SIZE-1:0] write_address;
reg [ADDR_SIZE-1:0] read_address;
reg [3:0] bit_cnt;

//========================================================================================
// Sequential logic for memory operations
//========================================================================================
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        write_address <= {ADDR_SIZE{1'b0}};
        read_address <= {ADDR_SIZE{1'b0}};
        dout <= {8{1'b0}};
        tx_valid <= 1'b0;
        bit_cnt <= 4'b0;
    end 
    else if (rx_valid) begin
        tx_valid <= 1'b0; // Reset tx_valid at the start of a new transaction
        case (din[9:8])
            2'b00: begin // Write address
                write_address <= din[7:0];
            end
            2'b01: begin // Write data
                mem[write_address] <= din[7:0];
            end
            2'b10: begin // Read address
                read_address <= din[7:0];
            end
            2'b11: begin // Read data
                dout <= mem[read_address];
                tx_valid <= 1'b1;
            end
        endcase
    end
    else if (tx_valid) begin
        if (bit_cnt == 4'd7) begin
            tx_valid <= 1'b0; // Reset tx_valid after sending 8 bits
            bit_cnt <= 4'b0;
        end
        else begin
            bit_cnt <= bit_cnt + 1'b1;
        end
    end
    else begin
        tx_valid <= 1'b0; // Reset tx_valid when not transmitting
        bit_cnt <= 4'b0; // Reset bit counter when not transmitting
    end
end

    
endmodule
