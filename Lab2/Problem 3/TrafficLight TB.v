module TrafficLight_TB;

reg clk;
reg Sa;
reg Sb;

wire Ga, Ya, Ra, Gb, Yb, Rb;

TrafficLight tester(clk, Sa, Sb, Ga, Ya, Ra, Gb, Yb, Rb);

initial
begin
clk = 0;
Sa = 0;
Sb = 0;

// Here we have Street B car arriving before Street A has completed 6 clock cycles so as to test that 
// Street A will remain green for its minimum of 6 clock cycles before changing.
#20 Sb = 1;

// Street A car approaches. This should cause it to return to GaRb
#100 Sa = 1;

// Remove car from Street B
#100 Sb = 0;

// Remove car from Street A and put a car back on Street B just to test it one more time
#100 Sa = 0;
Sb = 1;

// Allow normal operation to continue
#100;

// FAILSAFE TEST: This scenario should already never occur with a finite state machine but for the sake of
// testing I will force both green lights ON
force tester.Ga = 1;
force tester.Gb = 1;

// Keep both greens on long enough to see the red lights flash
#100;

// Release the forced values
release tester.Ga;
release tester.Gb;

#50;

$stop;
end

always
begin
#5 clk = ~clk;
end

endmodule
