module leds (
    input logic clk,
    input logic en,
    input logic rst,
    input logic [7:0] data,
    output logic [7:0] leds_out
);
    logic [7:0] leds_next;
    always_ff @(posedge clk) begin
        if(rst) begin
            leds_next <= '0;

        end else if(en) leds_next <= data;

    end

    assign leds_out = leds_next;
    
endmodule