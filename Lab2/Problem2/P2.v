module processor (clk, reset, halt);

    input clk, reset;
    output halt;
    reg halt;

    // Instruction type & Opcodes
    parameter NOP = 4'd0;
    parameter LD = 4'd1;
    parameter STR = 4'd2;
    parameter BRA = 4'd3;
    parameter XOR = 4'd4;
    parameter ADD = 4'd5;
    parameter ROT = 4'd6;
    parameter SHF = 4'd7;
    parameter HLF = 4'd8;
    parameter CMP = 4'd9;

    // Source types
    parameter REG = 1'b0;
    parameter IMM = 1'b1;

    // Condition codes
    parameter A_cc = 4'd0;
    parameter P_cc = 4'd1;
    parameter E_cc = 4'd2;
    parameter C_cc = 4'd3;
    parameter N_cc = 4'd4;
    parameter Z_cc = 4'd5;
    parameter NC_cc = 4'd6;
    parameter PO_cc = 4'd7;

    // Starting address for the program
    parameter START = 12'd16;

    // Storage for the processor
    reg [31:0] MEM [0:4095];
    reg [31:0] R [0:15];
    reg [11:0] PC;
    reg [31:0] IR;
    reg [4:0] PSR;
    
    // Temporary registers for instruction decoding and execution
    reg [3:0] opcode, cc;
    reg stype;
    reg [11:0] saddr, daddr;
    reg [31:0] imm;
    reg [31:0] src, result;
    reg carry, setPSR, take;
    reg [11:0] cnt, n;
    reg [32:0] temp33;
    reg [63:0] temp64;
    
    // Processor
    always @(posedge clk or negedge reset)
    begin
        if (!reset)
        begin
            PC = START;
            PSR = 5'b0;
            IR = 32'b0;
            halt = 1'b0;
        end
        else if (!halt)
        begin
        // Fetch the next instruction
        IR = MEM[PC];
        PC = PC + 1;

        // Decode the instruction
        opcode = IR[31:28];
        cc = IR[27:24];
        stype = IR[27];
        saddr = IR[23:12];
        daddr = IR[11:0];
        imm = {{20{IR[23]}}, IR[23:12]};
        setPSR = 1'b0;
        carry = 1'b0;
    
        // Execute the instruction
        case (opcode)
            NOP: PC = PC;
    
            LD: begin
            if (stype)
                result = imm;
            else 
                result = MEM[saddr];
            R[daddr[3:0]] = result;
            setPSR = 1'b1;
            end
    
            STR: begin
            if (stype)
                result = imm;
            else 
                result = R[saddr[3:0]];
            MEM[daddr] = result;
            PSR = 5'b0;
            end
    
            BRA: begin
            case (cc)
                A_cc: take = 1'b1;
                P_cc: take = PSR[1];
                E_cc: take = PSR[2];
                C_cc: take = PSR[0];
                N_cc: take = PSR[3];
                Z_cc: take = PSR[4];
                NC_cc: take = ~PSR[0];
                PO_cc: take = ~PSR[3] & ~PSR[4];
                default: take = 1'b0;
            endcase
            if (take) 
                PC = daddr;
            end
    
            XOR: begin
            if (stype)
                src = imm;
            else 
                src = R[saddr[3:0]];
            result = R[daddr[3:0]] ^ src;
            R[daddr[3:0]] = result;
            setPSR = 1'b1;
            end
    
            ADD: begin
            if (stype)
                src = imm;
            else 
                src = R[saddr[3:0]];
            {carry, result} = R[daddr[3:0]] + src;
            R[daddr[3:0]] = result;
            setPSR = 1'b1;
            end
    
            ROT: begin
            cnt = saddr;
            if (cnt[11])
                n = -cnt;
            else 
                n = cnt;
            if (cnt[11]) begin
                temp64 = {R[daddr[3:0]], R[daddr[3:0]]} << n;
                result = temp64[63:32];
                carry  = result[0];
            end
            else begin
                temp64 = {R[daddr[3:0]], R[daddr[3:0]]} >> n;
                result = temp64[31:0];
                carry  = result[31];
            end
            if (n == 0) 
                carry = 1'b0;
            R[daddr[3:0]] = result;
            setPSR = 1'b1;
            end
    
            SHF: begin
            cnt = saddr;
            if (cnt[11])
                n = -cnt; 
            else
                n = cnt;
            if (cnt[11]) begin
                temp33 = {1'b0, R[daddr[3:0]]} << n;
                carry  = temp33[32];
                result = temp33[31:0];
            end
            else begin
                temp33 = {R[daddr[3:0]], 1'b0} >> n;
                carry  = temp33[0];
                result = temp33[32:1];
            end
            R[daddr[3:0]] = result;
            setPSR = 1'b1;
            end
    
            HLT: begin
            halt = 1'b1;
            if (PROG == 1)
                $display($time,, "Part 2a: N = %0d   -N = %h", MEM[0], MEM[1]);
            else if (PROG == 2)
                $display($time,, "Part 2b: MEM[0] = %h   number of ones = %0d", MEM[0], MEM[1]);
            else
                $display($time,, "Part 2c: A = %0d   B = %0d   C = %0d", MEM[0], MEM[1], MEM[2]);
            end
    
            CMP: begin
            if (stype) 
                src = imm;
            else 
                src = R[saddr[3:0]];
            result = ~src;
            R[daddr[3:0]] = result;
            setPSR = 1'b1;
            end
    
            default: PC = PC;
        endcase
    
        // Update the PSR flags
        if (setPSR)
        begin
            PSR[0] = carry;
            PSR[1] = ^result;
            PSR[2] = ~result[0];
            PSR[3] = result[31];
            PSR[4] = ~|result;
        end
        end
    end

    // Ram memory model
    initial begin
        if (PROG == 1) begin
        // Part 2a
        MEM[0] = 32'd6;
        MEM[16] = {LD, REG, 1'b0, 2'b00, 12'd0, 12'd0};
        MEM[17] = {CMP, REG, 1'b0, 2'b00, 12'd0, 12'd0};
        MEM[18] = {ADD, IMM, 1'b0, 2'b00, 12'd1, 12'd0};
        MEM[19] = {STR, REG, 1'b0, 2'b00, 12'd0, 12'd1};
        MEM[20] = {HLT, 28'd0};
        end
        else if (PROG == 2) begin
        // Part 2b
        MEM[0] = 32'h8000_00F3;
        MEM[16] = {LD, REG, 1'b0, 2'b00, 12'd0, 12'd0};
        MEM[17] = {LD, IMM, 1'b0, 2'b00, 12'd0, 12'd1};
        MEM[18] = {SHF, IMM, 1'b0, 2'b00, 12'd1, 12'd0};
        MEM[19] = {BRA, NC_cc, 12'd0, 12'd21};
        MEM[20] = {ADD, IMM, 1'b0, 2'b00, 12'd1, 12'd1};
        MEM[21] = {ADD, IMM, 1'b0, 2'b00, 12'd0, 12'd0};
        MEM[22] = {BRA, Z_cc, 12'd0, 12'd24};
        MEM[23] = {BRA, A_cc, 12'd0, 12'd18};
        MEM[24] = {STR, REG, 1'b0, 2'b00, 12'd1, 12'd1};
        MEM[25] = {HLT, 28'd0};
        end
        else begin
        // Part 2c
        MEM[0] = 32'd31;
        MEM[1] = 32'd27;
        MEM[16] = {LD, REG, 1'b0, 2'b00, 12'd0, 12'd0};
        MEM[17] = {LD, REG, 1'b0, 2'b00, 12'd1, 12'd1};
        MEM[18] = {LD, IMM, 1'b0, 2'b00, 12'd0, 12'd2};
        MEM[19] = {LD, IMM, 1'b0, 2'b00, 12'd5, 12'd3};
        MEM[20] = {SHF, IMM, 1'b0, 2'b00, 12'd1, 12'd1};
        MEM[21] = {BRA, NC_cc, 12'd0, 12'd23};
        MEM[22] = {ADD, REG, 1'b0, 2'b00, 12'd0, 12'd2};
        MEM[23] = {SHF, IMM, 1'b0, 2'b00, 12'hFFF, 12'd0};
        MEM[24] = {ADD, IMM, 1'b0, 2'b00, 12'hFFF, 12'd3};
        MEM[25] = {BRA, Z_cc, 12'd0, 12'd27};
        MEM[26] = {BRA, A_cc, 12'd0, 12'd20};
        MEM[27] = {STR, REG, 1'b0, 2'b00, 12'd2, 12'd2};
        MEM[28] = {HLT, 28'd0};
        end
    end
endmodule