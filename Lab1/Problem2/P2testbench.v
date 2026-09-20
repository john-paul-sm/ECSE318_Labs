module test_cla4(A, B, c0);

    output [3:0] A, B;
    output c0;
    reg [3:0] A, B;
    reg c0;

    initial begin
        A = 4'b0101;
        B = 4'b1010;
        c0 = 1'b0; 
        #10;
        c0 = 1'b1;
        #40;
        $finish;
    end
endmodule

module testbenchP2;

    wire [3:0] sum, A, B;
    wire cout, c0;

    cla4 design(sum, cout, c0, A, B);
    test_cla4 test(A, B, c0);

    initial begin
        $monitor("Time: %0t | A: %b | B: %b | c0: %b | sum: %b | cout: %b", $time, A, B, c0, sum, cout);  
    end

endmodule
