`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02.10.2026 16:52:16
// Design Name: 
// Module Name: sobel_module_v1
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


module sobel_module_v1(

input logic [2:0][2:0][7:0] data,
input logic window_valid, 
input logic clk,
input logic rst_n,
output logic[15:0] G, // TODO : Will this accomodate all the values? the avg width is 17:0 - Need to check
output logic G_rdy 
);

logic [2:0][2:0][16:0] my_pixel_x;  // the bit-wdith is 2n 
logic [2:0][2:0][16:0] my_pixel_y; // Multiplied data 
logic signed [17:0] my_sum_x, my_sum_y; 
logic signed [17:0] abs_x, abs_y;
 
// Signed multiplication
always_comb begin 
  if (window_valid) begin 
    my_pixel_x[0][0] = (data[0][0])*$signed((-1));
    my_pixel_x[0][1] = (data[0][1])*$signed((0));
    my_pixel_x[0][2] = (data[0][2])*$signed((1));
    my_pixel_x[1][0] = (data[1][0])*$signed((-2)); 
    my_pixel_x[1][1] = (data[1][1])*$signed((0));
    my_pixel_x[1][2] = (data[1][2])*$signed((2)); 
    my_pixel_x[2][0] = (data[2][0])*$signed((-1)); 
    my_pixel_x[2][1] = (data[2][1])*$signed((0));
    my_pixel_x[2][2] = (data[2][2])*$signed((1)); 
    
    my_pixel_y[0][0] = (data[0][0])*$signed((-1));   
    my_pixel_y[0][1] = (data[0][1])*$signed((-2));                                          
    my_pixel_y[0][2] = (data[0][2])*$signed((-1));                                         
    my_pixel_y[1][0] = (data[1][0])*$signed((0));   
    my_pixel_y[1][1] = (data[1][1])*$signed((0));   
    my_pixel_y[1][2] = (data[1][2])*$signed((0));  
    my_pixel_y[2][0] = (data[2][0])*$signed((1));    
    my_pixel_y[2][1] = (data[2][1])*$signed((2));   
    my_pixel_y[2][2] = (data[2][2])*$signed((1));   
  end 
  else begin 
    my_pixel_x[0][0] = '0;  
    my_pixel_x[0][1] = '0;  
    my_pixel_x[0][2] = '0;  
    my_pixel_x[1][0] = '0;  
    my_pixel_x[1][1] = '0;  
    my_pixel_x[1][2] = '0;  
    my_pixel_x[2][0] = '0;  
    my_pixel_x[2][1] = '0;  
    my_pixel_x[2][2] = '0;  
                       
    my_pixel_y[0][0] = '0;  
    my_pixel_y[0][1] = '0;  
    my_pixel_y[0][2] = '0;  
    my_pixel_y[1][0] = '0;  
    my_pixel_y[1][1] = '0;  
    my_pixel_y[1][2] = '0;  
    my_pixel_y[2][0] = '0;  
    my_pixel_y[2][1] = '0;  
    my_pixel_y[2][2] = '0;
  end  
end 

 
always_comb begin 
  my_sum_x = '0;
  my_sum_y = '0;
  for (int i=0; i<=2; i++) begin      
    for (int j=0; j<=2; j++) begin    
      my_sum_x = $signed(my_sum_x)+ $signed(my_pixel_x[i][j]);
      my_sum_y = $signed(my_sum_y)+ $signed(my_pixel_y[i][j]);
    end
  end
end


assign abs_x = (my_sum_x < 0) ? -my_sum_x: my_sum_x; // Flip the sign to get the magnitude
assign abs_y = (my_sum_y < 0) ? -my_sum_y: my_sum_y;

always_ff @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
       G <= 0;
       G_rdy <= 0; 
  end
  else begin 
      G <= abs_x + abs_y;
      if (window_valid) G_rdy <= 1'b1;
      else G_rdy <= 1'b0;     
  end
end
// assign G = abs_x + abs_y;

endmodule
