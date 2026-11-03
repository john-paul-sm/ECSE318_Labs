module tb_divider;
reg [3:0] dividend;
reg [3:0] divisor;

wire [3:0] quotient;
wire [3:0] remainder;

divider tester(dividend,divisor,quotient,remainder);

initial begin

//Test: 7/2
dividend = 4'b0111;
divisor = 4'b0010;
#10;

//Test: 6/2
dividend = 4'b0110;
divisor = 4'b0010;
#10;

//Test: 9/4
dividend = 4'b1001;
divisor = 4'b0100;
#10;

end
endmodule