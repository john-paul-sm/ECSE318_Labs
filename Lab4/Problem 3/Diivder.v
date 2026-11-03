module divider (dividend,divisor,quotient,remainder);
input [3:0] dividend, divisor;
output [3:0] quotient, remainder;

wire [4:0] r0,r1,r2,r3,r4;
wire [3:0] divend0,divend1,divend2,divend3,divend4;
wire [4:0] s0,s1,s2,s3;
wire c0,c1,c2,c3;

//Similairly to the graph and flowchart each stage shifts the dividend,checks the sign of the remainder, 
//and uses the CAS to add or subtract the divisor.

assign r0 = 5'b00000;
assign divend0 = dividend;

assign s0 = {r0[3:0],divend0[3]};
assign c0 = ~r0[4];
CAS cas0(s0,{1'b0,divisor},c0,r1);

assign divend1 = {divend0[2:0],~r1[4]};

assign s1 = {r1[3:0],divend1[3]};
assign c1 = ~r1[4];
CAS cas1(s1,{1'b0,divisor},c1,r2);

assign divend2 = {divend1[2:0],~r2[4]};

assign s2 = {r2[3:0],divend2[3]};
assign c2 = ~r2[4];
CAS cas2(s2,{1'b0,divisor},c2,r3);

assign divend3 = {divend2[2:0],~r3[4]};

assign s3 = {r3[3:0],divend3[3]};
assign c3 = ~r3[4];
CAS cas3(s3,{1'b0,divisor},c3,r4);

assign divend4 = {divend3[2:0],~r4[4]};
assign quotient = divend4;
assign remainder = r4[4] ? r4[3:0]+divisor:r4[3:0];

endmodule