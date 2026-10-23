`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2026 16:16:55
// Design Name: 
// Module Name: bram_4kx8_v1
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

module FIFO #(
parameter int DATA_WIDTH = 8, 
parameter int ADDR_WIDTH = 12, 
parameter int INIT_START_ADDR = 0,
parameter int INIT_END_ADDR   = 10)
(
input logic wr_clk,
input logic rd_clk,  
input logic [4:0] wr_ptr, // Note this is 32 depth FIFO
input logic [4:0] rd_ptr, // Note this is 32 depth FIFO
input logic [7:0] wr_data,
input logic wr_en, rd_en,
output logic [7:0] rd_data
);

logic [DATA_WIDTH-1:0] mem [2**(ADDR_WIDTH-1):0];

always @(posedge wr_clk) // TODO : Why always is used not always_ff
    if (wr_en) 
        mem[wr_ptr] <= wr_data ;
always @(posedge rd_clk) // TODO : Why always is used not always_ff
   if (rd_en) 
        rd_data   <= mem[rd_ptr];

endmodule

