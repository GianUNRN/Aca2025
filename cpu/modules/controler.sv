module controler(
    input logic flags,
    input logic [6:0] opcode,
    input logic [2:0] funct3,
    input logic [6:0] funct7,
    output logic [1:0] alu_src,
    output logic reg_write,
    output logic [1:0] alu_control,
    output logic [2:0] imm_src,
    output logic mem_write,
    output logic [1:0] result_src,
    output logic alu_result_src,
    output logic pc_src, 
    output logic [3:0] cs
);

    always_comb begin
        case (opcode)
            7'b0110011: begin 
                case(funct3)
                    3'b000: begin 
                        case(funct7) 
                            7'b0: begin // ADD
                                reg_write = 1;
                                alu_src = 2'b00;
                                alu_control = 2'b00;
                                mem_write = 0;
                                result_src = 2'b00;
                                pc_src = 0;
                                alu_result_src = 0;
                                imm_src = 3'b000;
                                cs = 4'b0000;

                            end 
                            7'b0100000: begin // SUB
                                reg_write = 1;
                                alu_src = 2'b00;
                                alu_control = 2'b11;
                                mem_write = 0;
                                result_src = 2'b00;
                                pc_src = 0;
                                alu_result_src = 0;
                                imm_src = 3'b000;
                                cs = 4'b0000;
                            end


                            default: begin
                                reg_write = 0;
                                alu_src = 2'b00;
                                alu_control = 2'b00; 
                                mem_write = 0;
                                result_src = 2'b00;
                                pc_src = 0;
                                alu_result_src = 0;
                                imm_src = 3'b000;
                                cs = 4'b0000;
                            end
                        endcase
                    end
                    3'b001: begin //sll
                        reg_write = 1;
                        alu_src = 2'b00;
                        alu_control = 2'b01;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end

                    3'b010: begin //slt
                        reg_write = 1;
                        alu_src = 2'b00;
                        alu_control = 2'b11;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end

                    3'b011:begin //sltu
                        reg_write = 1;
                        alu_src = 2'b00;
                        alu_control = 2'b11;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end

                    3'b100: begin //xor
                        reg_write = 1;
                        alu_src = 2'b00;
                        alu_control = 2'b01;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end

                    3'b101:begin
                        if(funct7 == 7'b0) begin // srl
                            reg_write = 1;
                            alu_src = 2'b00;
                            alu_control = 2'b01;
                            mem_write = 0;
                            result_src = 2'b00;
                            pc_src = 0;
                            alu_result_src = 0;
                            imm_src = 3'b000;
                            cs = 4'b0000;
                        end else begin //sra
                            reg_write = 1;
                            alu_src = 2'b00;
                            alu_control = 2'b11;
                            mem_write = 0;
                            result_src = 2'b00;
                            pc_src = 0;
                            alu_result_src = 0;
                            imm_src = 3'b000;
                            cs = 4'b0000;
                        end
                    end

                    3'b110: begin //Or
                        reg_write = 1;
                        alu_src = 2'b00;
                        alu_control = 2'b01;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end

                    3'b111: begin//And
                        reg_write = 1;
                        alu_src = 2'b00;
                        alu_control = 2'b01;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end
                    


                    default: begin
                        reg_write = 0;
                        alu_src = 2'b00;
                        alu_control = 2'b00; 
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end
                endcase
               
            end
            7'b0010011: begin 
                case(funct3)
                    3'b000: begin // ADDI
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b00;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end

                    3'b001: begin //slli
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b01;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end

                    
                    
                    3'b010: begin //slti
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b11;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 0;
                        cs = 4'b0000;
                    end

                    3'b011: begin //sltiu
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b11;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 0;
                        cs = 4'b0000;
                    end

                    3'b100: begin //xori
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b01;
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 0;
                        cs = 4'b0000;
                    end

                    3'b101: begin
                        if(funct7 == 7'b0) begin //srli
                            reg_write = 1;
                            alu_src = 2'b01;
                            alu_control = 2'b01;
                            mem_write = 0;
                            result_src = 2'b00;
                            pc_src = 0;
                            alu_result_src = 0;
                            imm_src = 0;
                            cs = 4'b0000;
                        end else begin //srai
                            reg_write = 1;
                            alu_src = 2'b01;
                            alu_control = 2'b11;
                            mem_write = 0;
                            result_src = 2'b00;
                            pc_src = 0;
                            alu_result_src = 0;
                            imm_src = 0;
                            cs = 4'b0000;
                        end
                    end


                    3'b110: begin//ori
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b01; 
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end
                    3'b111: begin // ANDI
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b01; 
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end


                    default: begin
                        reg_write = 0;
                        alu_src = 2'b00;
                        alu_control = 2'b00; 
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                        
                    end
                endcase
            end
            7'b0010111: begin //auipc
                reg_write = 1;
                alu_src = 2'b11;
                alu_control = 2'b00; 
                mem_write = 0;
                result_src = 2'b10;
                pc_src = 0;
                alu_result_src = 0;
                imm_src = 3'b100;
                cs = 4'b0000;
            end

            7'b0110111: begin //lui
                reg_write = 1;
                alu_src = 2'b11;
                alu_control = 2'b00; 
                mem_write = 0;
                result_src = 2'b10;
                pc_src = 0;
                alu_result_src = 0;
                imm_src = 3'b100;
                cs = 4'b0000;
            end

            7'b1100011: begin //branch instructions (diferenciadas por funct3)
                reg_write = 0;
                alu_src = 2'b11;
                alu_control = 2'b00; 
                mem_write = 0;
                result_src = 2'b00;
                pc_src = flags;
                alu_result_src = 0;
                imm_src = 3'b010;
                cs = 4'b0000;
            end
            
            7'b1101111 : begin // JAL
                reg_write = 1;
                alu_src = 2'b11;
                alu_control = 2'b00; 
                mem_write = 0;
                result_src = 2'b00;
                pc_src = 1;
                alu_result_src = 1;
                imm_src = 3'b011;
                cs = 4'b0000;
            end 
            7'b1100111: begin //JALR
                reg_write = 1;
                alu_src = 2'b01;
                alu_control = 2'b00; 
                mem_write = 0;
                result_src = 2'b00;
                pc_src = 1;
                alu_result_src = 1;
                imm_src = 3'b011;
                cs = 4'b0000;
            end

            7'b0100011 : begin 
                case(funct3) 
                    3'b000: begin //sb
                        reg_write = 0;
                        alu_src = 2'b01;
                        alu_control = 2'b00;
                        mem_write = 1;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b001;
                        cs = 4'b1; 
                    end

                    3'b001: begin //sh
                        reg_write = 0;
                        alu_src = 2'b01;
                        alu_control = 2'b00;
                        mem_write = 1;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b001;
                        cs = 4'b0011; 
                    end
                    3'b010: begin// SW
                        reg_write = 0;
                        alu_src = 2'b01;
                        alu_control = 2'b00;
                        mem_write = 1;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b001;
                        cs = 4'b1111; 
                    end


                    
                    default: begin
                        reg_write = 0;
                        alu_src = 2'b00;
                        alu_control = 2'b00; 
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000;
                    end
                endcase
            end
            7'b0000011 : begin 
                case(funct3) 
                    3'b000: begin //lb
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b00;
                        mem_write = 0;
                        result_src = 2'b01;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b1; 
                    end

                    3'b001: begin //lh
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b00;
                        mem_write = 0;
                        result_src = 2'b01;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0011; 
                    end

                    3'b010: begin // LW
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b00;
                        mem_write = 0;
                        result_src = 2'b01;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b1111;
                    end

                    3'b100: begin //lbu
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b00;
                        mem_write = 0;
                        result_src = 2'b01;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b1; 
                    end

                    3'b101: begin //lhu
                        reg_write = 1;
                        alu_src = 2'b01;
                        alu_control = 2'b00;
                        mem_write = 0;
                        result_src = 2'b01;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0011; 
                    end

                    default: begin
                        reg_write = 0;
                        alu_src = 2'b00;
                        alu_control = 2'b00; 
                        mem_write = 0;
                        result_src = 2'b00;
                        pc_src = 0;
                        alu_result_src = 0;
                        imm_src = 3'b000;
                        cs = 4'b0000; 
                    end
                endcase
            end

            
           

            default: begin
                reg_write = 0;
                alu_src = 2'b00;
                alu_control = 2'b00; 
                mem_write = 0;
                result_src = 2'b00;
                pc_src = 0;
                alu_result_src = 0;
                imm_src = 3'b000;
                cs = 4'b0000;
            end
        endcase
    end
endmodule