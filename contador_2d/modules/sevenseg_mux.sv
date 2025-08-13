`timescale 1ns/1ps
module sevenseg_mux (
    input  logic        clk,           // System clock
    input  logic        rst,           // Synchronous reset (active high)
    input  logic        en,            // Enable to switch digit
    input  logic        cathod_anode,  // 1 = common anode, 0 = common cathode
    input  logic [6:0]  tens_seg,      // Pre-encoded tens digit segments (a-g) in common-anode format
    input  logic [6:0]  units_seg,     // Pre-encoded units digit segments (a-g) in common-anode format
    output logic [6:0]  seg_out,       // Output to segment lines
    output logic [1:0]  an             // Anode/Cathode control lines (active depends on type)
);

    logic sel_digit; // 0 = units, 1 = tens
    logic [6:0] raw_seg;

    // Toggle digit selection only on enable
    always_ff @(posedge clk) begin
        if (!rst)
            sel_digit <= 1'b1;  // Start with units
        else if (en)
            sel_digit <= ~sel_digit;
    end

    // Select which digit's segments to output
    always_comb begin
        if (sel_digit == 1'b1) begin
            an      = cathod_anode ? 2'b01 : 2'b10; // For CA: '0' active, CC: '1' active
            raw_seg = units_seg;
        end else begin
            an      = cathod_anode ? 2'b10 : 2'b01;
            raw_seg = tens_seg;
        end
    end

    // Adjust segment polarity based on display type
    always_comb begin
        if (cathod_anode)
            seg_out = raw_seg;       // Active low for CA (already in CA format)
        else
            seg_out = ~raw_seg;      // Invert for CC (active high)
    end

endmodule