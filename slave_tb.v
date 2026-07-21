
module tb ();
reg MOSI_tb,SS_n_tb,clk,rst_n_tb ;
wire MISO_tb ;

// Instantiate the SPI_top module
SPI_top SPI_TOP (
    .clk(clk),
    .rst_n(rst_n_tb),
    .MOSI(MOSI_tb),
    .SS_n(SS_n_tb),
    .MISO(MISO_tb)
);

initial begin
    clk = 0 ;
    forever begin
       #10 clk = ~clk ;
    end
end



////////////////////////////////////////// write data in address & expect it @ same address /////////////////////////////////

/////////////////////////////////////////                   test 1                                            ////////////////////////////////
initial begin
    $readmemh("mem.dat",SPI_TOP.RAM_INST.mem) ;
     rst_n_tb = 0 ;
     SS_n_tb = 1 ;
     MOSI_tb = 0 ;
    @(negedge clk) ;
     rst_n_tb = 1 ;
     SS_n_tb = 0 ;    
     MOSI_tb = 0 ;  
     @(negedge clk) ;
     SS_n_tb = 0 ;
     MOSI_tb = 0 ;          //write address  
     @(negedge clk) ;
     MOSI_tb = 0 ;  @(negedge clk) ; //1
     MOSI_tb = 0 ;  @(negedge clk) ; //2
     MOSI_tb = 0 ;  @(negedge clk) ; //3
     MOSI_tb = 0 ;  @(negedge clk) ; //4
     MOSI_tb = 0 ;  @(negedge clk) ; //5
     MOSI_tb = 1 ;  @(negedge clk) ; //6
     MOSI_tb = 0 ;  @(negedge clk) ; //7
     MOSI_tb = 0 ;  @(negedge clk) ; //8
     MOSI_tb = 1 ;  @(negedge clk) ; //9
     MOSI_tb = 1 ;  @(negedge clk) ;// 10
     SS_n_tb = 1 ;  @(negedge clk) ; // end of write
    ///////////////////////////write data in address & expect it @ same address /////////////////////////////////
     rst_n_tb = 1 ;
     SS_n_tb = 0 ;    
     MOSI_tb = 0 ;  
     @(negedge clk) ;
     SS_n_tb = 0 ;
     MOSI_tb = 0 ;          //write address  
     @(negedge clk) ;
     MOSI_tb = 0 ;  @(negedge clk) ; //1
     MOSI_tb = 1 ;  @(negedge clk) ; //2 // differentiate between address and data
     MOSI_tb = 1 ;  @(negedge clk) ; //3
     MOSI_tb = 0 ;  @(negedge clk) ; //4
     MOSI_tb = 0 ;  @(negedge clk) ; //5
     MOSI_tb = 1 ; @(negedge clk) ; //6
     MOSI_tb = 0 ; @(negedge clk) ; //7
     MOSI_tb = 0 ; @(negedge clk) ; //8
     MOSI_tb = 1 ; @(negedge clk) ; //9
     MOSI_tb = 1 ; @(negedge clk) ;// 10
     SS_n_tb = 1 ; @(negedge clk) ; // end of write data
    ///////////////////////////read data from address & expect it @ miso /////////////////////////////////
     rst_n_tb = 1 ;
     SS_n_tb = 0 ;    
     MOSI_tb = 0 ;  
     @(negedge clk) ;
     SS_n_tb = 0 ;
     MOSI_tb = 1 ;          //read address  
     @(negedge clk) ;
     MOSI_tb = 1 ;  @(negedge clk) ; //1
     MOSI_tb = 0 ;  @(negedge clk) ; //2
     MOSI_tb = 0 ;  @(negedge clk) ; //3
     MOSI_tb = 0 ;  @(negedge clk) ; //4
     MOSI_tb = 0 ;  @(negedge clk) ; //5
     MOSI_tb = 1 ; @(negedge clk) ; //6
     MOSI_tb = 0 ; @(negedge clk) ; //7
     MOSI_tb = 0 ; @(negedge clk) ; //8
     MOSI_tb = 1 ; @(negedge clk) ; //9
     MOSI_tb = 1 ; @(negedge clk) ;// 10
     SS_n_tb = 1 ; @(negedge clk) ; // end of read address
    ///////////////////////////read data from address & expect it @ miso /////////////////////////////////
     rst_n_tb = 1 ;
     SS_n_tb = 0 ;    
     MOSI_tb = 0 ;  
     @(negedge clk) ;
     SS_n_tb = 0 ;
     MOSI_tb = 1 ;           
     @(negedge clk) ;
     MOSI_tb = 1 ;  @(negedge clk) ; //1
     MOSI_tb = 1 ;  @(negedge clk) ; //2
     MOSI_tb = 0 ;  @(negedge clk) ; //3
     MOSI_tb = 0 ;  @(negedge clk) ; //4
     MOSI_tb = 0 ;  @(negedge clk) ; //5
     MOSI_tb = 1 ; @(negedge clk) ; //6
     MOSI_tb = 0 ; @(negedge clk) ; //7
     MOSI_tb = 0 ; @(negedge clk) ; //8
     MOSI_tb = 1 ; @(negedge clk) ; //9
     MOSI_tb = 1 ; @(negedge clk) ;// 10
    
    ///////////////////////////read data from address & expect it @ miso /////////////////////////////////
    repeat(15)@(negedge clk) ;
     SS_n_tb = 1 ; @(negedge clk) ; // end of read data

    $stop;
end



endmodule
