module comp(
    input logic [31:0] r1, r2, 
    input logic [2:0] funct3,
    output logic eq
);
    always_comb begin
        case(funct3)
            3'b000: eq = ($signed(r1) == $signed(r2));
            3'b001: eq = ($signed(r1) != $signed(r2));
            3'b100: eq = ($signed(r1) < $signed(r2));
            3'b101: eq = ($signed(r1) >= $signed(r2));
            3'b110: eq = ($unsigned(r1) < $unsigned(r2));
            3'b111: eq = ($unsigned(r1) >= $unsigned(r2));
            default: eq = 0;
        endcase
    end
    
endmodule