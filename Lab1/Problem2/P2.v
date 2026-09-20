module cla4 (sum, cout, c0, A, B);

output [3:0] sum;
output cout;
input c0;
input [3:0] A, B;

wire [3:0] P, G;
wire C1, C2, C3, C4;

// PG Generator (Each gate done individually for "progagate" and "generate" signals)
xor #10 p3(P[3], A[3], B[3]);
xor #10 p2(P[2], A[2], B[2]);
xor #10 p1(P[1], A[1], B[1]);
xor #10 p0(P[0], A[0], B[0]);

and #10 g3(G[3], A[3], B[3]);
and #10 g2(G[2], A[2], B[2]);
and #10 g1(G[1], A[1], B[1]);
and #10 g0(G[0], A[0], B[0]);

// Carry Generate Block (Each "carry" signal done individually)
// CI
wire temp1;
and #10 c1a1(temp1, P[0], c0);
or #10 c1s(C1, temp1, G[0]);

// C<0>
wire temp2, temp3;
and #10 c2a1(temp2, P[1], G[0]);
and #10 c2a2(temp3, P[1], P[0], c0);
or #10 c2s(C2, G[1], temp2, temp3);

// C<1>
wire temp4, temp5, temp6;
and #10 c3a1(temp4, P[2], G[1]);
and #10 c3a2(temp5, P[2], P[1], G[0]);
and #10 c3a3(temp6, P[2], P[1], P[0], c0);
or #10 c3s(C3, G[2], temp4, temp5, temp6);

// C<2>
wire temp7, temp8, temp9, temp10;
and #10 c4a1(temp7, P[3], G[2]);
and #10 c4a2(temp8, P[3], P[2], G[1]);
and #10 c4a3(temp9, P[3], P[2], P[1], G[0]);
and #10 c4a4(temp10, P[3], P[2], P[1], P[0], c0);
or #10 c4s(C4, G[3], temp7, temp8, temp9, temp10);

assign cout = C4;

// Sum Generator (Each "sum" signal done individually)
xor #10 s0(sum[0], P[0], c0);
xor #10 s1(sum[1], P[1], C1);
xor #10 s2(sum[2], P[2], C2);
xor #10 s3(sum[3], P[3], C3);

endmodule