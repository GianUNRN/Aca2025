`timescale 1ns/1ps

module top_module_tb;
    // Testbench signals
    logic clk;
    logic rst;
    logic en;
    logic up;
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
        .en(en),
        .up(up),
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
        up = 1;
        rst = 0;
        en = 0;
        cathod = 0;  // Start with common-anode mode

        // Hold reset
        repeat (3) @(posedge clk);
        rst = 1;
        en = 1;

        // Let it run for some cycles in common-anode mode
        repeat (500) @(posedge clk);
        up = 0;
        repeat (600) @(posedge clk);

        // Stop simulation
        $finish;
    end


endmodule
