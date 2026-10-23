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

module bram_4kx8_v1 #(
parameter int DATA_WIDTH = 8, 
parameter int ADDR_WIDTH = 12, 
parameter int INIT_START_ADDR = 0,
parameter int INIT_END_ADDR   = 10)
(
input logic clk,
input logic [DATA_WIDTH-1:0] wr_data,
input logic [ADDR_WIDTH-1:0] addr,
input logic  nwr, // Active low wr_/rd
output logic [DATA_WIDTH-1:0] rd_data 
);

logic [DATA_WIDTH-1:0] mem [(2**ADDR_WIDTH)-1:0];

// OPtionally if you want to initialize the memory
initial 
    $readmemh("my_image.mem", mem, INIT_START_ADDR, INIT_END_ADDR);

always @(posedge clk) // TODO : Why always is used not always_ff
    if (!nwr) 
        mem[addr] <= wr_data ;
    else 
        rd_data   <= mem[addr];

endmodule

