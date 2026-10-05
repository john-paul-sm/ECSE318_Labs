# Synthesis Results

### Before (Run 1)
For the first synthesis run which used a behaviorally described adder in the ALU (`+`) that LeonardoSpectrum synthesized to a ripple-carry adder, we obtained a 12.20 ns for the critical path delay.

### After (Run 2)
For the optimized circuit, we used a different adder structure (Kogge-Stone adder) since the add instruction made most of the critical path.

The new synthesis results shows that the propagation time (time it takes for the data to arrive) dropped to 11.62 ns and also the adder is no longer the critical path.

### Notes

This version of LeonardoSpectrum only synthesizes Verilog code formatted in Verilog-95 so I had to rewrite the Verilog code.

