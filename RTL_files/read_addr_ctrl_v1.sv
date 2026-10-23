
module read_addr_ctrl_v1 #(
    parameter int IMG_WIDTH  = 5,
    parameter int IMG_HEIGHT = 5
) (
    input  logic clk,
    input  logic rst_n,
    input  logic [7:0] fifo_data,
    input  logic fifo_rd_en,
    output logic window_valid,
    output logic [2:0][2:0][7:0] data_out
);

    logic [7:0] linebuf1 [0:IMG_WIDTH-1];
    logic [7:0] linebuf2 [0:IMG_WIDTH-1];

    logic [5:0] col, row;

    logic [2:0][2:0][7:0] data;
    logic [2:0][2:0][7:0] data_next;

    // Calculate the window after the incoming pixel is shifted in
    always_comb begin
        data_next = data;

        // Top row
        data_next[0][0] = data[0][1];
        data_next[0][1] = data[0][2];
        data_next[0][2] = linebuf2[col];

        // Middle row
        data_next[1][0] = data[1][1];
        data_next[1][1] = data[1][2];
        data_next[1][2] = linebuf1[col];

        // Bottom row
        data_next[2][0] = data[2][1];
        data_next[2][1] = data[2][2];
        data_next[2][2] = fifo_data;
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            col          <= 0;
            row          <= 0;
            window_valid <= 0;

            data         <= '{default: '0};
            data_out     <= '{default: '0};
            linebuf1     <= '{default: '0};
            linebuf2     <= '{default: '0};
        end
        else begin
            // Default: output-valid is a one-cycle pulse per window
            window_valid <= 1'b0;

            if (fifo_rd_en) begin

                // Update line buffers
                linebuf2[col] <= linebuf1[col];
                linebuf1[col] <= fifo_data;

                // Update the internal sliding window
                data <= data_next;

                // Capture the NEW window, not the previous one
                if ((row >= 2) && (col >= 2)) begin
                    data_out     <= data_next;
                    window_valid <= 1'b1;
                end

                // Pixel counters
                if (col == IMG_WIDTH - 1) begin
                    col <= 0;
                    if (row == IMG_HEIGHT - 1)
                        row <= 0;
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
