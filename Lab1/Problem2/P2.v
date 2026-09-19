module cla4 (sum, cout, c0, A, B);
output [3:0] sum;
output cout;
input c0;
input [3:0] A, B;

wire [3:0] P, G;
wire C1, C2, C3, C4;

xor p3(P[3], A[3], B[3]);
xor p2(P[2], A[2], B[2]);
xor p1(P[1], A[1], B[1]);
xor p0(P[0], A[0], B[0]);

and g3(G[3], A[3], B[3]);
and g2(G[2], A[2], B[2]);
and g1(G[1], A[1], B[1]);
and g0(G[0], A[0], B[0]);

wire temp1;
and c1(temp1, P[0], c0);
or c1s(C1, temp1, G[0]);

wire temp2, temp3;
and c2(temp2, P[1], G[1]);
and c22(temp3, P[1], P[0], G[0]);
or c2s(C2, G[1], temp2, temp3);

endmodule