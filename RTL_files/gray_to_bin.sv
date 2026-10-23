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


module gray_to_bin(

input logic [5:0] gray_data_in,
output logic [5:0] bin_data_out

);

genvar i;

generate 
    for (i=5; i>=0; i--) 
        if (i==5) 
            assign bin_data_out[5] = gray_data_in[5] ;
        else                                   
            assign bin_data_out[i] = bin_data_out[i+1] ^ gray_data_in[i];
endgenerate 
endmodule
