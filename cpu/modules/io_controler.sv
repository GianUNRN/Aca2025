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
    output logic [3:0] io_enable

);
    //io_enable[0] = leds
    //io_enable[1] = switches
    //io_enable[2] = buttons

    //address 32 io devices
    //32     leds
    //33     switches
    //34    buttons
    //35    7seg displays
    

    always_comb begin
    // Default assignments
        io_enable = 4'b0000;
        w_enable_data_mem = 1'b0;
        cs_out = '0;
        data_leds = data_in[15:0];
        data_mem = data_in;
        data_7seg = data_in;
        
        
        
        if (addr[5] == 0) begin
            io_enable = 4'b0000;
            w_enable_data_mem = w_enable;
            cs_out = cs_in;
            
        end
        else begin
            case (addr[3:0])
                4'd0: begin //leds
                    io_enable = {3'b000, w_enable};
                    w_enable_data_mem = 1'b0;
                    cs_out = '0;
                end
                4'd1: begin //switches
                    io_enable = 4'b0010;
                    w_enable_data_mem = 1'b0;
                    cs_out = '0;
                end
                4'd2: begin //buttons
                    io_enable = 4'b0100;
                    w_enable_data_mem = 1'b0;
                    cs_out = '0;
                end

                4'd3: begin //7seg displays
                    io_enable = {w_enable,3'b000 };
                    w_enable_data_mem = 1'b0;
                    cs_out = '0;
                end
            
                default: begin
                    io_enable = 4'b0000;
                    w_enable_data_mem = 1'b0;
                    cs_out = '0;
                end

            endcase
           
        end
    end
endmodule
