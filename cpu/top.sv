module top(
    input logic clk,
    input logic reset,
    input logic [7:0] sw,
    output logic [31:0] alu_result,
    output logic [31:0] pc,
    output logic [4:0] rd, 
    output logic [31:0] reg_data_2,reg_data_1, data_out,
    output logic [7:0] leds_out 

);
    logic Pc_src;
    logic mem_write;
    
    logic [31:0] instr;

    logic [3:0] cs;
    

    inst_fetch_u ifu(
        .Pc_src(Pc_src),
        .alu_result(alu_result),
        .reset(reset),
        .clk(clk),
        .pc(pc),
        .instr(instr)
    );


    inst_execution_u  ieu(
    .clk(clk),
    .instr(instr),
    .mem_data(data_out),
    .pc(pc),
    .pc_src(Pc_src),
    .alu_result(alu_result),
    .reg_data_2(reg_data_2),
    .reg_data_1(reg_data_1),
    .rd(rd),
    .cs(cs),
    .mem_write(mem_write)

    );

    io_dev_u ios(
        .clk(clk),
        .rst(reset),
        .cs(cs),
        .sw(sw),
        .alu_result(alu_result),
        .reg_data_2(reg_data_2),
        .funct3(instr[14:12]),
        .mem_write(mem_write),
        .data_out(data_out),
        .leds_out(leds_out)
        
    );
    
endmodule