module ssp (
    input wire PCLK,
    input wire CLEAR_B,
    input wire PSEL,
    input wire PWRITE,
    input wire [7:0] PWDATA,
    input wire SSPCLKIN,
    input wire SSPFSSIN,
    input wire SSPRXD,
    output wire [7:0] PRDATA,
    output wire SSPOE_B,
    output wire SSPTXD,
    output wire SSPCLKOUT,
    output wire SSPFSSOUT,
    output wire SSPTXINTR,
    output wire SSPRXINTR

);

    wire [7:0] tx_data;
    wire tx_empty;
    wire tx_read;
    wire [7:0] rx_data;
    wire rx_write;

    TxFIFO txfifo (
        .PCLK(PCLK),
        .CLEAR_B(CLEAR_B),
        .PSEL(PSEL),
        .PWRITE(PWRITE),
        .PWDATA(PWDATA),
        .TxRead(tx_read),
        .SSPTXINTR(SSPTXINTR),
        .empty(tx_empty),
        .TxData(tx_data)
    );

    RxFIFO rxfifo (
        .PCLK(PCLK),
        .CLEAR_B(CLEAR_B),
        .PWRITE(PWRITE),
        .PSEL(PSEL),
        .RxWrite(rx_write),
        .RxData(rx_data),
        .SSPRXINTR(SSPRXINTR),
        .PRDATA(PRDATA)
    );

    ssp_logic txrxlogic (
        .PCLK(PCLK),
        .CLEAR_B(CLEAR_B),
        .TxData(tx_data),
        .tx_empty(tx_empty),
        .TxRead(tx_read),
        .SSPCLKOUT(SSPCLKOUT),
        .SSPFSSOUT(SSPFSSOUT),
        .SSPTXD(SSPTXD),
        .SSPOE_B(SSPOE_B),
        .SSPCLKIN(SSPCLKIN),
        .SSPFSSIN(SSPFSSIN),
        .SSPRXD(SSPRXD),
        .RxData(rx_data),
        .RxWrite(rx_write)
    );

endmodule
