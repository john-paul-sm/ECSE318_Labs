module full_adder (output sum, output cout, input a, input b, input cin);

    wire s1, c1, c2, c3;

    // sum = a ⊕ b ⊕ cin

    xor g_x0(s1, a, b);
    xor g_x1(sum, cin, s1);
    
    // cout = a * b | a & cin | b & cin

    and g_a0(c1, a, b);
    and g_a1(c2, a, cin);
    and g_a2(c3, b, cin);

    or g_o0(cout, c1, c2, c3);

endmodule