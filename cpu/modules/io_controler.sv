module io_controler(
    input logic w_enable,
    input logic [5:0] addr,
    input logic [3:0] cs_in,

    output logic w_enable_data_mem,
    output logic [3:0] cs_out,
    output logic [2:0] io_enable
);
    //io_enable[0] = leds
    //io_enable[1] = switches
    //io_enable[2] = buttons

    //address 32 io devices
    //32     leds
    //33     swithces
    //34    buttons

    

    always_comb begin
    // Default assignments
        io_enable = 3'b000;
        w_enable_data_mem = 1'b0;
        cs_out = '0;
        
        
        if (addr <= 31) begin
            io_enable = 3'b000;
            w_enable_data_mem = w_enable;
            cs_out = cs_in;
        end
        else if (addr == 32) begin
            io_enable = {2'b00, w_enable};
            w_enable_data_mem = 1'b0;
            cs_out = '0;
        end
        else if (addr == 33) begin
            io_enable = 3'b010;
            w_enable_data_mem = 1'b0;
            cs_out = '0;
        end
        else if (addr == 34) begin
            io_enable = 3'b100;
            w_enable_data_mem = 1'b0;
            cs_out = '0;
        end
        // else use defaults
    end
endmodule
