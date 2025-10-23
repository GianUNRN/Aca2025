module top(
    input logic clk,
    input logic rst,
    input logic button,
    input logic [15:0] sw,
    
    output logic [15:0] leds_out,
    output logic [6:0]          seg,      // Segment outputs (a-g)
    output logic [7:0]    an,       // Anode/Cathode control lines
    output logic        dp 

);
    logic [31:0] alu_result;
    logic [31:0] pc;
    logic [4:0] rd;
    logic [31:0] reg_data_2,reg_data_1, data_out;
    logic reset;    
    
    debouncer #(.WIDTH(1), .SAMPLES(3)) u_debouncer (
        .clk(clk),
        .rst(rst),
        .noisy_in(button),
        .clean_out(reset)
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
        .leds_out(leds_out),
        .seg(seg),
        .an(an),    
        .dp(dp)
    );
    
endmodule