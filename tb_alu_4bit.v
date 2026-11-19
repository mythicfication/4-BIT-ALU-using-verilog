// Self-checking testbench for the 4-bit ALU
// Tests all 8 operations plus overflow, borrow and zero-flag edge cases.

`timescale 1ns/1ps

module tb_alu_4bit;

    reg  [3:0] A;
    reg  [3:0] B;
    reg  [2:0] opcode;
    wire [3:0] Y;
    wire carry;
    wire zero;

    integer errors = 0;

    // Device under test
    alu_4bit dut (
        .A(A),
        .B(B),
        .opcode(opcode),
        .Y(Y),
        .carry(carry),
        .zero(zero)
    );

    // Self-checking task: applies inputs, waits, compares against expected values
    task check;
        input [3:0] a_in;
        input [3:0] b_in;
        input [2:0] op_in;
        input [3:0] exp_y;
        input exp_carry;
        input exp_zero;
        input [127:0] name;
        begin
            A = a_in; B = b_in; opcode = op_in;
            #10;
            if (Y !== exp_y || carry !== exp_carry || zero !== exp_zero) begin
                $display("FAIL: %0s  A=%0d B=%0d op=%b -> Y=%0d (exp %0d), carry=%b (exp %b), zero=%b (exp %b)",
                         name, A, B, opcode, Y, exp_y, carry, exp_carry, zero, exp_zero);
                errors = errors + 1;
            end else begin
                $display("PASS: %0s  %0d op %0d = %0d", name, A, B, Y);
            end
        end
    endtask

    initial begin
        // ADD: 5 + 3 = 8
        check(4'd5,  4'd3,  3'b000, 4'd8,  1'b0, 1'b0, "ADD");
        // SUB: 9 - 4 = 5
        check(4'd9,  4'd4,  3'b001, 4'd5,  1'b0, 1'b0, "SUB");
        // AND: 12 & 10 = 8
        check(4'd12, 4'd10, 3'b010, 4'd8,  1'b0, 1'b0, "AND");
        // OR: 12 | 10 = 14
        check(4'd12, 4'd10, 3'b011, 4'd14, 1'b0, 1'b0, "OR");
        // XOR: 12 ^ 10 = 6
        check(4'd12, 4'd10, 3'b100, 4'd6,  1'b0, 1'b0, "XOR");
        // NOT: ~5 = 10
        check(4'd5,  4'd0,  3'b101, 4'd10, 1'b0, 1'b0, "NOT");
        // NAND: ~(12 & 10) = 7
        check(4'd12, 4'd10, 3'b110, 4'd7,  1'b0, 1'b0, "NAND");
        // NOR: ~(12 | 10) = 1
        check(4'd12, 4'd10, 3'b111, 4'd1,  1'b0, 1'b0, "NOR");
        // ADD overflow: 15 + 1 = 0, carry = 1, zero = 1
        check(4'd15, 4'd1,  3'b000, 4'd0,  1'b1, 1'b1, "ADD overflow");
        // SUB borrow: 3 - 5 = 14, carry (borrow) = 1
        check(4'd3,  4'd5,  3'b001, 4'd14, 1'b1, 1'b0, "SUB borrow");
        // Zero flag: 5 ^ 5 = 0
        check(4'd5,  4'd5,  3'b100, 4'd0,  1'b0, 1'b1, "Zero flag");

        if (errors == 0)
            $display("All tests passed.");
        else
            $display("%0d test(s) failed.", errors);

        $finish;
    end

endmodule
