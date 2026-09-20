module divider #(
    parameter WIDTH = 4
)(
    input wire clk,
    input wire rst, // assume synchronous reset
    input wire start, // load initial values to the regs
    input wire [WIDTH-1:0] divisor,
    input wire [WIDTH-1:0] dividend,
    output wire [WIDTH-1:0] quotient,
    output wire [WIDTH-1:0] remainder,
    output reg busy,
    output reg done
);

reg [WIDTH-1:0] M; // holds the divisor
reg [WIDTH-1:0] D; // holds the dividend then holds the quotient
reg [WIDTH:0] R; // holds the remainder (extra bit for the sign bit)
reg [WIDTH:0] CNT; 

wire [WIDTH:0] shifted_R; // after loading M and D, we shift R and D by 1 bit by comibining them in the format 
assign shifted_R = {R[WIDTH-1:0], D[WIDTH-1]};

always @(posedge clk) begin
    if (rst) begin
        M <= 'b0;
        D <= 'b0;
        R <= 'b0;
        CNT <= 'b0;
        busy <= 1'b0;
        done <= 1'b0;
    end
    else begin
        if (start) begin // the init stage where the divisor and dividend is loaded into registers M and D, R
            M <= divisor;
            D <= dividend;
            R <= 'b0;
            CNT <= WIDTH; // since the number of iterations is equal to the number of bits in our dividend
            busy <= 1'b1;
            done <= 1'b0;
        end
        else if (CNT > 0) begin
            CNT <= CNT - 1;
            if (R[WIDTH] == 1) begin // control logic
                R <= shifted_R + {1'b0, M};
            end
            else begin
                R <= shifted_R - {1'b0, M};
            end
            if (CNT == WIDTH) begin
                D <= {D[WIDTH-2:0], 1'b0};
            end
            else begin
                D <= {D[WIDTH-2:1], ~R[WIDTH], 1'b0};
            end
        end
        else if (busy) begin
            D[0] <= ~R[WIDTH];
           
            if (R[WIDTH] == 1) begin
                R <= R + {1'b0, M};
            end

            busy <= 1'b0;
            done <= 1'b1;
        end
    end
end

assign quotient = D;
assign remainder = R[WIDTH-1:0];

endmodule