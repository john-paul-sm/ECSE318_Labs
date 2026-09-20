`timescale 1ns / 1ps

// This testbench is supposed to test the equivalence function of the behavioral and structural (gate-level) implementations of a N-Bit Serial Adder

module serial_bit_adder_tb;
 
    parameter WIDTH  = 8;
 
    reg clk = 1'b0;
    reg clr_n;
    reg set_n;
    reg load;
    reg [WIDTH-1:0] augend_in, 
    reg [WIDTH-1:0] addend_in;
    reg [WIDTH-1:0] expected;
 
    wire [WIDTH-1:0] result_b, // Behavioral result
    wire [WIDTH-1:0] result_s; // Structural result
 
    integer errors = 0;
 
    serial_bit_adder_behavioral #(WIDTH) dut_b (
        .clk(clk), 
        .clr_n(clr_n), 
        .set_n(set_n), 
        .load(load),
        .augend_in(augend_in), 
        .addend_in(addend_in), 
        .result(result_b)
    );
 
    serial_bit_adder_structural #(WIDTH) dut_s (
        .clk(clk), 
        .clr_n(clr_n), 
        .set_n(set_n), 
        .load(load),
        .augend_in(augend_in), 
        .addend_in(addend_in), 
        .result(result_s)
    );
 
    always #10 clk = ~clk;
 
    initial begin
        clr_n     = 1'b0;
        set_n     = 1'b1;
        load      = 1'b0;
        augend_in = {WIDTH{1'b0}};
        addend_in = {WIDTH{1'b0}};
        expected  = {WIDTH{1'b0}};
 
        $display(Behavioral vs. Structural Comparison of Serial Bit Adder);
 
        augend_in = 8'd25;  
        addend_in = 8'd37;  
        expected = 8'd62;
        clr_n = 1'b0;  
        set_n = 1'b1;  
        load = 1'b1;
        #10;
        clr_n = 1'b1;  
        load = 1'b0;
        #80;
        $display("25 + 37 \n behavorial = %3d (%b) \n structural = %3d (%b) \n expected = %3d", result_b, result_b, result_s, result_s, expected);
        if (result_b !== expected || result_s !== expected) errors = errors + 1;
 
        augend_in = 8'd170; 
        addend_in = 8'd85;  
        expected = 8'd255;
        clr_n = 1'b0;  
        set_n = 1'b1;  
        load = 1'b1;
        #10;
        clr_n = 1'b1;  
        load = 1'b0;
        #80;
        $display("170 + 85 \n behavorial = %3d (%b) \n structural = %3d (%b) \n expected = %3d", result_b, result_b, result_s, result_s, expected);
        if (result_b !== expected || result_s !== expected) errors = errors + 1;
 
        augend_in = 8'd255; 
        addend_in = 8'd1;   
        expected = 8'd0;
        clr_n = 1'b0;  
        set_n = 1'b1;  
        load = 1'b1;
        #10;
        clr_n = 1'b1;  
        load = 1'b0;
        #80;
        $display("250 + 1 \n behavorial = %3d (%b) \n structural = %3d (%b) \n expected = %3d", result_b, result_b, result_s, result_s, expected);
        if (result_b !== expected || result_s !== expected) errors = errors + 1;
        if (result_b !== expected || result_s !== expected) errors = errors + 1;
 
        augend_in = 8'd25;  
        addend_in = 8'd37;  
        expected = 8'd63;
        clr_n = 1'b1;  
        set_n = 1'b0;  
        load = 1'b1;
        #10;
        set_n = 1'b1;  
        load = 1'b0;
        #80;
        $display("25 + 37 + 1 \n behavorial = %3d (%b) \n structural = %3d (%b) \n expected = %3d", result_b, result_b, result_s, result_s, expected);
        if (result_b !== expected || result_s !== expected) errors = errors + 1;
        if (result_b !== expected || result_s !== expected) errors = errors + 1;
        if (result_b !== expected || result_s !== expected) errors = errors + 1;
 
        if (errors == 0) $display("All cases match.");
        else             $display("%0d case(s) failed.", errors);
 
        $finish;
    end
 
endmodule