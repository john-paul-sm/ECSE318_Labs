module CSA (x0,x1,x2,x3,x4,x5,x6,x7,x8,x9,s);
input [7:0] x0,x1,x2,x3,x4,x5,x6,x7,x8,x9;
output [7:0] s;

wire [7:0] s1, s2, s3;
wire [7:0] c1, c2, c3;
wire [9:0] sum1;
wire [9:0] sum2;
wire [9:0] sum3;

//Refers back to the fulladder and starts to add all the 8-bit binaries in order
fulladder bit0(x0[0], x1[0], x2[0], s1[0], c1[0]);
fulladder bit1(x0[1], x1[1], x2[1], s1[1], c1[1]);
fulladder bit2(x0[2], x1[2], x2[2], s1[2], c1[2]);
fulladder bit3(x0[3], x1[3], x2[3], s1[3], c1[3]);
fulladder bit4(x0[4], x1[4], x2[4], s1[4], c1[4]);
fulladder bit5(x0[5], x1[5], x2[5], s1[5], c1[5]);
fulladder bit6(x0[6], x1[6], x2[6], s1[6], c1[6]);
fulladder bit7(x0[7], x1[7], x2[7], s1[7], c1[7]);
fulladder bit8(x3[0], x4[0], x5[0], s2[0], c2[0]);
fulladder bit9(x3[1], x4[1], x5[1], s2[1], c2[1]);
fulladder bit10(x3[2], x4[2], x5[2], s2[2], c2[2]);
fulladder bit11(x3[3], x4[3], x5[3], s2[3], c2[3]);
fulladder bit12(x3[4], x4[4], x5[4], s2[4], c2[4]);
fulladder bit13(x3[5], x4[5], x5[5], s2[5], c2[5]);
fulladder bit14(x3[6], x4[6], x5[6], s2[6], c2[6]);
fulladder bit15(x3[7], x4[7], x5[7], s2[7], c2[7]);
fulladder bit16(x6[0], x7[0], x8[0], s3[0], c3[0]);
fulladder bit17(x6[1], x7[1], x8[1], s3[1], c3[1]);
fulladder bit18(x6[2], x7[2], x8[2], s3[2], c3[2]);
fulladder bit19(x6[3], x7[3], x8[3], s3[3], c3[3]);
fulladder bit20(x6[4], x7[4], x8[4], s3[4], c3[4]);
fulladder bit21(x6[5], x7[5], x8[5], s3[5], c3[5]);
fulladder bit22(x6[6], x7[6], x8[6], s3[6], c3[6]);
fulladder bit23(x6[7], x7[7], x8[7], s3[7], c3[7]);

assign sum1 = {1'b0, s1} + {c1, 1'b0};
assign sum2 = {1'b0, s2} + {c2, 1'b0};
assign sum3 = {1'b0, s3} + {c3, 1'b0};
assign s = sum1+sum2+sum3+x9;

endmodule
