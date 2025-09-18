`timescale 1ns/1ps

module multi_d_counter #(
    parameter int NUM_DIG = 2
)(
    input  logic clk,
    input  logic rst,
    input  logic en,
    input  logic up, // Up counting direction 
    output logic [3:0] digits [NUM_DIG-1:0] // arreglo de dígitos
);

    genvar i;

    generate
        for (i = 0; i < NUM_DIG; i = i + 1) begin : digit_inst
            logic pulse_in;
            
            // Habilitación: el primero siempre usa 'en', los siguientes usan el pulso del dígito anterior
            logic en_i = (i == 0) ? en : digit_inst[i-1].pulse_out;

            // Instancio el contador de 0-9 por dígito
            digit_counter u_digit (
                .clk(clk),
                .rst(rst),
                .en(en_i),
                .count(digits[i]),
                .pulse_out(pulse_in)
            );

            // Guardar el pulso en un nombre consistente dentro del generate block
            assign digit_inst[i].pulse_out = pulse_in;
        end
    endgenerate

endmodule


