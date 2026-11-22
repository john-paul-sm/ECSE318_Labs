module adder (A, B, CODE, cin, coe, C, vout, cout);

    input  [15:0] A;
    input  [15:0] B;
    input  [2:0]  CODE;
    input         cin;
    input         coe;
    output [15:0] C;
    output        vout;
    output        cout;

    reg    [15:0] C;
    reg           vout;
    reg    [16:0] sum;
    wire   [15:0] B_n;

    assign B_n = ~B;

    always @(A or B or B_n or CODE or cin) begin
        vout = 1'b0;

        case (CODE)
            3'b000: begin
                sum  = A + B + cin;
                vout = (A[15] == B[15]) && (sum[15] != A[15]);
            end
            3'b001: begin
                sum  = A + B + cin;
            end
            3'b010: begin
                sum  = A + B_n + cin;
                vout = (A[15] != B[15]) && (sum[15] != A[15]);
            end
            3'b011: begin
                sum  = A + B_n + cin;
            end
            3'b100: begin
                sum  = A + 16'h0001;
                vout = (A[15] == 1'b0) && (sum[15] == 1'b1);
            end
            3'b101: begin
                sum  = A + 16'hFFFF;
                vout = (A[15] == 1'b1) && (sum[15] == 1'b0);
            end
            default: begin
                sum  = 17'b0;
            end
        endcase

        C = sum[15:0];
    end

    assign cout = coe ? 1'b0 : sum[16];

endmodule
