# ECSE 318 – Lab 5: Circuit Reader, Fanout Buffers and Levelization

## Files

| File | What it is |
|---|---|
| `s27.v` | Input circuit (ISCAS s27 benchmark, Figure P1) |
| `tokens.l` | flex lexer source → generates `lex.yy.c` |
| `parse.y` | bison grammar → generates `parse.tab.c` / `parse.tab.h`. Its actions now build the circuit |
| `circuit.h` | Gate data record (Figure P2) and gate-type codes |
| `main.c` | Builds the circuit, adds the fanout BUFs, levelizes and prints the results |
| `s27_output.txt` | Program output for `s27.v` |

## Compile and run

```
bison -d parse.y
flex tokens.l
gcc main.c lex.yy.c parse.tab.c
./a.out s27.v
```

## How it works

**a) Reading the circuit.** The lexer returns every name as a copy (`strdup(yytext)`). Without the copy, every name would point to the same `yytext` buffer and be overwritten by the next token. The parser collects the names in each statement, then:
- `input` creates one `INPUT` gate per name.
- `output` remembers the names; those gates get `Output = 1` after parsing.
- Each gate instantiation creates one gate record named after its **output line** (the first port), the same way the gates are labeled in Figure P1(a). The remaining ports are its fanins.

After parsing, `connect_gates()` turns the fanin names into pointers and fills in each driver's fanout list. This is done afterwards because a line can be used before it is defined (for example, G10 is used by `XG1` but driven by `XG12`).

**b) Fanout buffers.** Every gate with more than one fanout gets one `BUF` per fanout branch (stem → BUF → fanout gate), so each branch line has its own name: `<stem>_1`, `<stem>_2`, …. In s27 the stems are G14, G8, G12 (2 branches each) and G11 (3 branches), so 9 BUFs are added.

**c) Levelization.** Primary inputs and DFFs (pseudo inputs) start at level 0, and every other gate starts at −1. The program repeatedly scans the gates. When all of a gate's inputs have a level, the gate gets `max(input levels) + 1`. This repeats until every gate has a level. If a pass makes no progress, the circuit has a combinational loop, and the program reports an error.

**d) Output.** First the number of gates on each level. Then the intermediate file: one header line `#gates #inputs #outputs #flip-flops`, then one line per gate:

```
GateType Output GateLevel #fanin fin1..finN #fanout fout1..foutM GateName
```

Gates are numbered 0, 1, 2, … in the order they are listed, and those numbers are used in the fanin/fanout lists. Primary inputs and the added BUFs are counted as gates.

GateType codes: `0=INPUT 1=AND 2=NAND 3=OR 4=NOR 5=XOR 6=XNOR 7=BUF 8=NOT 9=DFF`

## Result for s27.v

```
level :  0  1  2  3  4  5  6  7  8  9
gates :  7  2  4  2  2  2  1  1  3  2      (26 gates total)

Header: 26 4 1 3   (26 gates, 4 inputs, 1 output, 3 flip-flops)
```

See `s27_output.txt` for the full listing.
