module ssp_logic (
    input wire PCLK,
    input wire CLEAR_B,
    input wire [7:0] TxData,
    input wire tx_empty,
    output wire TxRead,
    output reg SSPCLKOUT,
    output reg SSPFSSOUT,
    output reg SSPTXD,
    output reg SSPOE_B,
    input wire SSPCLKIN,
    input wire SSPFSSIN,
    input wire SSPRXD,
    output wire [7:0] RxData,
    output reg RxWrite

);

    reg tx_valid; // TxData holds a word that is not loaded yet
    reg [7:0] tx_shift;
    reg [3:0] tx_count; // SSPCLKOUT rising edges until the frame ends on SSPTXD
    reg sspclkin_d;
    reg [7:0] rx_shift;
    reg [3:0] rx_count; // bits left to receive

    assign TxRead = !tx_empty && !tx_valid;
    assign RxData = rx_shift;

    // Transmit
    always @(posedge PCLK) begin
        if (!CLEAR_B) begin
            SSPCLKOUT <= 1'b0;
            SSPFSSOUT <= 1'b0;
            SSPTXD <= 1'b0;
            SSPOE_B <= 1'b1;
            tx_valid <= 1'b0;
            tx_count <= 4'd0;
        end
        else begin
            SSPCLKOUT <= ~SSPCLKOUT;
            if (TxRead)
                tx_valid <= 1'b1;
            if (!SSPCLKOUT) begin // SSPCLKOUT rises on this edge
                SSPFSSOUT <= 1'b0;
                if (tx_count >= 4'd2) begin
                    SSPTXD <= tx_shift[7];
                    tx_shift <= {tx_shift[6:0], 1'b0};
                end
                else
                    SSPTXD <= 1'b0;
                if (tx_count != 4'd0)
                    tx_count <= tx_count - 1;
                if ((tx_count == 4'd0 || tx_count == 4'd2) && tx_valid) begin
                    tx_shift <= TxData;
                    tx_count <= 4'd9;
                    SSPFSSOUT <= 1'b1;
                    tx_valid <= 1'b0;
                end
            end
            else // SSPCLKOUT falls on this edge
                SSPOE_B <= (tx_count == 4'd0);
        end
    end

    // Receive
    always @(posedge PCLK) begin
        if (!CLEAR_B) begin
            sspclkin_d <= 1'b0;
            rx_shift <= 8'b0;
            rx_count <= 4'd0;
            RxWrite <= 1'b0;
        end
        else begin
            sspclkin_d <= SSPCLKIN;
            RxWrite <= 1'b0;
            if (SSPCLKIN && !sspclkin_d) begin // first PCLK cycle after SSPCLKIN rises
                if (rx_count != 4'd0) begin
                    rx_shift <= {rx_shift[6:0], SSPRXD};
                    rx_count <= rx_count - 1;
                    if (rx_count == 4'd1)
                        RxWrite <= 1'b1;
                end
                if (SSPFSSIN)
                    rx_count <= 4'd8;
            end
        end
    end

endmodule
