`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2026 10:12:41
// Design Name: 
// Module Name: pixel_controller_v1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pixel_controller_v1(


    );
    
    fifo_9x8_v1 u_dut (
        .wr_clk  (wr_clk),
        .rd_clk  (rd_clk),
        .rst_n   (rst_n),
        .wr_data (wr_data),
        .rd_data (rd_data),
        .wr_en   (wr_en),
        .rd_en   (rd_en),
        .full    (full),
        .empty   (empty)
    );
endmodule
