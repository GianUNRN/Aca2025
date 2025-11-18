module sevenseg#(
    parameter int N_DIG = 8
)
(
    input  logic                clk,            // System clock
    input  logic                rst,            // Synchronous reset (active high)
    input  logic                en,
    input  logic [31:0]         digits,
    output logic [6:0]          seg,      // Segment outputs (a-g)
    output logic [N_DIG-1:0]    an,       // Anode/Cathode control lines
    output logic        dp
);
    
    
    localparam N_refresh = 19;
    localparam MAX_VALUE_refresh = 19'd2**18;

    
    logic [6:0]         seg_decoded [0:N_DIG-1];

    logic               seg_refresh;

    logic [3:0] data_next [0:N_DIG-1];
    logic [3:0] data [0:N_DIG-1];

    always_ff @(posedge clk) begin: NEXT_DATA
        if (rst) begin
            for (int i = 0; i < N_DIG; i++) begin
                data[i] <= '0;
  
            end
        end else begin
            
            if (en) begin
                data[0] <= digits[3:0];
                data[1] <= digits[7:4];
                data[2] <= digits[11:8];
                data[3] <= digits[15:12];
                data[4] <= digits[19:16];
                data[5] <= digits[23:20];
                data[6] <= digits[27:24];
                data[7] <= digits[31:28];
            end
        end
    end

    always_comb begin: ALLOWED_DATA
        for (int i = 0; i < N_DIG; i++) begin
            data_next[i] = data[i];
        end
    end
    counter #(.N(N_refresh),.MAX(MAX_VALUE_refresh)) freq_div_refresh  (
        .clk(clk),
        .rst_n(rst),
        .en(1'b1),
        .up(1'b1),         
        .count(),
        .pulse(seg_refresh)
    );

    genvar j;
    generate
        for (j = 0; j < N_DIG; j = j + 1) begin : decoders
            sevenseg_dec u_dec (
                .bin_in(data_next[j]),
                .seg_dec(seg_decoded[j])
            );
        end
    endgenerate

    sevenseg_mux #(.N(N_DIG)) u_mux (
        .clk(clk),
        .reset(rst),          // Reset
        .en(seg_refresh),     // Enable digit advance
        .digit_values(seg_decoded),
        .seg_out(seg),
        .an(an)
    );


    always_comb begin : DP
        dp = 1'b1;
    end
endmodule