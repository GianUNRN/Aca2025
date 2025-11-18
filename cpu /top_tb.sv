module top_tb ();

    logic clk;
    logic rst;
    logic button;
    logic [15:0] sw, leds_out;
    logic [6:0]          seg;      // Segment outputs (a-g)
    logic [7:0]    an;       // Anode/Cathode control lines
    logic        dp ;
    logic uart_rx, uart_tx;

    top top(
        .*
    );

    initial begin
        button = 0;
        rst = 1;
        clk = 0;
    end
    always #5 clk = ~clk;

    initial begin       
        
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);
        #7
        rst = 0;
        button = 1;
        
        repeat(4) @(posedge clk);
        button = 0;
        sw = 16'h7f39;
        repeat(50) @(posedge clk);
        
        $finish;
    end

endmodule