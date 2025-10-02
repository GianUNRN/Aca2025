module top_tb ();

    logic clk;
    logic reset;
    logic [31:0] alu_result, pc, reg_data_2,reg_data_1,data_out ;
    logic [4:0] rd;
    logic [7:0] sw, leds_out;


    top top(
        .*
    );

    initial begin
        reset = 1;
        clk = 0;
    end
    always #5 clk = ~clk;

    initial begin       
        
        $dumpfile("wave.vcd");
        $dumpvars(0, top_tb);
        #7
        reset = 0;
        sw = 8'd99;
        repeat(50) @(posedge clk);
        
        $finish;
    end

endmodule