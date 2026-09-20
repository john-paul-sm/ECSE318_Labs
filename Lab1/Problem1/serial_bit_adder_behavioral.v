module serial_bit_adder_behavioral #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire clr_n, // asynchronous active-low reset as denoted in the diagram
    input wire set_n, // asynchronous active-low set as denoted in the diagram
    input wire load,
    input wire[WIDTH-1:0] augend_in, // augend input to the full adder
    input wire[WIDTH-1:0] addend_in, // addend input to the full adder
    output reg[WIDTH-1:0] result
);

    reg [WIDTH-1:0] augend_reg, addend_reg;
    reg cin;

    // For this problem, the augend and addend are just the two operands for add operations. Therefore, they're just a and b in sum = a + b
    // Set a and b as the LSB of the operands

    wire a = augend_reg[0];
    wire b = addend_reg[0];
    wire sum, cout;

    assign {cout, sum} = a + b + cin;

    // Carry DFF with asynchronous active-low clear and set

    always @(posedge clk or negedge clr_n or negedge set_n) begin
        if (!clr_n) begin
            cin <= 1'b0;
        end
        else if (!set_n) begin
            cin <= 1'b1;
        end
        else begin
            cin <= cout;
        end
    end

    // Audend and augend registers
    // LSB first

    always @(posedge clk) begin
        if (load) begin
            augend_reg <= augend_in;
            addend_reg <= addend_in;
            result <= {WIDTH{1'b0}} // clear result when loading new augend/addends
        end
        else begin
            augend_reg <= {1'b0, augend_reg[WIDTH-1:1]};
            addend_reg <= {1'b0, addend_reg[WIDTH-1:1]};
            result <= {sum, result[WIDTH-1:1]};
        end
    end
endmodule

/*
Other notes:
1. I decided to change cout from an output port to an internal port since the result isn't used besides being driven in the carry-in d-flip flop
2. When a load is asserted on a positive edge clock, I also cleared the result register for completeness

*/
