module register_file(
    input logic clk,
    input logic we,
    input logic [4:0] ra1, ra2, wa,
    input logic [31:0] wd,
    output logic [31:0] rd1, rd2
);
    logic [31:0] rf [0:31];

    // Inicializar todos los registros a 0
    // initial begin
    //     $readmemb("init.txt", rf);
    // end

    assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
    assign rd2 = (ra2 != 0) ? rf[ra2] : 0;

    always_ff @(posedge clk) begin
        if (we && wa != 0) rf[wa] <= wd;
    end

    
endmodule