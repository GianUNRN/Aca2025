module inst_execution_u (
    input logic clk,
    input logic [31:0] instr,
    input logic [31:0] mem_data,
    input logic [31:0] pc,
    output logic pc_src,
    output logic [31:0] alu_result,
    output logic [31:0] reg_data_1, reg_data_2,
    output logic [4:0] rd,
    output logic [3:0] cs,
    output logic mem_write

);

    

    logic flags;
    logic alu_result_src;
    logic [2:0] imm_src;
    
    
    logic [31:0] imm_ext;

    logic [6:0] opcode;
    assign opcode = instr[6:0];
    
    
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
    
    
    logic [1:0] result_src;



    comp comparer (
        .r1(reg_data_1),
        .r2(reg_data_2),
        .eq(flags),
        .funct3(funct3)
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
    .imm_src(imm_src),
    .mem_write(mem_write),
    .result_src(result_src),
    .alu_result_src(alu_result_src),
    .pc_src(pc_src),
    .cs(cs)
    );


    // Extensor de inmediato
    sign_extender sign_ext (
        .instr(instr),
        .imm_src(imm_src),
        .imm_ext(imm_ext)
    );
    

    
    logic [31:0] alu_src_a, alu_src_b;

    always_comb begin : Mux_alu_src_b
        alu_src_b = alu_src[0] ? imm_ext : reg_data_2;
    end
    

    always_comb begin : Mux_alu_src_a
        alu_src_a = alu_src[1] ? pc + 4 : reg_data_1 ;
    end
    // ALU
    alu alu_unit (
        .a(alu_src_a),
        .b(alu_src_b),
        .funct3(funct3),
        .alu_control(alu_control),  
        .alu_result(alu_result)
    );

    
    logic [31:0] ieu_result;

    always_comb begin : Mux_write_reg
        if (alu_result_src)
            ieu_result = pc + 4;
        else
            ieu_result = alu_result;
    end


    logic [31:0] result;
    always_comb begin : Mux_result
        case(result_src)
            2'b01: result = mem_data;
            2'b00: result = ieu_result;
            2'b10: result = imm_ext;
            default: result = ieu_result;
        endcase
 
    end
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