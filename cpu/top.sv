module top(
    input logic clk,
    input logic reset
);
    logic Pc_src;
    logic mem_write;
    logic [31:0] pc_next;
    logic [31:0] instr;
    logic [31:0] mem_data;
    logic [31:0] alu_result;
    logic [31:0] reg_data_2;

    inst_fetch_u ifu(
        .Pc_src(Pc_src),
        .alu_result(alu_result),
        .reset(reset),
        .clk(clk),
        .pc_next(pc_next),
        .instr(instr)
    );


    inst_execution_u  ieu(
    .clk(clk),
    .instr(instr),
    .mem_data(mem_data),
    .pc_next(pc_next),
    .pc_src(Pc_src),
    .alu_result(alu_result),
    .reg_data_2(reg_data_2)
    );

    load_store_u lsu(
        .clk(clk),
        .alu_result(alu_result),
        .reg_data_2(reg_data_2),
        .funct3(instr[14:12]),
        .mem_write(mem_write),
        .mem_data_out(mem_data)
    );
    
endmodule