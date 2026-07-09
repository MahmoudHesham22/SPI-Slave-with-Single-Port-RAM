module SPI_SLAVE (MOSI,MISO,SS_n,clk,rst_n,rx_data,rx_valid,tx_data,tx_valid) ;
input MOSI,clk,rst_n,SS_n,tx_valid ;
input [7:0] tx_data ;
output reg MISO ;
output reg [9:0] rx_data=0 ;
output reg rx_valid ;
parameter IDLE = 0, READ_DATA=1, READ_ADD=2, CHK_CMD=3, WRITE=4  ;
(*fsm_encoding = "sequential"*)
reg [2:0] ns,cs;
reg w1=0 ;
integer  i=9 ;
integer j = 0 ;
always @(*) begin
    case (cs)
        IDLE: 
        begin
            if(!SS_n)
            ns = CHK_CMD ;
            else
            ns = IDLE ;
        end
        READ_DATA:
        begin
            if(SS_n)
            ns = IDLE ;
            else
            ns = READ_DATA ;
        end
        READ_ADD:
        begin
            if(SS_n)
            ns = IDLE ;
            else 
            ns = READ_ADD ;
        end
        CHK_CMD :
        begin
            if (SS_n==0 && MOSI==1 && w1==0 && i==9) 
                ns = READ_ADD ;
            else if(SS_n==0 && MOSI==1 && w1==1 && i==9)
                ns = READ_DATA ;
            else if (SS_n==0 && MOSI==0 && i==9)
                ns = WRITE ;
            else 
                ns = IDLE  ;
        end 
        WRITE :
        begin
            if(SS_n)
            ns = IDLE ;
            else 
            ns = WRITE ;
        end
    endcase
end
always @(posedge clk) begin
    case (cs)
        WRITE:
        begin
            if (SS_n==0 && i>=0) begin
                    rx_data[i] <= MOSI ;
                    i <= i-1 ;
                    rx_valid <= 0;
                end
            if(i==0)
                rx_valid <= 1;
            if(i== -1 ) begin
                i <=9 ;
                end
        end
        READ_ADD :
         begin
            if(SS_n==0 && i>=0)begin
                    rx_data[i] <= MOSI ;
                    i <= i-1 ;
                    w1<=1 ;
                    if(i==0)
                      rx_valid <= 1;
                end
             if(i== -1 )
                i <=9 ;

         end
         IDLE:
         begin
          MISO <= 0 ;
         end
        READ_DATA: 
        begin
           if(SS_n==0 && i>=0 && tx_valid==1 )begin
                rx_data[i] <= MOSI ;
                j <=j+1 ;
                if(j<=1) begin
                i <= i-1 ;
                end
                end
            if(i<8 && i>=0 && j>=3) begin
                 MISO <= tx_data[i] ;
                 i <= i-1 ;
            end
            if( i== -1 )
                i <= 9 ;  
                
        end
    endcase
end

always @(posedge clk ) begin
     if(!rst_n)  begin
        cs <= IDLE ;    
     end
     else 
       cs <= ns ;
end


endmodule
