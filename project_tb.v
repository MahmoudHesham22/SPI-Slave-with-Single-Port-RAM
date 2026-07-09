module tb ();
reg MOSI_tb,SS_n_tb,clk,rst_n_tb ;
wire MISO_tb ;
SPI DUT(MOSI_tb,MISO_tb,SS_n_tb,clk,rst_n_tb);
initial begin
    clk = 0 ;
    forever begin
       #10 clk = ~clk ;
    end
end
initial begin
    $readmemh("mem.dat",DUT.a2.mem) ;
    rst_n_tb = 0 ;
    @(negedge clk) ;
    rst_n_tb = 1 ;
    SS_n_tb = 0 ;    //write address
     MOSI_tb = 0 ;
    repeat(2)@(negedge clk) ;
     MOSI_tb = 0 ;   //1
    @(negedge clk) ;
     MOSI_tb = 0 ; //2
    @(negedge clk) ;
     MOSI_tb = 0 ;  //3
    @(negedge clk) ;
     MOSI_tb = 0 ;  //4
    @(negedge clk) ;
     MOSI_tb = 1 ;  //5
    @(negedge clk) ;
     MOSI_tb = 0 ;  //6
    @(negedge clk) ;
     MOSI_tb = 0 ; //7
    @(negedge clk) ;
     MOSI_tb = 1 ; //8
    @(negedge clk) ;
     MOSI_tb = 0 ; //9
    @(negedge clk) ;
     MOSI_tb = 0 ; //10
    repeat(2)@(negedge clk) ;
     MOSI_tb = 0 ;   //1
    @(negedge clk) ;
     MOSI_tb = 1 ; //2
    @(negedge clk) ;
     MOSI_tb = 0 ;  //3
    @(negedge clk) ;
     MOSI_tb = 0 ;  //4
    @(negedge clk) ;
     MOSI_tb = 1 ;  //5
    @(negedge clk) ;
     MOSI_tb = 0 ;  //6
    @(negedge clk) ;
     MOSI_tb = 0 ; //7
    @(negedge clk) ;
     MOSI_tb = 1 ; //8
    @(negedge clk) ;
     MOSI_tb = 1 ; //9
    @(negedge clk) ;
     MOSI_tb = 1 ; //10
    repeat(2)@(negedge clk) ;
    SS_n_tb = 1 ;
    @(negedge clk) ; //going to idle
     MOSI_tb = 1 ;
    repeat(2)@(negedge clk) ;
    SS_n_tb = 0 ;
    MOSI_tb = 1 ;
    repeat(2)@(negedge clk) ;
    MOSI_tb = 1 ;   //1
    @(negedge clk) ;
     MOSI_tb = 0 ; //2
    @(negedge clk) ;
     MOSI_tb = 0 ;  //3
    @(negedge clk) ;
     MOSI_tb = 0 ;  //4
    @(negedge clk) ;
     MOSI_tb = 1 ;  //5
    @(negedge clk) ;
     MOSI_tb = 0 ;  //6
    @(negedge clk) ;
     MOSI_tb = 0 ; //7
    @(negedge clk) ;
     MOSI_tb = 1 ; //8
    @(negedge clk) ;
     MOSI_tb = 0 ; //9
    @(negedge clk) ;
     MOSI_tb = 0 ; //10
    repeat(2)@(negedge clk) ;
    SS_n_tb = 1 ;
    @(negedge clk) ; //going to idle
    //  MOSI_tb = 1 ;
    // repeat(2)@(negedge clk) ;
    SS_n_tb = 0 ;
    MOSI_tb = 1 ;
    repeat(2)@(negedge clk) ;
    MOSI_tb = 1 ;   //1
    @(negedge clk) ;
     MOSI_tb = 1 ; //2
    @(negedge clk) ;
     MOSI_tb = 0 ;  //3
    @(negedge clk) ;
     MOSI_tb = 0 ;  //4
    @(negedge clk) ;
     MOSI_tb = 1 ;  //5
    @(negedge clk) ;
     MOSI_tb = 0 ;  //6
    @(negedge clk) ;
     MOSI_tb = 0 ; //7
    @(negedge clk) ;
     MOSI_tb = 1 ; //8
    @(negedge clk) ;
     MOSI_tb = 0 ; //9
    @(negedge clk) ;
     MOSI_tb = 0 ; //10
    repeat(2)@(negedge clk) ;


    $stop;
end



endmodule