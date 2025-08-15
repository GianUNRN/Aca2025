module debouncer #(
    parameter int SAMPLES = 4,
    parameter int WIDTH   = 1
)(
    input  logic                  clk,
    input  logic                  rst,
    input  logic [WIDTH-1:0]      noisy_in,
    output logic [WIDTH-1:0]      clean_out
);
    // Wires between stages
    logic [SAMPLES:0][WIDTH-1:0] sample;

    assign sample[0] = noisy_in; // first FF input
    assign clean_out = &sample;


    genvar i;
    generate
        for (i = 0; i < SAMPLES; i++) begin : ff_chain
            flip_flop_d #(.WIDTH(WIDTH)) ff_inst (
                .clk(clk),
                .rst(rst),
                .d(sample[i]),
                .q(sample[i+1])
            );
        end
    endgenerate
endmodule