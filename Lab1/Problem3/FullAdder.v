module fulladder (a,b,c_in,sum,carry);
input a, b, c_in;
output sum, carry;

assign sum = a^b^c_in;
assign carry = (a&b)|(c_in&b)|(a&c_in);

endmodule
