`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2026 20:23:18
// Design Name: 
// Module Name: bin_to_gray
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


module bin_to_gray(

input logic [5:0] bin_data_in,
output logic [5:0] gray_data_out
);

genvar i;

generate 
    for (i=0; i<=5; i++) 
        if (i==5) 
            assign gray_data_out[5] = bin_data_in[5] ;
        else                                   
            assign gray_data_out[i] = bin_data_in[i] ^ bin_data_in[i+1];
endgenerate 
endmodule
