module SPI_slave (
    input wire clk ,
    input wire  rst_n ,
    input wire MOSI ,
    input wire SS_n , 
    input wire [7:0] tx_data ,
    input wire tx_valid ,
    output reg MISO ,
    output reg [9:0] rx_data ,
    output reg rx_valid
);

//========================================================================================
// state definition
//========================================================================================
localparam IDLE = 2'b00;
localparam CHK_CMD = 2'b01;
localparam WRITE = 2'b10;
localparam READ = 2'b11;

//========================================================================================
// state register
//========================================================================================
reg [1:0] cs, ns;
reg read_address_received;
reg [3:0] bit_cnt;


//========================================================================================
// next state logic
//========================================================================================
always @(*) begin
    case(cs)
        IDLE: begin
            if(!SS_n) begin
                ns = CHK_CMD;
            end
            else begin
                ns = IDLE;
            end
        end
        CHK_CMD: begin
            if(SS_n) begin
                ns = IDLE;
            end
            else if (!MOSI && !SS_n) begin
                ns = WRITE;
            end
            else if (MOSI && !SS_n) begin
                ns = READ;
            end
            else begin
                ns = CHK_CMD;
            end
        end
        WRITE: begin
            if(SS_n) begin
                ns = IDLE;
            end
            else begin
                ns = WRITE;
            end
        end
        READ: begin
            if(SS_n) begin
                ns = IDLE;
            end
            else begin
                ns = READ;
            end
        end
        default: ns = IDLE;
    endcase
end

//========================================================================================
// state transition logic
//========================================================================================
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)begin
        cs <= IDLE;
    end
    else begin
        cs <= ns;
    end
end

//========================================================================================
// output logic
//========================================================================================
always @(posedge clk or negedge rst_n) begin 
    if(!rst_n) begin
        rx_data <= 10'b0;
        rx_valid <= 1'b0;
        MISO <= 1'b0;
        bit_cnt <= 4'b0;
        read_address_received <= 1'b0;
    end
    else begin
        rx_valid <= 1'b0;
        MISO <= 1'b0;
        case(cs)
            IDLE: begin
                rx_valid <= 1'b0;
            end
            CHK_CMD: begin
                rx_valid <= 1'b0;
            end
            
            WRITE: begin
                if (!SS_n) begin
                    rx_data <= {rx_data[8:0], MOSI};   // shift in ONE bit this clock
                    if (bit_cnt == 9) begin
                        rx_valid <= 1'b1;
                        bit_cnt <= 0;
                    end else begin
                        rx_valid <= 1'b0;
                        bit_cnt <= bit_cnt + 1;
                    end
                end
            end

            READ: begin
                if (read_address_received) begin
                    if (!SS_n && tx_valid) begin
                        MISO <= tx_data[8 - bit_cnt];                   
                        bit_cnt <= bit_cnt + 1'b1;
                        if(bit_cnt == 4'd8) begin                       //counter resets after it reaches 8, as it starts from 1 because it enters else condition first 
                            read_address_received <= 1'b0;              // before tx valid asserted
                            bit_cnt <= 4'b0;
                        end
                    end
                    else if (!SS_n && !tx_valid) begin
                        rx_data <= {rx_data[8:0], MOSI};
                        if (bit_cnt == 4'd9) begin
                            rx_valid <= 1'b1;
                            bit_cnt <= 4'b0;
                        end
                        else begin
                            bit_cnt <= bit_cnt + 1'b1;
                        end
                    end
                end
                else begin
                    if (!SS_n) begin
                        rx_data <= {rx_data[8:0], MOSI};
                        if (bit_cnt == 4'd9) begin
                            rx_valid <= 1'b1;
                            read_address_received <= 1'b1;
                            bit_cnt <= 4'b0;
                        end
                        else begin
                            bit_cnt <= bit_cnt + 1'b1;
                        end
                    end
                end
            end
        endcase
    end
end

    
endmodule
