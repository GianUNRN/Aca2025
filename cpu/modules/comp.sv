module comp(
    input logic [31:0] r1, r2, 
    output logic eq
);
    assign eq = (r1 == r2);
endmodule