module sevenseg_dec (
    input  logic [3:0] bin_in,      // 4-bit binary input (0 to 15)
    output logic [6:0] seg_dec    // 7-segment output: {a, b, c, d, e, f, g}
   
);

    always_comb begin
        case (bin_in)
            
            4'h0: seg_dec = 7'h40; // 0 
            4'h1: seg_dec = 7'h79; // 1
            4'h2: seg_dec = 7'h24; // 2
            4'h3: seg_dec = 7'h30; // 3
            4'h4: seg_dec = 7'h19; // 4
            4'h5: seg_dec = 7'h12; // 5
            4'h6: seg_dec = 7'h02; // 6
            4'h7: seg_dec = 7'h78; // 7
            4'h8: seg_dec = 7'h00; // 8
            4'h9: seg_dec = 7'h10; // 9
            4'hA: seg_dec = 7'h08; // A
            4'hB: seg_dec = 7'h03; // B
            4'hC: seg_dec = 7'h46; // C
            4'hD: seg_dec = 7'h21; // D
            4'hE: seg_dec = 7'h06; // E
            4'hF: seg_dec = 7'h0E; // F
            default: seg_dec = 7'h40;
        endcase
        
    end

endmodule