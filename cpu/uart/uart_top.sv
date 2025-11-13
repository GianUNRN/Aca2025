// uart_echo_top.sv
module uart_top (
    input  logic       clk,      // 100 MHz
    input  logic       reset,    // botón, activo en 0
    input  logic       uart_rx,  // desde PC (USB-UART)
    input  logic       tx_enable,
    input logic [7:0]  tx_data_reg,
    output logic       uart_tx,  // hacia PC
    output logic rx_valid,
    output logic [7:0]  rx_data_reg

);

    // -------------------------------------------------------------------------
    // Generador de baudios
    // -------------------------------------------------------------------------
    logic baud_tick;
    logic baud8_tick;

    uart_baud_gen #(
        .CLK_FREQ (100_000_000),
        .BAUD     (115_200),
        .ACC_WIDTH(17)
    ) baud_gen_i (
        .clk        (clk),
        .rst        (reset),
        .baud_tick  (baud_tick),
        .baud8_tick (baud8_tick)
    );

    // -------------------------------------------------------------------------
    // Receptor UART
    // -------------------------------------------------------------------------


    uart_rx #(
        .DATA_BITS(8)
    ) uart_rx_i (
        .clk        (clk),
        .rst        (reset),
        .baud8_tick (baud8_tick),
        .rx         (uart_rx),
        .rx_data    (rx_data_reg),
        .rx_valid   (rx_valid)
    );

    // -------------------------------------------------------------------------
    // Transmisor UART (eco)
    // -------------------------------------------------------------------------
    logic       tx_start;
    logic       tx_busy;
    logic [7:0] tx_data;
    
    uart_tx #(
        .DATA_BITS(8)
    ) uart_tx_i (
        .clk       (clk),
        .rst       (reset),
        .baud_tick (baud_tick),
        .tx_start  (tx_start & tx_enable),
        .tx_data   (tx_data),
        .tx        (uart_tx),
        .tx_busy   (tx_busy)
    );

   
    always_ff @(posedge clk) begin
        if (reset) begin
            
            tx_data <= 8'h00;
            tx_start <= 1'b0;
        end else begin
            tx_start <= 1'b0; // default


            if (!tx_busy) begin
                tx_data  <= tx_data_reg;
                tx_start <= 1'b1; // un ciclo
            end
            
        end
    end
endmodule