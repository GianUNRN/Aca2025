module alu(
    input logic [31:0] a, b,
    input logic [1:0] alu_control,
    output logic [31:0] alu_result
);
    always_comb begin
        case (alu_control)
            2'b00: alu_result = a + b;
            // Podemos agregar más operaciones aquí
            default: alu_result = a + b;
        endcase
    end
endmodule