`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2026 23:12:17
// Design Name: 
// Module Name: sync_2_stage
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


module sync_2_stage(

input logic clk, 
input logic rst_n,
input logic sync_i,
output logic sync_o 
    );
logic sync_ff1, sync_ff2 ; 
    
assign sync_o = sync_ff2;

always_ff @(posedge clk or negedge rst_n) begin 
  if(!rst_n) begin 
       sync_ff1    <= '0;
       sync_ff2    <= '0;
  end
  else begin 
       sync_ff1    <= sync_i;  
       sync_ff2    <= sync_ff1;
  end
end

endmodule
