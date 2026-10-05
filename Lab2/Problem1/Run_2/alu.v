module alu (A, B, alu_code, C, overflow);
 
    input  [15:0] A;
    input  [15:0] B;
    input  [4:0]  alu_code;
    output [15:0] C;
    output        overflow;
 
    reg    [15:0] C;
    reg           overflow;
 
    parameter ADD  = 5'b00000;
    parameter ADDU = 5'b00001;
    parameter SUB  = 5'b00010;
    parameter SUBU = 5'b00011;
    parameter INC  = 5'b00100;
    parameter DEC  = 5'b00101;
 
    parameter AND  = 5'b01000;
    parameter OR   = 5'b01001;
    parameter XOR  = 5'b01010;
    parameter NOT  = 5'b01100;
 
    parameter SLL  = 5'b10000;
    parameter SRL  = 5'b10001;
    parameter SLA  = 5'b10010;
    parameter SRA  = 5'b10011;
 
    parameter SLE  = 5'b11000;
    parameter SLT  = 5'b11001;
    parameter SGE  = 5'b11010;
    parameter SGT  = 5'b11011;
    parameter SEQ  = 5'b11100;
    parameter SNE  = 5'b11101;
 
    wire [15:0] add_C;
    wire        add_vout;
    wire        add_cout;
    wire        add_cin;
 
    wire [15:0] A_s;
    wire [15:0] B_s;
    wire [31:0] A_ext;
    wire [31:0] sra_full;
 
    assign add_cin  = (alu_code == SUB) || (alu_code == SUBU);
 
    assign A_s      = {~A[15], A[14:0]};
    assign B_s      = {~B[15], B[14:0]};
 
    assign A_ext    = {{16{A[15]}}, A};
    assign sra_full = A_ext >> B[3:0];
 
    adder u_adder (
        .A    (A),
        .B    (B),
        .CODE (alu_code[2:0]),
        .cin  (add_cin),
        .coe  (1'b0),
        .C    (add_C),
        .vout (add_vout),
        .cout (add_cout)
    );
 
    always @(A or B or alu_code or add_C or add_vout or A_s or B_s or sra_full) begin
        C        = 16'h0000;
        overflow = 1'b0;
 
        case (alu_code)
            ADD:  begin C = add_C; overflow = add_vout; end
            ADDU: begin C = add_C; overflow = add_vout; end
            SUB:  begin C = add_C; overflow = add_vout; end
            SUBU: begin C = add_C; overflow = add_vout; end
            INC:  begin C = add_C; overflow = add_vout; end
            DEC:  begin C = add_C; overflow = add_vout; end
 
            AND:  C = A & B;
            OR:   C = A | B;
            XOR:  C = A ^ B;
            NOT:  C = ~A;
 
            SLL:  C = A << B[3:0];
            SRL:  C = A >> B[3:0];
            SLA:  C = A << B[3:0];
            SRA:  C = sra_full[15:0];
 
            SLE:  C = (A_s <= B_s) ? 16'h0001 : 16'h0000;
            SLT:  C = (A_s <  B_s) ? 16'h0001 : 16'h0000;
            SGE:  C = (A_s >= B_s) ? 16'h0001 : 16'h0000;
            SGT:  C = (A_s >  B_s) ? 16'h0001 : 16'h0000;
            SEQ:  C = (A == B)     ? 16'h0001 : 16'h0000;
            SNE:  C = (A != B)     ? 16'h0001 : 16'h0000;
 
            default: begin
                C        = 16'h0000;
                overflow = 1'b0;
            end
        endcase
    end
 
endmodule
