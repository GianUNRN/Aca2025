`timescale 1ns/1ps

module top_module_tb;
    // Testbench signals
    logic clk;
    logic rst_n;
    logic en;

    logic cathod;
    logic [6:0] seg;
    logic [2:0] an;
    logic [4:0] other_an;
    logic       dp;
    logic [3:0] units, tens, hundreds;


    // Clock generation: 10 ns period => 100 MHz
    initial clk = 0;
    always #5 clk = ~clk;

    // DUT instantiation
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .cathod(cathod),
        .en(en),
        .seg(seg),
        .an(an),
        .dp(dp),
        .other_an(other_an),
        .units(units),
        .tens(tens),
        .hundreds(hundreds)
    );

    // Test sequence
    initial begin
        // Waveform dump
        $dumpfile("wave.vcd");
        $dumpvars(0, top_module_tb);

        // Initial values
 
        rst_n = 0;
        en = 0;
        cathod = 0;  // Start with common-anode mode

        // Hold reset
        repeat (3) @(posedge clk);
        rst_n = 1;
        en = 1;

        // Let it run for some cycles in common-anode mode
        repeat (500) @(posedge clk);
  
        repeat (600) @(posedge clk);

        // Stop simulation
        $finish;
    end


endmodule