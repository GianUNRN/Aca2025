module i_rom (
    input  logic [7:0] address,   // 8 bits = 256 posiciones
    output logic [31:0] data
);
    // Memoria de 256 palabras de 32 bits
    logic [31:0] memory [0:255];
    
    // Inicialización con algunas instrucciones de ejemplo
    initial begin
        // Inicializar toda la memoria con NOPs (ADDI x0, x0, 0)
        for (int i = 0; i < 256; i++) begin
            memory[i] = 32'h00000013;
        end
        
        // Programa de ejemplo
        memory[0] = 32'h00200093;  // ADDI x1, x0, 2   (x1 = 2)
        memory[1] = 32'h00300113;  // ADDI x2, x0, 3   (x2 = 3)
        memory[2] = 32'h002081b3;  // ADD  x3, x1, x2  (x3 = 5)
        memory[3] = 32'h00400213;  // ADDI x4, x0, 4   (x4 = 4)
        memory[4] = 32'h003202b3;  // ADD  x5, x4, x3  (x5 = 9)
        
        // Podemos agregar más instrucciones aquí...
    end
    
    // Lectura asíncrona
    assign data = memory[address];
endmodule