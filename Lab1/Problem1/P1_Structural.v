module full_adder (output sum, output cout, input a, input b, input cin);

    wire p, q, r, s;

    // sum = a ⊕ b ⊕ cin

    xor g_x0(p, a, b);
    xor g_x1(sum, cin, p);
    
    // cout = a * b || a & cin || b & cin

    and g_a0(q, a, b);
    and g_a1(r, a, cin);
    and g_a2(s, b, cin);

    or (cout, q, r, s);

endmodule