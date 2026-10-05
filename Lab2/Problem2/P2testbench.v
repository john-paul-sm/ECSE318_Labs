module test_processor(clk, reset);
  output clk, reset;
  reg    clk, reset;
 
  initial begin
    clk = 0;
    reset = 0;
    #12 reset = 1;
    #2000 $finish;
  end
 
  always #5 clk = ~clk;
endmodule
 
module testbenchP2;
  wire clk, reset;
  wire halt1, halt2, halt3;
 
  processor #(1) cpu1 (clk, reset, halt1);   // part 2a
  processor #(2) cpu2 (clk, reset, halt2);   // part 2b
  processor #(3) cpu3 (clk, reset, halt3);   // part 2c
  test_processor t    (clk, reset);
 
  initial begin
    $monitor($time,, "reset=%b  halt1=%b  halt2=%b  halt3=%b",reset, halt1, halt2, halt3);
  end
endmodule
 