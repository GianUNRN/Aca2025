`timescale 1ns/1ps

module two_d_counter (
    input  logic clk,
    input  logic rst,
    input  logic en, 
    output logic [3:0] units,
    output logic [3:0] tens
);

    logic tc_units;

    // Units counter (0–9)
    counter #(.N(4),.MAX(9)) cnt1  (
        .clk(clk),
        .rst_n(rst),
        .en(en),         // Always enabled
        .count(units),
        .pulse(tc_units)
    );

    // Tens counter (0–9), enabled by units terminal count
    counter  #(.N(4),.MAX(9)) cnt2 (
        .clk(clk),
        .rst_n(rst),
        .en(tc_units),     // Enabled when units counter overflows
        .count(tens),
        .pulse()                  // Not used here
    );

endmodule


