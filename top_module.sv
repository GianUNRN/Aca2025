module top_module (
    input  logic clk,            // System clock
    input  logic rst,            // Synchronous reset (active high)
    input  logic en,             // Enable counting
    input  logic cathod_anode,   // 1 = common anode, 0 = common cathode
    output logic [6:0] seg,      // Segment outputs (a-g)
    output logic [1:0] an,       // Anode/Cathode control lines
    output logic dp,
    output logic [5:0] other_an
);
    
    logic [3:0] units;
    logic [3:0] tens;
    logic [6:0] units_seg;
    logic [6:0] tens_seg;
    logic       seg_refresh;
    logic       cnt_freq;

    localparam int N_refresh = 3;//21;
    localparam logic [N_refresh-1:0] MAX_VALUE_refresh = 3'd2;//21'd2**20;
    
    localparam int N_cnt = 4;//27;
    localparam logic [N_cnt - 1:0] MAX_VALUE_cnt = 4'd8;//27'd2**26;
    


    counter #(.N(N_refresh),.MAX(MAX_VALUE_refresh)) freq_div_refresh  (
        .clk(clk),
        .rst_n(rst),
        .en(1'b1),         
        .count(),
        .pulse(seg_refresh)
    );

    counter #(.N(N_cnt),.MAX(MAX_VALUE_cnt)) freq_div_cnt  (
        .clk(clk),
        .rst_n(rst),
        .en(en),         
        .count(),
        .pulse(cnt_freq)
    );

    // 2-digit BCD counter
    two_d_counter u_counter (
        .clk(clk),
        .rst(rst),
        .en(cnt_freq),
        .units(units),
        .tens(tens)
    );

    // BCD to 7-segment decoders
    seg7_dec u_dec_units (
        .bin_in(units),
        .seg_out(units_seg)
    );

    seg7_dec u_dec_tens (
        .bin_in(tens),
        .seg_out(tens_seg)
    );

    // 7-segment display multiplexer
    sevenseg_mux u_mux (
        .clk(clk),
        .rst(rst),
        .en(seg_refresh),
        .cathod_anode(cathod_anode),
        .tens_seg(tens_seg),
        .units_seg(units_seg),
        .seg_out(seg),
        .an(an)
    );
    
    always_comb begin
        if(cathod_anode) begin
            dp = 1'b0;
            other_an = '0;
        end else begin
            dp = 1'b1;
            other_an = '1;
        end
    end
    
    
endmodule