module segmented_memory (
    input logic clk,
    input logic [3:0] cs,
    input logic [4:0] addr,
    input logic [31:0] data,
    input logic mem_write,
    output logic [7:0] mem_data_0,mem_data_1,mem_data_2, mem_data_3
);
    

    memory #(.WIDTH(8)) mem0 (
        .clk(clk),
        .cs(cs[0]),
        .we(mem_write),
        .addr(addr), 
        .wd(data[7:0]),
        .rd(mem_data_0)
    );

    memory #(.WIDTH(8)) mem1 (
        .clk(clk),
        .cs(cs[1]),
        .we(mem_write),
        .addr(addr), 
        .wd(data[15:8]),
        .rd(mem_data_1)
    );

    memory #(.WIDTH(8)) mem2 (
        .clk(clk),
        .cs(cs[2]),
        .we(mem_write),
        .addr(addr), 
        .wd(data[23:16]),
        .rd(mem_data_2)
    );

    memory #(.WIDTH(8)) mem3 (
        .clk(clk),
        .cs(cs[3]),
        .we(mem_write),
        .addr(addr), 
        .wd(data[31:24]),
        .rd(mem_data_3)
    );
endmodule