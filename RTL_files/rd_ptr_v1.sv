module rd_ptr_v1(

input logic rd_clk,
input logic rst_n,  
input logic rd_en, 
input logic [5:0] wr_ptr_rd_clk, 
output logic [5:0] rd_ptr,
output logic empty
);   

 

always_ff @(posedge rd_clk or negedge rst_n)
if(!rst_n) 
    rd_ptr <= '0; 
else if (rd_en && !empty) 
    rd_ptr <= rd_ptr + 1'b1;   
    
always_comb 
if (rd_ptr[4:0] == wr_ptr_rd_clk[4:0])
    empty = 1'b1;
else 
    empty = 1'b0;
    
endmodule 
