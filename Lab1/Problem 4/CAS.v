module CAS(a,b,control,sum);
input [4:0] a, b;
input control;
output [4:0] sum;

wire [4:0] b_cont;
wire [4:0] carry;

assign b_cont = b^{5{control}};

//Refers to add or subtract based on the control input
fulladder bit0(a[0],b_cont[0],control,sum[0],carry[0]);
fulladder bit1(a[1],b_cont[1],carry[0],sum[1],carry[1]);
fulladder bit2(a[2],b_cont[2],carry[1],sum[2],carry[2]);
fulladder bit3(a[3],b_cont[3],carry[2],sum[3],carry[3]);
fulladder bit4(a[4],b_cont[4],carry[3],sum[4],carry[4]);

endmodule