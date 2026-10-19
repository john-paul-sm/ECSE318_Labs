module freecellPlayer(clock, source, dest, win);
input clock;
input [3:0] source, dest;
output win;

parameter H = 2'b00;
parameter D = 2'b01;
parameter S = 2'b10;
parameter C = 2'b11;
parameter DEPTH = 19;

// Game state: 8 tableau columns, 4 free cells, 4 home cells
reg [5:0] col [0:7][0:DEPTH-1];
reg [4:0] len [0:7];
reg [5:0] fc [0:3];
reg [3:0] home [0:3];

// Per-move state check
reg [5:0] card;
reg [5:0] top;
reg legal;
integer i;

// Win when every home cell holds its King
assign win = (home[0] == 13) && (home[1] == 13) && (home[2] == 13) && (home[3] == 13);

// Convert a suit and rank into a 6-bit code
function [5:0] cd;
input [1:0] s;
input [3:0] r;
begin
  cd = {s, r};
end
endfunction

// Game 8321
initial begin
  for(i = 0; i < 4; i = i + 1) begin
    fc[i] = 0;
    home[i] = 0;
  end
  
  // Cards per column
  len[0] = 7;
  len[1] = 7;
  len[2] = 7;
  len[3] = 7;
  len[4] = 6; 
  len[5] = 6;
  len[6] = 6;
  len[7] = 6;

  // Row 1
  col[0][0] = cd(S,4);
  col[1][0] = cd(S,5);
  col[2][0] = cd(S,11);
  col[3][0] = cd(H,4);
  col[4][0] = cd(D,12);
  col[5][0] = cd(D,5); 
  col[6][0] = cd(H,5);
  col[7][0] = cd(C,11);

  // Row 2
  col[0][1] = cd(D,11);
  col[1][1] = cd(S,10);
  col[2][1] = cd(C,7);
  col[3][1] = cd(S,1);
  col[4][1] = cd(H,11);
  col[5][1] = cd(D,13);
  col[6][1] = cd(D,3);
  col[7][1] = cd(D,4);

  // Row 3
  col[0][2] = cd(D,10);
  col[1][2] = cd(H,8);
  col[2][2] = cd(C,9);
  col[3][2] = cd(C,12);
  col[4][2] = cd(S,12);
  col[5][2] = cd(C,3);
  col[6][2] = cd(H,12);
  col[7][2] = cd(H,10);

  // Row 4
  col[0][3] = cd(D,6);
  col[1][3] = cd(C,4);
  col[2][3] = cd(C,6);
  col[3][3] = cd(C,5);
  col[4][3] = cd(S,6);
  col[5][3] = cd(D,9);
  col[6][3] = cd(D,7);
  col[7][3] = cd(C,8);

  // Row 5
  col[0][4] = cd(S,3);
  col[1][4] = cd(H,6);
  col[2][4] = cd(C,2);
  col[3][4] = cd(S,7);
  col[4][4] = cd(D,2);
  col[5][4] = cd(H,3);
  col[6][4] = cd(C,13);
  col[7][4] = cd(H,7);

  // Row 6
  col[0][5] = cd(D,1);
  col[1][5] = cd(H,13);
  col[2][5] = cd(S,13);
  col[3][5] = cd(H,9);
  col[4][5] = cd(S,9);
  col[5][5] = cd(S,2);
  col[6][5] = cd(C,10);
  col[7][5] = cd(D,8);

  // Row 7
  col[0][6] = cd(H,1);
  col[1][6] = cd(H,2);
  col[2][6] = cd(C,1);
  col[3][6] = cd(S,8);
end

// One move per clock edge
always @(posedge clock) begin
  // Find the card at the source
  if(source[3] == 0) begin
    if(len[source[2:0]] != 0)
      card = col[source[2:0]][len[source[2:0]] - 1];
    else
      card = 0;
  end
  else if(source[3:2] == 2'b10)
    card = fc[source[1:0]];
  else
    card = 0;

  // Check the destination rules
  legal = 0;
  if(card != 0) begin
    if(dest[3] == 0) begin
      if(len[dest[2:0]] == 0)
        legal = 1;
      else begin
        top = col[dest[2:0]][len[dest[2:0]] - 1];
        if((top[5] != card[5]) && (top[3:0] == card[3:0] + 1))
          legal = 1;
      end
    end
    else if(dest[3:2] == 2'b10) begin
      if(fc[dest[1:0]] == 0)
        legal = 1;
    end
    else begin
      if(home[card[5:4]] + 1 == card[3:0])
        legal = 1;
    end
  end

  // If legal, remove the card from the source and place it at the destination
  if(legal) begin
    if(source[3] == 0) begin
      len[source[2:0]] = len[source[2:0]] - 1;
      col[source[2:0]][len[source[2:0]]] = 0;
    end
    else
      fc[source[1:0]] = 0;

    if(dest[3] == 0) begin
      col[dest[2:0]][len[dest[2:0]]] = card;
      len[dest[2:0]] = len[dest[2:0]] + 1;
    end
    else if (dest[3:2] == 2'b10)
      fc[dest[1:0]] = card;
    else
      home[card[5:4]] = card[3:0];
  end
  else
    $display($time,, " illegal move ignored: source=%b dest=%b", source, dest);
end
endmodule