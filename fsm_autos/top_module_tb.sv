`timescale 1ns/1ps

module top_module_tb;
    // Testbench signals
    logic clk;
    logic rst;

    logic [1:0] lasers;
    logic cathod;
    logic [6:0] seg;
    logic [1:0] an;

    // Clock generation: 10 ns period => 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // DUT instantiation
    top_module dut (
        .clk(clk),
        .rst(rst),
        .lasers(lasers),
        .cathod(cathod),
        .seg(seg),
        .an(an)
    );

    // Test sequence
    initial begin
        // Waveform dump
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module_tb);

        // Initial values
     
        rst = 0;
        
        cathod = 0;  // Start with common-anode mode
        lasers = '0;
        // Hold reset
        repeat (3) @(posedge clk);
        rst = 1;

        repeat(3) @(posedge clk);
        
        repeat (5) begin
            lasers = 2'b01;
            repeat(3) @(posedge clk);
            lasers = 2'b11;
            repeat(3) @(posedge clk);
            lasers = 2'b10;
            repeat(3) @(posedge clk);
            lasers = 2'b00;
            repeat(3) @(posedge clk);
        end
        repeat(10) @(posedge clk);
        repeat (3) begin
            lasers = 2'b10;
            repeat(3) @(posedge clk);
            lasers = 2'b11;
            repeat(3) @(posedge clk);
            lasers = 2'b01;
            repeat(3) @(posedge clk);
            lasers = 2'b00;
            repeat(3) @(posedge clk);
        end

        // Let it run for some cycles in common-anode mode
        repeat(10) @(posedge clk);

        // Stop simulation
        $finish;
    end


endmodule
