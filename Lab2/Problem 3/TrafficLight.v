module TrafficLight(clk,Sa,Sb,Ga,Ya,Ra,Gb,Yb,Rb);
input clk,Sa,Sb;
output Ga,Ya,Ra,Gb,Yb,Rb;

reg Ga,Ya,Ra,Gb,Yb,Rb;
reg [1:0] state;
reg [3:0] count;
reg FS_flash;

parameter Sta_Green = 2'b00;
parameter Sta_Yellow = 2'b01;
parameter Stb_Green = 2'b10;
parameter Stb_Yellow = 2'b11;

initial
begin
state = Sta_Green;
count = 0;
FS_flash = 0;
end

always @(posedge clk)
begin
FS_flash <= ~FS_flash;

case(state)

Sta_Green:
begin
// Street A must remain green for at least 6 clocks
if(count < 5)
count <= count + 1;

// After 6 clocks, check for a car on Street B
else if(Sb == 1)
begin
state <= Sta_Yellow;
count <= 0;
end
end

Sta_Yellow:
begin
// Street A yellow must last 2 clocks
if(count < 1)
count <= count + 1;
else
begin
state <= Stb_Green;
count <= 0;
end
end

Stb_Green:
begin
// Street B green must last at least 5 clock cycles
if(count < 4)
count <= count + 1;

// After 5 clocks, check if Street B should get an additional 5 clock cycles
else if(count == 4)
begin
if(Sb == 1 && Sa == 0)
count <= 5;
else
begin
state <= Stb_Yellow;
count <= 0;
end
end

// Additional 5 clocks of B green
else if(count < 9)
count <= count + 1;

// After the additional 5 clocks, change STreet B to yellow
else
begin
state <= Stb_Yellow;
count <= 0;
end
end

Stb_Yellow:
begin
// Street B yellow must last 2 clock cycles
if(count < 1)
count <= count + 1;
else
begin
state <= Sta_Green;
count <= 0;
end
end

endcase
end

always @(*)
begin
Ga = 0;
Ya = 0;
Ra = 0;
Gb = 0;
Yb = 0;
Rb = 0;

case(state)

Sta_Green:
begin
Ga = 1;
Rb = 1;
end

Sta_Yellow:
begin
Ya = 1;
Rb = 1;
end

Stb_Green:
begin
Ra = 1;
Gb = 1;
end

Stb_Yellow:
begin
Ra = 1;
Yb = 1;
end

endcase

// In case for some reason Ga and Gb are both on, then flash both red lights on and off as 
// a failsafe (FS)
if(Ga && Gb)
begin
Ra = FS_flash;
Rb = FS_flash;
end
end

endmodule
