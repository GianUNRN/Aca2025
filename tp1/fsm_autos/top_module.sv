module top_module #(
    parameter int N_DIG = 4
)
(
    input  logic                clk,            // System clock
    input  logic                rst,            // Synchronous reset (active high)
    input  logic                button,
    input  logic                cathod,   // 0 = common anode, 1 = common cathode

    input  logic [1:0]          lasers,
    output logic [6:0]          seg,      // Segment outputs (a-g)
    output logic [N_DIG-1:0]    an,       // Anode/Cathode control lines
    output logic        dp,
    output logic [7-N_DIG:0]    other_an
);
    
    
    localparam N_refresh = 20;
    localparam MAX_VALUE_refresh = 20'd2**19;

    logic [3:0]         digits [N_DIG];
    logic [N_DIG-1:0]   en_pulses;
    logic [6:0]         seg_decoded [N_DIG];
    logic               cnt_car;    
    logic               down;
    logic               seg_refresh;
    logic               debounce_rst;

    // State encoding
    typedef enum logic [2:0] {
        IDLE,       // Waiting for first sensor active
        S1_ONLY,    // First sensor active
        BOTH_ON,    // Both sensors active
        S2_ONLY,    // Only second sensor active
        DETECTED    // Sequence detected
    } state_t;

    state_t state_1, nxt_state_1, state_2, nxt_state_2;

    always_comb begin
        nxt_state_1 = state_1;
        case (state_1)
            IDLE: begin
                if (lasers[0] && !lasers[1])
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

    debouncer #(.WIDTH(1), .SAMPLES(1000)) u_debouncer (
        .clk(clk),
        .rst(rst),
        .noisy_in(button),
        .clean_out(debounce_rst)
    );
    
    always_ff @( posedge clk ) begin 
        if(debounce_rst) begin
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

    

    counter #(.N(N_refresh),.MAX(MAX_VALUE_refresh)) freq_div_refresh  (
        .clk(clk),
        .rst_n(!debounce_rst),
        .en(1'b1),
        .up(1'b1),         
        .count(),
        .pulse(seg_refresh)
    );

    

    genvar i;
    generate
        for (i = 0; i < N_DIG; i++) begin : cnt_gen
            if (i == 0) begin
                counter #(.N(4),.MAX(9)) cnt_inst  (
                    .clk(clk),
                    .rst_n(!debounce_rst),
                    .en(cnt_car),         
                    .up(!down),
                    .count(digits[i]),
                    .pulse(en_pulses[i])
                );
            end else begin
                counter #(.N(4),.MAX(9)) cnt_inst  (
                        .clk(clk),
                        .rst_n(!debounce_rst),
                        .en(en_pulses[i-1]),         
                        .up(!down),
                        .count(digits[i]),
                        .pulse(en_pulses[i])
                    );
            end
        end
    endgenerate

    genvar j;
    generate
        for (j = 0; j < N_DIG; j = j + 1) begin : decoders
            seg7_dec u_dec (
                .bin_in(digits[j]),
                .seg_dec(seg_decoded[j])
            );
        end
    endgenerate

    sevenseg_mux #(.N(N_DIG)) u_mux (
        .clk(clk),
        .reset(!debounce_rst),          // Reset
        .en(seg_refresh),     // Enable digit advance
        .digit_values(seg_decoded),
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