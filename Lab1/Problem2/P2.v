module cla4 (sum, co, A, B);
output [3:0] sum;
input co;
input [3:0] A, B;

wire [3:0] P, G, C;
wire C1, C2, C3, C4;

xor p3(P[3], A[3], B[3]);
xor p2(P[2], A[2], B[2]);
xor p1(P[1], A[1], B[1]);
xor p0(P[0], A[0], B[0]);

and g3(G[3], A[3], B[3]);
and g2(G[2], A[2], B[2]);
and g1(G[1], A[1], B[1]);
and g0(G[0], A[0], B[0]);



endmodule