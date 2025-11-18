module alu(
    input logic [31:0] a, b,
    input logic [1:0] alu_control,
    input logic [2:0] funct3,
    output logic [31:0] alu_result
);
    always_comb begin
        case (alu_control)
            2'b00: alu_result = a + b;
            2'b01:begin
                case (funct3)
                    3'b000: alu_result = a + b; // ADD
                    3'b110: alu_result = a | b; // OR
                    3'b111: alu_result = a & b; // AND
                    3'b001: alu_result = a << b[4:0]; //sll
                    3'b101: alu_result = a >> b[4:0];//srl
                    3'b100: alu_result = a ^ b; //xor
                    default: alu_result = a + b;
                endcase
            end
            2'b11: begin
                case (funct3)
                    3'b000: alu_result = a - b; // SUB
                    3'b010: alu_result = $signed(a) < $signed(b) ? 1 : 0; // SLT
                    3'b011: alu_result = $unsigned(a) < $unsigned(b) ? 1:0; //SLTU
                    3'b101: alu_result = $signed(a) >>> b[4:0]; //sra
                    default: alu_result = a + b;
                endcase
            end
            default: alu_result = a + b;
        endcase
    end
endmodule