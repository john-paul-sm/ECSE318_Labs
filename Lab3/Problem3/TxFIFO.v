module TxFIFO (
    input wire PCLK,
    input wire CLEAR_B,
    input wire PSEL,
    input wire PWRITE,
    input wire [7:0] PWDATA,
    input wire TxRead,
    output wire SSPTXINTR,
    output wire empty,
    output reg [7:0] TxData

);

    reg [7:0] fifo_mem [0:3]; // 8 bits wide, 4 locations deep FIFO
    reg [2:0] read_ptr, write_ptr;

    assign empty = (write_ptr == read_ptr);
    assign SSPTXINTR = (write_ptr[1:0] == read_ptr[1:0]) && (write_ptr[2] != read_ptr[2]);

    always @(posedge PCLK) begin
        if (!CLEAR_B) begin
            TxData <= 8'b0;
            read_ptr <= 3'b0;
            write_ptr <= 3'b0;
        end
        else begin
            if (PSEL && PWRITE && !SSPTXINTR) begin
                fifo_mem[write_ptr[1:0]] <= PWDATA;
                write_ptr <= write_ptr + 1;
            end
            if (TxRead && !empty) begin
                TxData <= fifo_mem[read_ptr[1:0]];
                read_ptr <= read_ptr + 1;
            end
        end
    end

endmodule
