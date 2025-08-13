`timescale 1ns/1ps

module top_module_tb;
    // Testbench signals
    logic clk;
    logic rst;
    logic en;
    logic cathod_anode;
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
        .cathod_anode(cathod_anode),
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
        en = 0;
        cathod_anode = 1;  // Start with common-anode mode

        // Hold reset
        repeat (3) @(posedge clk);
        rst = 1;
        en = 1;

        // Let it run for some cycles in common-anode mode
        repeat (1500) @(posedge clk);

        // Stop simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $display("Time\tAN\tSEG\tMode");
        forever begin
            @(posedge clk);
            $display("%0t\t%b\t%b\t%s", $time, an, seg,
                     cathod_anode ? "CA" : "CC");
        end
    end
endmodule
