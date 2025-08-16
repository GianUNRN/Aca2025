module top_module(
    input  logic        clk,            // System clock
    input  logic        rst_n,            
    input  logic        cathod,   // 0 = common anode, 1 = common cathode
    input  logic        en,             // Enable counting
    output logic [6:0]  seg,      // Segment outputs (a-g)
    output logic [2:0]  an,       // Anode/Cathode control lines
    output logic        dp,
    output logic [4:0]  other_an,
    output logic [3:0]       units,
    output logic [3:0]       tens,
    output logic [3:0]       hundreds // 3 digits for the counter
);
    localparam N_cnt = 4;
    localparam MAX_VALUE_cnt = 4'd3;
    localparam N_refresh = 3;
    localparam MAX_VALUE_refresh = 3'd1;
    localparam N_DIG = 3;

    logic [3:0]         digits [N_DIG-1:0];
    logic [N_DIG-1:0]   en_pulses;
    logic [6:0]         seg_decoded [N_DIG-1:0];

    logic       seg_refresh;
    logic       cnt_freq;
    

    assign units = digits[0];
    assign tens = digits[1];
    assign hundreds = digits[2];

    counter #(.N(N_cnt),.MAX(MAX_VALUE_cnt)) freq_div_cnt  (
        .clk(clk),
        .rst_n(rst_n),
        .en(en),
        .up(1'b1),         
        .count(),
        .pulse_out(cnt_freq)
    );

    counter #(.N(N_refresh),.MAX(MAX_VALUE_refresh)) freq_div_refresh  (
        .clk(clk),
        .rst_n(rst_n),
        .en(1'b1),
        .up(1'b1),         
        .count(),
        .pulse_out(seg_refresh)
    );

    

    genvar i;
    generate
        for (i = 0; i < N_DIG; i++) begin : cnt_gen
            if (i == 0) begin
                counter #(.N(4),.MAX(9)) cnt_inst  (
                    .clk(clk),
                    .rst_n(rst_n),
                    .en(cnt_freq),         
                    .up(1'b1),
                    .count(digits[i]),
                    .pulse_out(en_pulses[i])
                );
            end else begin
                counter #(.N(4),.MAX(9)) cnt_inst  (
                        .clk(clk),
                        .rst_n(rst_n),
                        .en(en_pulses[i-1]),         
                        .up(1'b1),
                        .count(digits[i]),
                        .pulse_out(en_pulses[i])
                    );
            end
        end
    endgenerate

    genvar j;
    generate
        for (j = 0; j < N_DIG; j = j + 1) begin : decoders
            seg7_dec u_dec (
                .bin_in(digits[j]),
                .seg_out(seg_decoded[j])
            );
        end
    endgenerate

    // 7-segment display multiplexer
    sevenseg_mux #(.N(N_DIG)) u_mux (
        .clk(clk),
        .reset(rst_n),          // Reset
        .en(seg_refresh),     // Enable digit advance
        .digit_values(seg_decoded),
        .seg(seg),
        .dig(an)
    );
    
    always_comb begin
        if(cathod) begin
            dp = 1'b0;
            other_an = '0;
        end else begin
            dp = 1'b1;
            other_an = '1;
        end
    end
    
    
endmodule