`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2026 18:10:51
// Design Name: 
// Module Name: fifo_9x8_v1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: ASYNC FIFO 
// 
//////////////////////////////////////////////////////////////////////////////////


module fifo_9x8_v1(

input logic wr_clk, 
input logic rd_clk,
input logic rst_n,  
input logic [7:0] wr_data,
output logic [7:0] rd_data, 
input logic wr_en, rd_en, 
output logic full, empty 

);    
logic [5:0] wr_ptr, wr_ptr_gray, wr_ptr_rd_clk, wr_ptr_rd_clk_r;
logic [5:0] rd_ptr, rd_ptr_gray, rd_ptr_wr_clk, rd_ptr_wr_clk_r;
    
// STEP 2. Instantiate FIFO 
FIFO my_fifo (
.wr_clk(wr_clk),
.rd_clk(rd_clk),  
.wr_ptr(wr_ptr),
.rd_ptr(rd_ptr),
.wr_data(wr_data),
.wr_en(wr_en),
.rd_en(rd_en),
.rd_data(rd_data));


wr_ptr_v1 wr_ptr_handler(
.wr_clk(wr_clk),
.rst_n(rst_n),  
.wr_en(wr_en), 
.rd_ptr_wr_clk(rd_ptr_wr_clk),
.wr_ptr(wr_ptr), 
.full(full)
);  

rd_ptr_v1 rd_ptr_handler (
.rd_clk(rd_clk),
.rst_n(rst_n),  
.rd_en(rd_en), 
.wr_ptr_rd_clk(wr_ptr_rd_clk), 
.rd_ptr(rd_ptr),
.empty(empty) 
);   

// STEP3 : Convert address pointers to gray code to avoid decode errors because of synchronization delay of each bits. Gray code will not have that issue as only one bit changes from current to the next counter 
bin_to_gray rd_ptr_b2g (
.bin_data_in(rd_ptr),
.gray_data_out(rd_ptr_gray)
);

bin_to_gray wr_ptr_b2g (
.bin_data_in(wr_ptr),
.gray_data_out(wr_ptr_gray)
);

// STEP3 : synchronizer the read and wr pointers to dest clocks - before that convert to gray code 
genvar k; 
generate 
    for (k=0; k<=5; k++) begin : wr_ptr_sync_blk
      sync_2_stage wr_ptr_sync (
      .clk(rd_clk),
      .rst_n(rst_n),  
      .sync_i(wr_ptr_gray[k]),
      .sync_o(wr_ptr_rd_clk_r[k])
      );
    end
    for (k=0; k<=5; k++) begin : rd_ptr_sync_blk
      sync_2_stage rd_ptr_sync (
      .clk(wr_clk), // Sync rd_ptr on wr clk 
      .rst_n(rst_n),  
      .sync_i(rd_ptr_gray[k]),
      .sync_o(rd_ptr_wr_clk_r[k])
      );
    end
endgenerate

// STEP 4 : Convert back to Binary after synchronization for Full and Empty flag calculation
gray_to_bin rd_ptr_g2b (
.gray_data_in(rd_ptr_wr_clk_r),
.bin_data_out(rd_ptr_wr_clk)
);


gray_to_bin wr_ptr_g2b (
.gray_data_in(wr_ptr_rd_clk_r),
.bin_data_out(wr_ptr_rd_clk)
);     
      
endmodule
