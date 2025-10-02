module inst_fetch_u (
    input logic Pc_src,
    input logic [31:0] alu_result,
    input logic reset,
    input logic clk,
    output logic [31:0] pc,
    output logic [31:0] instr
);
    logic [31:0] pc_next;
    always_ff @(posedge clk or posedge reset)  begin : Pc_update
        if (reset) begin
            pc_next <= 0;

        end else 
            if (Pc_src)
                pc_next <= alu_result;
            else 
                pc_next <= pc + 4;
            
    end

    i_rom instruction_rom (
        .address(pc_next[9:2]),  // bits [9:2] para direccionar 256 palabras
        .data(instr)
    );

    assign pc = pc_next;
    
endmodule