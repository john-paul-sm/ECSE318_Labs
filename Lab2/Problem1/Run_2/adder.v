module ks_level (G, P, Gs, Ps, Go, Po);

    input  [15:0] G;
    input  [15:0] P;
    input  [15:0] Gs;
    input  [15:0] Ps;
    output [15:0] Go;
    output [15:0] Po;

    assign Go = G | (P & Gs);
    assign Po = P & Ps;

endmodule


module adder (A, B, CODE, cin, coe, C, vout, cout);

    input  [15:0] A;
    input  [15:0] B;
    input  [2:0]  CODE;
    input         cin;
    input         coe;
    output [15:0] C;
    output        vout;
    output        cout;

    wire          sub;
    wire          inc;
    wire          dec;
    wire          is_signed;

    wire   [15:0] b_op;
    wire          c0;

    wire   [15:0] g;
    wire   [15:0] p;

    wire   [15:0] G0, P0;
    wire   [15:0] G1, P1;
    wire   [15:0] G2, P2;
    wire   [15:0] G3, P3;
    wire   [15:0] G4, P4;

    wire   [15:0] c;

    assign sub = (CODE == 3'b010) || (CODE == 3'b011);
    assign inc = (CODE == 3'b100);
    assign dec = (CODE == 3'b101);

    assign is_signed = (CODE == 3'b000) || (CODE == 3'b010) || inc || dec;

    assign b_op = inc ? 16'h0000 :
                  dec ? 16'hFFFF :
                        (B ^ {16{sub}});

    assign c0 = inc ? 1'b1 :
                dec ? 1'b0 :
                      cin;

    assign g = A & b_op;
    assign p = A ^ b_op;

    assign G0 = {g[15:1], g[0] | (p[0] & c0)};
    assign P0 = p;

    ks_level l1 (.G(G0), .P(P0), .Gs({G0[14:0], 1'b0}), .Ps({P0[14:0], 1'b0}), .Go(G1), .Po(P1));
    ks_level l2 (.G(G1), .P(P1), .Gs({G1[13:0], 2'b0}), .Ps({P1[13:0], 2'b0}), .Go(G2), .Po(P2));
    ks_level l3 (.G(G2), .P(P2), .Gs({G2[11:0], 4'b0}), .Ps({P2[11:0], 4'b0}), .Go(G3), .Po(P3));
    ks_level l4 (.G(G3), .P(P3), .Gs({G3[7:0],  8'b0}), .Ps({P3[7:0],  8'b0}), .Go(G4), .Po(P4));

    assign c    = {G4[14:0], c0};
    assign C    = p ^ c;
    assign vout = is_signed & (G4[14] ^ G4[15]);
    assign cout = coe ? 1'b0 : G4[15];

endmodule
