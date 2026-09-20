module tb_adder;
reg [7:0] x0, x1, x2, x3, x4, x5, x6, x7, x8, x9;

wire [7:0] s;

CSA tester(x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, s);

initial begin

// TEST 1: 12+13+5+6+7+8+9+15

x0 = 8'd12;
x1 = 8'd13;
x2 = 8'd5;
x3 = 8'd6;
x4 = 8'd7;
x5 = 8'd8;
x6 = 8'd9;
x7 = 8'd15;
x8 = 8'd0;
x9 = 8'd0;
#10;

// TEST 2: 3+14+5+6+7+8+19+10

x0 = 8'd3;
x1 = 8'd14;
x2 = 8'd5;
x3 = 8'd6;
x4 = 8'd7;
x5 = 8'd8;
x6 = 8'd19;
x7 = 8'd10;
x8 = 8'd0;
x9 = 8'd0;
#10;

end
endmodule
