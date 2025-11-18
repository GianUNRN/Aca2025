module memory #(
    parameter int WIDTH = 32
)(
    input logic clk,
    input logic we,
    input logic cs,
    input logic [4:0] addr,
    input logic [WIDTH-1:0] wd,
    output logic [WIDTH-1:0] rd
);
    logic [WIDTH-1:0] mem [32];

    initial begin
        for (int i = 0; i < 32; i++) begin
            mem[i] = '0;
        end
    end

    assign rd = cs ?  mem[addr]: '0;


    always_ff @(posedge clk) begin
        if (we & cs) mem[addr] <= wd;
    end
endmodule