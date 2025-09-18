module memory(
    input logic clk,
    input logic we,
    input logic [4:0] addr,
    input logic [31:0] wd,
    output logic [31:0] rd
);
    logic [9:0] mem [32];

    
    assign rd = {22'b0,mem[addr]} ;


    always_ff @(posedge clk) begin
        if (we) mem[addr] <= wd[9:0];
    end
endmodule