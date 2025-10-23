module switches (
    input logic [15:0] sw,
    output logic [15:0] decoded_switches
);
    assign decoded_switches = sw;
endmodule