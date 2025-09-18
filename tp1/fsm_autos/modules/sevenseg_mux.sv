module sevenseg_mux #(
    parameter N = 2  // Number of digits
) (
    input  logic clk,            // System clock
    input  logic reset,          // Synchronous reset (active high)
    input  logic en,             // Enable digit advance
    input  logic cathod,
    input  logic [6:0] digit_values [N],  // 7-seg configs
    output logic [6:0] seg_out,      // Active segment configuration
    output logic [N-1:0] an     // Active digit (active low)
);

    logic [$clog2(N)-1:0] digit_index;  // Current digit index
    logic [6:0] seg;    // Active segment configuration
    logic [N-1:0] dig; 
    always_ff @(posedge clk) begin
        if (!reset) begin
            digit_index <= 0;
            seg <= '1;        // All segments off
            dig <= {N{1'b1}}; // All digits off
        end else begin
            if (en) begin
                // Advance to next digit
                if (digit_index == $bits(digit_index)'(N-1))
                    digit_index <= 0;
                else
                    digit_index <= digit_index + 1;
            end
            
            // Output current digit's segment configuration
            seg <= digit_values[digit_index];
            
            // Generate active-low one-hot digit select
            dig <= ~(1 << digit_index);
        end
    end

    // Adjust segment polarity based on display type
    always_comb begin
        if (cathod) begin
            seg_out = seg;       // Active low for CA (already in CA format)
            an = ~dig;
        end else begin
            seg_out = ~seg;      // Invert for CC (active high)
            an = dig;
        end
    end

endmodule