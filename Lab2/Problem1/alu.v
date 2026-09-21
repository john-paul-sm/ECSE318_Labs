module alu #(
    parameter WIDTH = 16
)(
    input wire[WIDTH-1:0] A,
    input wire[WIDTH-1:0] B,
    input wire[4:0] alu_code,
    output wire[WIDTH-1:0] C,
    output wire overflow,
);

/*
An ALU is just a big case statement. A and B will act as our operands, and alu_code will give us a 5-bit instruction that tells us
what operation to perform on A and B. The result will be stored in C, and overflow if necessary.

For our default case, perform the ADD operation
*/

// List of all instructions as provided in the lab assignment
// Arithmetic operations: 00---

localparam [4:0] ADD = 5'b00000;
localparam [4:0] ADDU = 5'b00001;
localparam [4:0] SUB = 5'b00010;
localparam [4:0] SUBU = 5'b00011;
localparam [4:0] INC = 5'b00100;
localparam [4:0] DEC = 5'b00101;

// Logic operations: 01---

localparam [4:0] AND = 5'b01000;
localparam [4:0] OR = 5'b01001;
localparam [4:0] XOR = 5'b01010;
localparam [4:0] NOT = 5'b01011;

// shift operations: 10---

localparam [4:0] SLL = 5'b10000;
localparam [4:0] SRL = 5'b10001;
localparam [4:0] SLA = 5'b10010;
localparam [4:0] SRA = 5'b10011;

// set condition operations (signed A an B): 11---

localparam [4:0] SLE = 5'b11000;
localparam [4:0] SLT = 5'b11001;
localparam [4:0] SGE = 5'b11010;
localparam [4:0] SGT = 5'b11011;
localparam [4:0] SEQ = 5'b11100;
localparam [4:0] SNE = 5'b11101;

always @(*) begin
    case (alu_code)
        
        // Arithmetic Operations

        ADD:
        ADDU:
        SUB:
        SUBU:
        INC:
        DEC:

        // Logic Operations

        AND:
        OR:
        XOR:
        NOT:

        // Shift operations

        SLL:
        SRL:
        SLA:
        SRA:

        // Set condition operations

        SLE:
        SLT:
        SGE:
        SGT:
        SEQ:
        SNE:

        default: 

    endcase
end

