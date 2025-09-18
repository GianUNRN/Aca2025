module inst_execution_u (
    input logic clk,
    input logic [31:0] instr,
    input logic [31:0] mem_data,
    input logic [31:0] pc_next,
    output logic pc_src,
    output logic [31:0] alu_result,
    output logic [31:0] reg_data_2

);

    
    
    

    logic flags;
    logic alu_result_src;
    

    logic [31:0] imm_ext;

    logic [6:0] opcode;
    assign opcode = instr[6:0];
    
    logic [11:7] rd;
    assign rd = instr[11:7];

    
    logic [2:0] funct3;
    assign funct3 = instr[14:12];

    logic [4:0] rs1,rs2;
    assign rs1 = instr[19:15];
    assign rs2 = instr[24:20];

    logic [6:0] funct7;
    assign funct7 = instr[31:25];


    
    logic [1:0] alu_src;
    logic reg_write;
    logic [1:0] alu_control;
    logic mem_write;
    
    logic result_src;


    logic [31:0] reg_data_1;


    comp comparer (
        .r1(reg_data_1),
        .r2(reg_data_2),
        .eq(flags)
    );


    
    // Unidad de control
    controler control (
    .flags(flags),
    .opcode(opcode),
    .funct3(funct3),
    .funct7(funct7),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .alu_control(alu_control),
    .mem_write(mem_write),
    .result_src(result_src),
    .alu_result_src(alu_result_src),
    .pc_src(pc_src)
    );


    // Extensor de inmediato
    sign_extender sign_ext (
        .instr(instr),
        .imm_ext(imm_ext)
    );
    

    
    logic [31:0] alu_src_a, alu_src_b;

    assign alu_src_b = alu_src[0] ? imm_ext : reg_data_2;
    assign alu_src_a = alu_src[1] ? pc_next : reg_data_1 ;

    // ALU
    alu alu_unit (
        .a(alu_src_a),
        .b(alu_src_b),
        .alu_control(alu_control),  
        .alu_result(alu_result)
    );

    
    logic [31:0] ieu_result;

    always_comb begin : Mux_write_reg
        if (alu_result_src)
            ieu_result = pc_next ;
        else
            ieu_result = alu_result;
    end


    logic [31:0] result;
    assign result = result_src ? mem_data : ieu_result;
    
    // Banco de registros
    register_file reg_file (
        .clk(clk),
        .we(reg_write),
        .ra1(rs1),
        .ra2(rs2),
        .wa(rd),
        .wd(result),  // En este diseño simple, siempre escribimos el resultado de la ALU
        .rd1(reg_data_1),
        .rd2(reg_data_2)
    );
    
    
    
endmodule