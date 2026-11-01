module RxFIFO (
    input wire PCLK,
    input wire CLEAR_B,
    input wire PWRITE,
    input wire PSEL,
    input wire RxWrite,
    input wire [7:0] RxData,
    output wire SSPRXINTR,
    output reg [7:0] PRDATA

);

    wire empty;
    reg [7:0] fifo_mem [0:3]; // 8 bits wide, 4 locations deep FIFO
    reg [2:0] read_ptr, write_ptr;

    assign empty = (write_ptr == read_ptr);
    assign SSPRXINTR = (write_ptr[1:0] == read_ptr[1:0]) && (write_ptr[2] != read_ptr[2]);

    always @(posedge PCLK) begin
        if (!CLEAR_B) begin
            PRDATA <= 8'b0;
            read_ptr <= 3'b0;
            write_ptr <= 3'b0;
        end
        else begin
            if (RxWrite && !SSPRXINTR) begin
                fifo_mem[write_ptr[1:0]] <= RxData;
                write_ptr <= write_ptr + 1;
            end
            if (PSEL && !PWRITE && !empty) begin
                PRDATA <= fifo_mem[read_ptr[1:0]];
                read_ptr <= read_ptr + 1;
            end
        end
    end

endmodule
