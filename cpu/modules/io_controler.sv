module io_controler(
    input logic w_enable,
    input logic [5:0] addr,
    input logic [3:0] cs_in,
    input logic [31:0] data_in,
    output logic [31:0] data_mem, 
    output logic [15:0]  data_leds,
    output logic [31:0]  data_7seg,
    output logic w_enable_data_mem,
    output logic [3:0] cs_out,
    output logic [5:0] io_enable,

    output logic [7:0] data_uart
   

);
    //io_enable[0] = leds
    //io_enable[1] = switches
    //io_enable[2] = buttons
    //io_enable[3] = 7seg
    //io_enable[4] = UART_rx
    //io_enable[5] = UART_tx 

    //address mapping for IO devices
    //32 UART 
    //40:    leds     (addr[5]=1, addr[4]=1, addr[3:0]=0000)
    //41:    switches (addr[5]=1, addr[4]=1, addr[3:0]=0001)
    //42:    buttons  (addr[5]=1, addr[4]=1, addr[3:0]=0010)
    //43:    7seg     (addr[5]=1, addr[4]=1, addr[3:0]=0011)

    always_comb begin
        // Default assignments
        io_enable = 6'd0;
        w_enable_data_mem = 1'b0;
        cs_out = '0;
        data_leds = data_in[15:0];
        data_mem = data_in;
        data_7seg = data_in;
        data_uart = data_in[7:0] ;



        if (addr[5] == 0) begin
            // Memory space
            io_enable = 6'd0;
            w_enable_data_mem = w_enable;
            cs_out = cs_in;
        end
        else if (addr[4] == 1) begin
            // Other I/O devices (LEDs, switches, buttons, 7seg)
            case (addr[3:0])
                4'd0: begin //leds
                    io_enable = {5'd0, w_enable};
                    w_enable_data_mem = 1'b0;

                    cs_out = '0;
                end
                4'd1: begin //switches
                    io_enable = 6'b000010;
                    w_enable_data_mem = 1'b0;

                    cs_out = '0;
                end
                4'd2: begin //buttons
                    io_enable = 6'b000100;
                    w_enable_data_mem = 1'b0;

                    cs_out = '0;
                end
                4'd3: begin //7seg displays
                    io_enable = {2'd0,w_enable, 3'b000};
                    w_enable_data_mem = 1'b0;

                    cs_out = '0;
                end
                default: begin
                    io_enable = 6'd0;
                    w_enable_data_mem = 1'b0;

                    
                end
            endcase
        end
        else begin
            // UART space (handled by separate signals above)
            io_enable = {w_enable,~w_enable, 4'b0000};
            

        end
    end
endmodule
