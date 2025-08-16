module sevenseg_mux #(
    parameter N = 2  // Number of digits
) (
    input  logic clk,            // System clock
    input  logic reset,          // Synchronous reset (active high)
    input  logic en,             // Enable digit advance
    input  logic [6:0] digit_values [N-1:0],  // 7-seg configs
    output logic [6:0] seg,      // Active segment configuration
    output logic [N-1:0] dig     // Active digit (active low)
);

    logic [$clog2(N)-1:0] digit_index;  // Current digit index

    always_ff @(posedge clk) begin
        if (!reset) begin
            digit_index <= 0;
            seg <= '1;        // All segments off
            dig <= {N{1'b1}}; // All digits off
        end else begin
            if (en) begin
                // Advance to next digit
                if (digit_index == N-1)
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
endmodule