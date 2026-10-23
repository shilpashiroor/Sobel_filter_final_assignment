`timescale 1ns / 1ps

module tb_sobel_filter_top_v1;

    // Configured for the 5x5 test size
    parameter int IMG_WIDTH  = 5;
    parameter int IMG_HEIGHT = 5;
    
    localparam int TOTAL_PIXELS = IMG_WIDTH * IMG_HEIGHT;

    logic wr_clk;
    logic rd_clk;
    logic rst_n;

    // Top-Level Interface Signals
    logic [15:0] PG;
    logic pool_rdy;

    // File descriptors
    int out_file;
    int pool_file;

    // DUT Instance
    sobel_filter_top_v1 #(
        .IMG_WIDTH       (IMG_WIDTH),
        .IMG_HEIGHT      (IMG_HEIGHT),
        .INIT_START_ADDR (0),
        .INIT_END_ADDR   (TOTAL_PIXELS - 1) // Set to address 24 (25 pixels total)
    ) dut (
        .wr_clk   (wr_clk),
        .rd_clk   (rd_clk),
        .rst_n    (rst_n),
        .PG       (PG),        
        .pool_rdy (pool_rdy)   
    );

    // Write clock: 100 MHz
    initial wr_clk = 1'b0;
    always #5 wr_clk = ~wr_clk;

    // Read clock: 200 MHz
    initial rd_clk = 1'b0;
    always #2.5 rd_clk = ~rd_clk;

    // File management lifecycle
    initial begin
        out_file  = $fopen("hw_sobel_output.txt", "w");
        pool_file = $fopen("hw_pooling_output.txt", "w");
    end

    // Reset and simulation control
    initial begin
        rst_n = 1'b0;

        $display("========================================");
        $display("Starting Sobel + Pooling testbench (5x5)");
        $display("========================================");

        repeat (5) @(posedge wr_clk);
        rst_n = 1'b1;

        $display("[%0t] Reset released", $time);

        // Scaled run duration for a small 5x5 frame matrix pipeline
        repeat (TOTAL_PIXELS + 80) @(posedge rd_clk);

        $display("[%0t] Simulation completed", $time);
        $fclose(out_file);
        $fclose(pool_file);
        $finish;
    end

    // Monitor internal Sobel calculations 
    always @(posedge rd_clk) begin
        if (rst_n) begin
            if (dut.window_valid) begin
                $display(
                    "[%0t] SOBEL RUN: window_valid=%b, bram_addr=%0d, G=%0d",
                    $time,
                    dut.window_valid,
                    dut.bram_addr,
                    dut.G
                );

                $display("Window:");
                $display("%0d %0d %0d",
                    dut.data_out[0][0],
                    dut.data_out[0][1],
                    dut.data_out[0][2]);

                $display("%0d %0d %0d",
                    dut.data_out[1][0],
                    dut.data_out[1][1],
                    dut.data_out[1][2]);

                $display("%0d %0d %0d",
                    dut.data_out[2][0],
                    dut.data_out[2][1],
                    dut.data_out[2][2]);
            end
        end
    end

    // Synchronous Monitoring & Logging for the Pooling Output Layer
    always @(posedge rd_clk) begin
        if (rst_n && pool_rdy) begin
            $display(
                "[%0t] >>> POOLING OUTPUT READY! PG (Decimal) = %0d, PG (Hex) = %0h", 
                $time, 
                PG, 
                PG
            );
            $fwrite(pool_file, "%0h\n", PG);
        end
    end

    // Synchronous File Writing for Sobel Outputs
    always @(posedge rd_clk) begin
        if (rst_n && dut.window_valid) begin
            $fwrite(out_file, "%0h\n", dut.G);
        end
    end

endmodule
