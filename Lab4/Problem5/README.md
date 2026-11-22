# To Run

Type this in the CLI:

```
vlib work
vcom P5.vhdl P5testbench.vhdl
vsim P5testbench.vhdl
```

Then, go to the sim panel on the left and then right click ``p5testbench``, click Add > To Wave > All items in region and below.

Go back to your CLI and type:

```
run -all
```

For a better view, type:

```
wave zoom full
```
