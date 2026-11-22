module tb_alu;

    reg  [15:0] A;
    reg  [15:0] B;
    reg  [4:0]  alu_code;
    wire [15:0] C;
    wire        overflow;

    reg  [15:0] exp_C;
    reg         exp_ov;
    reg  [16:0] t;

    integer     errors;
    integer     tests;
    integer     i;
    integer     k;

    reg  [15:0] vecA [0:11];
    reg  [15:0] vecB [0:11];

    alu dut (
        .A        (A),
        .B        (B),
        .alu_code (alu_code),
        .C        (C),
        .overflow (overflow)
    );

    function [8*5-1:0] opname;
        input [4:0] code;
        begin
            case (code)
                5'b00000: opname = "add  ";
                5'b00001: opname = "addu ";
                5'b00010: opname = "sub  ";
                5'b00011: opname = "subu ";
                5'b00100: opname = "inc  ";
                5'b00101: opname = "dec  ";
                5'b01000: opname = "and  ";
                5'b01001: opname = "or   ";
                5'b01010: opname = "xor  ";
                5'b01100: opname = "not  ";
                5'b10000: opname = "sll  ";
                5'b10001: opname = "srl  ";
                5'b10010: opname = "sla  ";
                5'b10011: opname = "sra  ";
                5'b11000: opname = "sle  ";
                5'b11001: opname = "slt  ";
                5'b11010: opname = "sge  ";
                5'b11011: opname = "sgt  ";
                5'b11100: opname = "seq  ";
                5'b11101: opname = "sne  ";
                default:  opname = "undef";
            endcase
        end
    endfunction

    task compute_expected;
        begin
            exp_C  = 16'h0000;
            exp_ov = 1'b0;
            case (alu_code)
                5'b00000: begin
                    t      = A + B;
                    exp_C  = t[15:0];
                    exp_ov = (A[15] == B[15]) && (exp_C[15] != A[15]);
                end
                5'b00001: begin
                    t      = A + B;
                    exp_C  = t[15:0];
                end
                5'b00010: begin
                    t      = A - B;
                    exp_C  = t[15:0];
                    exp_ov = (A[15] != B[15]) && (exp_C[15] != A[15]);
                end
                5'b00011: begin
                    t      = A - B;
                    exp_C  = t[15:0];
                end
                5'b00100: begin
                    exp_C  = A + 16'h0001;
                    exp_ov = (A == 16'h7FFF);
                end
                5'b00101: begin
                    exp_C  = A - 16'h0001;
                    exp_ov = (A == 16'h8000);
                end
                5'b01000: exp_C = A & B;
                5'b01001: exp_C = A | B;
                5'b01010: exp_C = A ^ B;
                5'b01100: exp_C = ~A;
                5'b10000: exp_C = A << B[3:0];
                5'b10001: exp_C = A >> B[3:0];
                5'b10010: exp_C = A << B[3:0];
                5'b10011: exp_C = $signed(A) >>> B[3:0];
                5'b11000: exp_C = ($signed(A) <= $signed(B)) ? 16'h0001 : 16'h0000;
                5'b11001: exp_C = ($signed(A) <  $signed(B)) ? 16'h0001 : 16'h0000;
                5'b11010: exp_C = ($signed(A) >= $signed(B)) ? 16'h0001 : 16'h0000;
                5'b11011: exp_C = ($signed(A) >  $signed(B)) ? 16'h0001 : 16'h0000;
                5'b11100: exp_C = (A == B) ? 16'h0001 : 16'h0000;
                5'b11101: exp_C = (A != B) ? 16'h0001 : 16'h0000;
                default:  begin exp_C = 16'h0000; exp_ov = 1'b0; end
            endcase
        end
    endtask

    task apply;
        input [4:0]  code;
        input [15:0] a;
        input [15:0] b;
        input        show;
        begin
            alu_code = code;
            A        = a;
            B        = b;
            #20;
            compute_expected;
            tests = tests + 1;
            if ((C !== exp_C) || (overflow !== exp_ov)) begin
                errors = errors + 1;
                $display("FAIL %s A=%h B=%h | C=%h ov=%b | expected C=%h ov=%b",
                         opname(code), a, b, C, overflow, exp_C, exp_ov);
            end
            else if (show) begin
                $display("PASS %s A=%h B=%h | C=%h ov=%b",
                         opname(code), a, b, C, overflow);
            end
        end
    endtask

    initial begin
        errors = 0;
        tests  = 0;

        vecA[0]  = 16'h0000;  vecB[0]  = 16'h0000;
        vecA[1]  = 16'h0001;  vecB[1]  = 16'h0001;
        vecA[2]  = 16'h7FFF;  vecB[2]  = 16'h0001;
        vecA[3]  = 16'h8000;  vecB[3]  = 16'h0001;
        vecA[4]  = 16'hFFFF;  vecB[4]  = 16'hFFFF;
        vecA[5]  = 16'h7F00;  vecB[5]  = 16'h0300;
        vecA[6]  = 16'hFF00;  vecB[6]  = 16'h0100;
        vecA[7]  = 16'h8000;  vecB[7]  = 16'h7FFF;
        vecA[8]  = 16'hF0F0;  vecB[8]  = 16'h000F;
        vecA[9]  = 16'h8421;  vecB[9]  = 16'h0004;
        vecA[10] = 16'hFFFE;  vecB[10] = 16'h0002;
        vecA[11] = 16'h1234;  vecB[11] = 16'h1234;

        $display("---- Directed tests: every opcode ----");
        for (k = 0; k < 32; k = k + 1)
            for (i = 0; i < 12; i = i + 1)
                apply(k[4:0], vecA[i], vecB[i], 1'b1);

        $display("---- Random tests: every opcode ----");
        for (k = 0; k < 32; k = k + 1)
            for (i = 0; i < 200; i = i + 1)
                apply(k[4:0], $random, $random, 1'b0);

        $display("---- %0d tests, %0d errors ----", tests, errors);
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED");
        $finish;
    end

endmodule
