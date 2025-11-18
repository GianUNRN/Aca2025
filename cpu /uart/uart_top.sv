module uart_top (
    input  logic       clk,          // 100 MHz
    input  logic       reset,        // activo en 1
    input  logic       uart_rx,      // desde PC (USB-UART)

    // TX interface
    input  logic       tx_enable,    // pulso de 1 ciclo para transmitir
    input  logic [7:0] tx_data_reg,  // dato a transmitir

    output logic       uart_tx,      // hacia PC

    // RX interface
    output logic       rx_valid,     // 1 cuando se recibe un byte
    output logic [7:0] rx_data_reg   // dato recibido
);

    // ------------------------------------------------------------
    // 1) Generador de baudios
    // ------------------------------------------------------------
    logic baud_tick, baud8_tick;

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

    // ------------------------------------------------------------
    // 2) FRONT-END RX + FIFO RX
    // ------------------------------------------------------------
    logic [7:0] rx_data_raw;
    logic       rx_valid_raw;

    uart_rx #(
        .DATA_BITS(8)
    ) uart_rx_i (
        .clk        (clk),
        .rst        (reset),
        .baud8_tick (baud8_tick),
        .rx         (uart_rx),
        .rx_data    (rx_data_raw),
        .rx_valid   (rx_valid_raw)
    );

    assign rx_valid    = rx_valid_raw;
    assign rx_data_reg = rx_data_raw;

    // Si querÃ©s FIFO RX decÃ­melo, la dejo armada y la activo.

    // ------------------------------------------------------------
    // 3) FIFO TX
    // ------------------------------------------------------------
    logic       tx_fifo_wr_en, tx_fifo_rd_en;
    logic [7:0] tx_fifo_din,   tx_fifo_dout;
    logic       tx_fifo_empty, tx_fifo_full;

    assign tx_fifo_din   = tx_data_reg;
    assign tx_fifo_wr_en = tx_enable && !tx_fifo_full;

    fifo_sync #(
        .WIDTH    (8),
        .DEPTH    (4),
        .ADDR_BITS(2)
    ) tx_fifo_i (
        .clk   (clk),
        .rst   (reset),
        .wr_en (tx_fifo_wr_en),
        .din   (tx_fifo_din),
        .rd_en (tx_fifo_rd_en),
        .dout  (tx_fifo_dout),
        .empty (tx_fifo_empty),
        .full  (tx_fifo_full)
    );

    // ------------------------------------------------------------
    // 4) UART TX + lÃ³gica de extracciÃ³n de FIFO
    // ------------------------------------------------------------
    logic [7:0] tx_reg;
    logic       tx_start;
    logic       tx_busy;

    uart_tx #(
        .DATA_BITS(8)
    ) uart_tx_i (
        .clk       (clk),
        .rst       (reset),
        .baud_tick (baud_tick),
        .tx_start  (tx_start),
        .tx_data   (tx_reg),
        .tx        (uart_tx),
        .tx_busy   (tx_busy)
    );

    always_ff @(posedge clk) begin
        if (reset) begin
            tx_start      <= 1'b0;
            tx_fifo_rd_en <= 1'b0;
            tx_reg        <= 8'h00;
        end else begin
            tx_start      <= 1'b0;
            tx_fifo_rd_en <= 1'b0;

            // Si TX estÃ¡ libre y FIFO no estÃ¡ vacÃ­a â†’ transmitir
            if (!tx_busy && !tx_fifo_empty) begin
                tx_reg        <= tx_fifo_dout;
                tx_start      <= 1'b1;
                tx_fifo_rd_en <= 1'b1;
            end
        end
    end

endmodule
