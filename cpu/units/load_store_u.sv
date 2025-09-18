module load_store_u (
    input logic clk,
    input logic [31:0] alu_result,
    input logic [31:0] reg_data_2,
    input logic [2:0] funct3,
    input logic mem_write,
    output logic [31:0] mem_data_out
);

    memory mem(
        .clk(clk),
        .we(mem_write),
        .addr(alu_result[9:2]), 
        .wd(reg_data_2),
        .rd(mem_data_out)
    );
    
endmodule