// Added 1 unit delay for each gate instance

module full_adder (
    input wire a,
    input wire b,
    input wire cin,
    output wire sum,
    output wire cout
);
 
    wire s1, c1, c2, c3;
 
    // Sum

    xor #1 g_x0(s1, a, b);
    xor #1 g_x1(sum, cin, s1);

    // Cout
 
    and #1 g_a0(c1, a, b);
    and #1 g_a1(c2, a, cin);
    and #1 g_a2(c3, b, cin);
 
    or #1 g_o0(cout, c1, c2, c3);
 
endmodule
 
 
module mux2 (
    input wire sel,
    input wire d0,
    input wire d1,
    output wire y
);
 
    wire sel_n, t0, t1;
 
    not #1 g_n(sel_n, sel);
    and #1 g_0(t0, sel_n, d0);
    and #1 g_1(t1, sel, d1);
    or  #1 g_y(y, t0, t1);
 
endmodule
 
// 1-bit DFF with asynchronous clear/set

module dff_sc (
    input wire clk,
    input wire clr_n,
    input wire set_n,
    input wire d,
    output wire q
);
 
    wire n1, n2, n3, n4, qn;
 
    nand #1 g_n1(n1, set_n, n4, n2);
    nand #1 g_n2(n2, clr_n, n1, clk);
    nand #1 g_n3(n3, n2, clk, n4);
    nand #1 g_n4(n4, clr_n, n3, d);
    nand #1 g_q (q,  set_n, n2, qn);
    nand #1 g_qn(qn, clr_n, q, n3);
 
endmodule
 
// N-Bit register for the augend/ addend/ result registers

module shift_register #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire load,
    input wire sin,
    input wire [WIDTH-1:0] pin,
    output wire [WIDTH-1:0] q
);
 
    wire [WIDTH:0] chain;
    wire [WIDTH-1:0] d;
 
    assign chain = {sin, q};
 
    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : cells
            mux2 m (.sel(load), .d0(chain[i+1]), .d1(pin[i]), .y(d[i]));
            dff_sc r (.clk(clk), .clr_n(1'b1), .set_n(1'b1), .d(d[i]), .q(q[i]));
        end
    endgenerate
 
endmodule
 
 
module serial_bit_adder_structural #(
    parameter WIDTH = 8
)(
    input wire clk,
    input wire clr_n,
    input wire set_n,
    input wire load,
    input wire [WIDTH-1:0] augend_in,
    input wire [WIDTH-1:0] addend_in,
    output wire [WIDTH-1:0] result
);
 
    wire [WIDTH-1:0] augend_q;
    wire [WIDTH-1:0] addend_q;
    wire sum;
    wire cin;
    wire cout;
 
    shift_register #(WIDTH) augend_sr (
        .clk(clk),
        .load(load),
        .sin(1'b0),
        .pin(augend_in),
        .q(augend_q)
    );
 
    shift_register #(WIDTH) addend_sr (
        .clk (clk),
        .load(load),
        .sin(1'b0),
        .pin(addend_in),
        .q(addend_q)
    );
 
    full_adder fa0 (
        .a(augend_q[0]),
        .b(addend_q[0]),
        .cin (cin),
        .sum (sum),
        .cout(cout)
    );
 
    dff_sc carry_ff (
        .clk  (clk),
        .clr_n(clr_n),
        .set_n(set_n),
        .d(cout),
        .q(cin)
    );
 
    shift_register #(WIDTH) result_sr (
        .clk (clk),
        .load(load),
        .sin (sum),
        .pin ({WIDTH{1'b0}}),
        .q(result)
    );
 
endmodule

/*
Other notes:
1. Same with the behavioral implementation, I followed the design according to the diagram and added set/clear etc.
2. Instead of separating the result reg to the operand registers, I just made a general purpose shift register module.

*/