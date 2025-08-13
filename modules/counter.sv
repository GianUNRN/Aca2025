`timescale 1ns/1ps
module counter #(
    parameter int N=16,
    parameter int MAX = 2**N-1
    ) (
    input logic clk,
    input logic rst_n,
    input logic en,
    output logic [N-1:0] count,
    output logic pulse
);
    assign pulse = (en && count == MAX);

    always_ff @(posedge clk) begin
        if (!rst_n) begin
            count <= '0;
        end else if (en) begin
            if (count == MAX) begin
                count <= '0;
            end else begin
                count <= count + 1;
            end
        end
    end

endmodule