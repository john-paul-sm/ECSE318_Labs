`timescale 1ns / 1ps

module tb_divider;

    localparam WIDTH = 4;

    reg clk;
    reg rst;
    reg start;

    reg [WIDTH-1:0] divisor;
    reg [WIDTH-1:0] dividend;

    wire [WIDTH-1:0] quotient;
    wire [WIDTH-1:0] remainder;
    wire busy;
    wire done;

    divider #(.WIDTH(WIDTH)) dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .divisor(divisor),
        .dividend(dividend),
        .quotient(quotient),
        .remainder(remainder),
        .busy(busy),
        .done(done)
    );

    initial begin
        clk = 1'b0;
    end

    always #5 clk = ~clk; // 10ns clock period

    initial begin
        $display("Division Test");
        rst = 1;
        start = 0;
        #10;
        rst = 0;
        #10;

        $display("Case: 7/2");
        divisor = 2;
        dividend = 7;
        start = 1;
        #10;
        start = 0;
        #80;
        $display("Quotient: %b (%0d), Remainder %b (%0d)\n", quotient, quotient, remainder, remainder);

        $display("Case: 6/2");
        divisor = 2;
        dividend = 6;
        start = 1;
        #10;
        start = 0;
        #80;
        $display("Quotient: %b (%0d), Remainder %b (%0d)\n", quotient, quotient, remainder, remainder);

        $display("Case: 9/4");
        divisor = 4;
        dividend = 9;
        start = 1;
        #10;
        start = 0;
        #80;
        $display("Quotient: %b (%0d), Remainder %b (%0d)\n", quotient, quotient, remainder, remainder);
        $finish;
    end
endmodule



        