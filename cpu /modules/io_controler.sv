module io_controler(
    input  logic        w_enable,
    input  logic [5:0]  addr,
    input  logic [3:0]  cs_in,
    input  logic [31:0] data_in,

    output logic [31:0] data_mem, 
    output logic [15:0] data_leds,
    output logic [31:0] data_7seg,
    output logic        w_enable_data_mem,
    output logic [3:0]  cs_out,
    output logic [5:0]  io_enable,
    output logic [7:0]  data_uart
);

    //io_enable[0] = leds
    //io_enable[1] = switches
    //io_enable[2] = buttons
    //io_enable[3] = 7seg
    //io_enable[4] = UART_rx
    //io_enable[5] = UART_tx 

    always_comb begin
        // Default
        io_enable        = 6'b000000;
        w_enable_data_mem = 1'b0;
        cs_out           = '0;

        data_leds = data_in[15:0];
        data_mem  = data_in;
        data_7seg = data_in;
        data_uart = data_in[7:0];

        // ----- MEMORY SPACE -----
        if (addr[5] == 0) begin
            w_enable_data_mem = w_enable;
            cs_out = cs_in;
        end

        // ----- IO SPACE -----
        else begin
            case (addr[4:0])

                5'd0: begin // UART (address 32)
                    io_enable[5] = w_enable;  // UART_tx write
                    io_enable[4] = ~w_enable; // UART_rx read
                end

                5'd8: begin // 40 -> LEDs
                    io_enable[0] = w_enable;
                end

                5'd9: begin // 41 -> switches
                    io_enable[1] = 1'b1;  // read
                end

                5'd10: begin // 42 -> buttons
                    io_enable[2] = 1'b1;  // read
                end

                5'd11: begin // 43 -> 7seg
                    io_enable[3] = w_enable;
                end

                default: begin
                    io_enable = 6'b000000;
                end
            endcase
        end
    end

endmodule
