module controler(
    input logic flags,
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic [1:0] alu_src,
    output logic reg_write,
    output logic [1:0] alu_control,
    output logic mem_write,
    output logic result_src,
    output logic alu_result_src,
    output logic pc_src
);

    always_comb begin
        case (opcode)
            7'b0110011: begin // ADD
                if (funct3 == 3'b000 && funct7 == 7'b0) begin
                    reg_write = 1;
                    alu_src = 2'b00;
                    alu_control = 2'b00;
                    mem_write = 0;
                    result_src = 0;
                    pc_src = 0;
                    alu_result_src = 0;
                    
                end else begin
                    reg_write = 0;
                    alu_src = 2'b00;
                    alu_control = 2'b00; 
                    mem_write = 0;
                    result_src = 0;
                    pc_src = 0;
                    alu_result_src = 0;

                end
            end
            7'b0010011: begin // ADDI
                if (funct3 == 3'b000) begin
                    reg_write = 1;
                    alu_src = 2'b01;
                    alu_control = 2'b00;
                    mem_write = 0;
                    result_src = 0;
                    pc_src = 0;
                    alu_result_src = 0;

                end else begin
                    reg_write = 0;
                    alu_src = 2'b00;
                    alu_control = 2'b00; 
                    mem_write = 0;
                    result_src = 0;
                    pc_src = 0;
                    alu_result_src = 0;
                    
                end
            end
            7'b1100011: begin //BEQ
                if (funct3 == 3'b000) begin
                    reg_write = 0;
                    alu_src = 2'b11;
                    alu_control = 2'b00; 
                    mem_write = 0;
                    result_src = 0;
                    pc_src = flags;
                    alu_result_src = 0;
                    
                end else begin
                    reg_write = 0;
                    alu_src = 2'b00;
                    alu_control = 2'b00; 
                    mem_write = 0;
                    result_src = 0;
                    pc_src = 0;
                    alu_result_src = 0;
                    
                end
            end
            
            7'b1101111 : begin // JAL
                reg_write = 1;
                alu_src = 2'b11;
                alu_control = 2'b00; 
                mem_write = 0;
                result_src = 0;
                pc_src = 1;
                alu_result_src = 1;
                
            end 

            7'b0100011 : begin // SW
                if (funct3 == 3'b010) begin
                    reg_write = 0;
                    alu_src = 2'b01;
                    alu_control = 2'b00;
                    mem_write = 1;
                    result_src = 1;
                    pc_src = 0;
                    alu_result_src = 0;
                     
                end else begin
                    reg_write = 0;
                    alu_src = 2'b00;
                    alu_control = 2'b00; 
                    mem_write = 0;
                    result_src = 0;
                    pc_src = 0;
                    alu_result_src = 0;

                end
            end
            7'b0000011 : begin // LW
                if (funct3 == 3'b010) begin
                    reg_write = 1;
                    alu_src = 2'b01;
                    alu_control = 2'b00;
                    mem_write = 0;
                    result_src = 0;
                    pc_src = 0;
                    alu_result_src = 0;
                end else begin
                    reg_write = 0;
                    alu_src = 2'b00;
                    alu_control = 2'b00; 
                    mem_write = 0;
                    result_src = 0;
                    pc_src = 0;
                    alu_result_src = 0;
                    
                end
            end

            default: begin
                reg_write = 0;
                alu_src = 2'b00;
                alu_control = 2'b00; 
                mem_write = 0;
                result_src = 0;
                pc_src = 0;
                alu_result_src = 0;
                
            end
        endcase
    end
endmodule