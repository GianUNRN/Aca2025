module top_module(
    input  logic        clk,            // System clock
    input  logic        rst,            // Synchronous reset (active high)
    input  logic        button,
    input  logic        cathod,   // 0 = common anode, 1 = common cathode

    input  logic [1:0]  lasers,
    output logic [6:0]  seg,      // Segment outputs (a-g)
    output logic [1:0]  an,       // Anode/Cathode control lines
    output logic        dp,
    output logic [5:0]  other_an
);
    
    logic [3:0] units;
    logic [3:0] tens;
    logic [6:0] units_seg;
    logic [6:0] tens_seg;
    logic       debounce_rst;
    logic       seg_refresh;
    logic       down;
    logic       cnt_car;
    
    // State encoding
    typedef enum logic [2:0] {
        IDLE,       // Waiting for first sensor active
        S1_ONLY,    // First sensor active
        BOTH_ON,    // Both sensors active
        S2_ONLY,    // Only second sensor active
        DETECTED    // Sequence detected
    } state_t;

    state_t state_1, nxt_state_1, state_2, nxt_state_2;

    localparam int                      N_refresh = 21;
    localparam logic    [N_refresh-1:0] MAX_VALUE_refresh = 21'd2**20;

    localparam int                      N_cnt = 4;//27;
    localparam logic    [N_cnt - 1:0]   MAX_VALUE_cnt = 4'd8;//27'd2**26;
    always_comb begin
        nxt_state_1 = state_1;
        case (state_1)
            IDLE: begin
                if (lasers[0])
                    nxt_state_1 = S1_ONLY;
            end

            S1_ONLY: begin
                if (lasers[0])
                    nxt_state_1 = state_t'(lasers[0] & lasers[1] ? BOTH_ON : S1_ONLY);

                else 
                    nxt_state_1 = IDLE; // Wrong pattern, reset
            end

            BOTH_ON: begin
                if (!lasers[0] && lasers[1])
                    nxt_state_1 = S2_ONLY;
                else if (lasers[0] && !lasers[1])
                    nxt_state_1 = S1_ONLY; // Wrong pattern, reset
            end

            S2_ONLY: begin
                if (!lasers[0] && !lasers[1])
                    nxt_state_1 = DETECTED;
                else if (lasers[0] && lasers[1])
                    nxt_state_1 = BOTH_ON; // Wrong pattern, reset
            end

            DETECTED: begin
                nxt_state_1 = IDLE; // Go back and wait for next sequence
            end

            default: nxt_state_1 = IDLE;
        endcase
    end
    
    
    always_comb begin
        nxt_state_2 = state_2;
        case (state_2)
            IDLE: begin
                if (lasers[1] && !lasers[0])
                    nxt_state_2 = S2_ONLY;
            end

            S2_ONLY: begin
                if (lasers[1])
                    nxt_state_2 = state_t'(lasers[0] & lasers[1] ? BOTH_ON:S2_ONLY);
                else 
                    nxt_state_2 = IDLE; // Wrong pattern, reset
            end

            BOTH_ON: begin
                if (!lasers[1] && lasers[0])
                    nxt_state_2 = S1_ONLY;
                else if (lasers[1] && !lasers[0])
                    nxt_state_2 = S2_ONLY; // Wrong pattern, reset
            end

            S1_ONLY: begin
                if (!lasers[1] && !lasers[0])
                    nxt_state_2 = DETECTED;
                else if (lasers[0] && lasers[1])
                    nxt_state_2 = BOTH_ON ; // Wrong pattern, reset
            end

            DETECTED: begin
                nxt_state_2 = IDLE; // Go back and wait for next sequence
            end

            default: nxt_state_2 = IDLE;
        endcase
    end
    
    always_ff @( posedge clk ) begin 
        if(!rst) begin
            state_1 <= IDLE;
            state_2 <= IDLE;
        end else begin
            state_1 <= nxt_state_1;
            state_2 <= nxt_state_2;

        end
    end
    
    always_comb begin
        cnt_car = (state_1 == DETECTED) || (state_2 == DETECTED);
        down = (state_2 == DETECTED);
    end

    debouncer #(.WIDTH(1), .SAMPLES(10)) u_debouncer (
        .clk(clk),
        .rst(rst),
        .noisy_in(button),
        .clean_out(debounce_rst)
    );

    counter #(.N(N_refresh),.MAX(MAX_VALUE_refresh)) freq_div_refresh  (
        .clk(clk),
        .rst_n(!debounce_rst),
        .en(1'b1),
        .up(1'b1),         
        .count(),
        .pulse(seg_refresh)
    );

    

    // 2-digit BCD counter
    two_d_counter u_counter (
        .clk(clk),
        .rst(!debounce_rst),
        .en(cnt_car),
        .up(!down),
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
        .cathod(cathod),
        .tens_seg(tens_seg),
        .units_seg(units_seg),
        .seg_out(seg),
        .an(an)
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