`timescale 1ns / 1ps

module pooling_layer #(
    parameter int IMG_WIDTH  = 5,
    parameter int IMG_HEIGHT = 5
) (
    input  logic clk,
    input  logic rst_n,
    input  logic [15:0] G,           // Incoming pixel from Sobel filter
    input  logic G_rdy,
    output logic pool_rdy,          // High only when a pooled pixel is ready
    output logic [15:0] PG          // Pooled output pixel
);

    // Line buffer to store exactly one row of pixels
    logic [15:0] linebuf1[0:IMG_WIDTH-3];
    

    // Counters: Scaled dynamically to hold the full dimension values
    // Using $clog2 makes the bit-width safe for any image size
    logic [$clog2(IMG_WIDTH)-1:0]  col;
    logic [$clog2(IMG_HEIGHT)-1:0] row;

    // 2x2 Sliding Window Registers: [row][col]
    // Indices: [0][0]=top-left, [0][1]=top-right, [1][0]=bottom-left, [1][1]=bottom-right
    logic [1:0][1:0][15:0] data;
    logic [1:0][1:0][15:0] data_next;
    logic [17:0] pool_sum;

    always_comb begin
       pool_sum = {2'b00, data_next[0][0]}
                + {2'b00, data_next[0][1]}
                + {2'b00, data_next[1][0]}
                + {2'b00, data_next[1][1]};
     end

    // Combinational Logic for the Sliding Window Shifting
    always_comb begin
        // Default assignment to avoid latches
       data_next = data;
       
       if (G_rdy) begin 
          // Shift columns to the left (Column 1 moves to Column 0)
          data_next[0][0] = data[0][1]; 
          data_next[1][0] = data[1][1];

          // Insert new pixels into Column 1
          data_next[0][1] = linebuf1[col]; // Top-right gets the pixel from the previous row
          data_next[1][1] = G;            // Bottom-right gets the current incoming pixel
      end
    end

    // Sequential Logic Block
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            col      <= '0;
            row      <= '0;
            PG       <= '0;
            pool_rdy <= '0; 
            data     <= '{default: '0};
            linebuf1 <= '{default: '0};
        end
        else begin
            // Default outputs unless overridden
            pool_rdy <= 1'b0;
            // 3. Stride=2 Timing Control: 
            // Only pool on ODD rows and ODD columns once the 2x2 grid is fully packed.
            // Example: for a 2x2 window, row 1 col 1 contains pixels from rows 0,1 and cols 0,1.
            //if ((row >= 1) && (col >= 1)) begin
            if (G_rdy) begin
                // 1. Shift the new pixel into the line buffer BEFORE updating registers
                linebuf1[col] <= G;

                // 2. Step the sliding window forward
                data <= data_next;

                if ((row >= 1) && (col >= 1)) begin
             //   if ((row % 2 == 1) && (col % 2 == 1)) begin
                    // Perform Average Pooling: Sum 4 values and divide by 4 (Right shift by 2)
                    PG <= pool_sum >> 2;
                    pool_rdy <= 1'b1;   
                end
                // 4. Update Coordinate Counters
                if (col == IMG_WIDTH - 3) begin
                    col <= '0;
                    if (row == IMG_HEIGHT - 3)
                        row <= '0;
                    else
                        row <= row + 1'b1;
                end
                else begin
                    col <= col + 1'b1;
                end
            end
        end
    end

endmodule
