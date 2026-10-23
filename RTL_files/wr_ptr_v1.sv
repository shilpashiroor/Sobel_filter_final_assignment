module wr_ptr_v1(

input logic wr_clk,
input logic rst_n,  
input logic wr_en, 
input logic [5:0] rd_ptr_wr_clk,
output logic [5:0] wr_ptr,
output logic full 

);   


// STEP 1. Increment the FIFO Pointer 
always_ff @(posedge wr_clk or negedge rst_n)
if(!rst_n) 
    wr_ptr <= '0; 
else if (wr_en && !full) 
    wr_ptr <= wr_ptr + 1'b1;  

always_comb 
if ((wr_ptr[5]) & (wr_ptr[4:0] == rd_ptr_wr_clk[4:0]))
    full = 1'b1;
else 
    full = 1'b0;
    
endmodule 
