# Answers to Lab 1, Problem 5

1. In folder

2. In transcript (P5_Transcript.png)

3. The time for one operation is the number of clock cycles multiplied by the clock period. The minimum clock period can be determined by finding the longest path between flip flops (critical path) plus the setup time of the flip-flop of ``0.5 ns``.The sign bit ``R[WIDTH]`` selects whether the shifted remainder ``R`` has ``M`` added or subtracted, and the result passes through a 2-to-1 MUX into register ``R``. The MUX contributes 2 gate delays. The 5-bit ripple-carry adder/subtractor has a worst-case carry chain through 5 full adders at 2 gates each, which is 10 gate delays. Adding the setup time gives a clock period of 2 + 10 + 0.5 = 12.5 units. One division needs 5 clock cycles in total: 4 iterations for each bit (CNT counts 4, 3, 2, 1) plus 1 cycle for the remainder correction and setting ``done``. The total time for one operation is therefore 12.5 × 5 = 62.5 unit delays.