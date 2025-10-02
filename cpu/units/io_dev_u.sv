module io_dev_u(
    input logic clk,
    input logic rst,
    input logic [7:0] sw,
    input logic [3:0] cs,
    input logic [31:0] alu_result,
    input logic [31:0] reg_data_2,
    input logic [2:0] funct3,
    input logic mem_write,
    output logic [31:0] data_out,
    output logic [7:0] leds_out
);

    logic [7:0] mem_data_0,mem_data_1,mem_data_2, mem_data_3;
    logic [7:0] decoded_swithces;
    logic w_enable_data_mem;
    logic [3:0] cs_out;
    logic [2:0] io_enable;

    logic [31:0] mem_data_out;

    io_controler io_controler_instance (
        .w_enable(mem_write),
        .addr(alu_result[5:0]),
        .cs_in(cs),
        .w_enable_data_mem(w_enable_data_mem),
        .cs_out(cs_out),
        .io_enable(io_enable)
    );
    
    segmented_memory segmented_memory_instance (
        .clk(clk),
        .cs(cs_out),
        .addr(alu_result[4:0]),
        .data(reg_data_2),
        .mem_write(w_enable_data_mem),
        .mem_data_0(mem_data_0),
        .mem_data_1(mem_data_1),
        .mem_data_2(mem_data_2),
        .mem_data_3(mem_data_3)
    );

    always_comb begin
        case(funct3)
            3'b000: mem_data_out = {{24{mem_data_0[7]}}, mem_data_0};

            3'b001: mem_data_out = {{16{mem_data_1[7]}}, mem_data_1, mem_data_0};

            3'b010: mem_data_out = {mem_data_3,mem_data_2,mem_data_1,mem_data_0 };

            3'b100: mem_data_out =  {{24{1'b0}}, mem_data_0};
            
            3'b101: mem_data_out = {{16{1'b0}}, mem_data_1, mem_data_0};
            default: mem_data_out = {mem_data_3,mem_data_2,mem_data_1,mem_data_0 };
        endcase
    end
    
    leds leds_instance (
        .rst(rst),
        .clk(clk),
        .en(io_enable[0]),
        .data(reg_data_2[7:0]),
        .leds_out(leds_out)
    );
    
    switches switches_instance (
        .sw(sw),
        .decoded_swithces(decoded_swithces)
    );

    always_comb begin : MUX_DATA_READ
        case(io_enable[2:1])
            2'b00: data_out = mem_data_out;
            2'b01: data_out = {{24{1'b0}},decoded_swithces};
            default: data_out = '0;
        endcase
    end
    
endmodule