// 4-Bit ALU using Verilog
// Performs 8 arithmetic and logical operations selected by a 3-bit opcode.
// Author: Anmol Jaiswal

module alu_4bit (
    input  [3:0] A,       // First operand
    input  [3:0] B,       // Second operand
    input  [2:0] opcode,  // Operation select
    output reg [3:0] Y,   // Result
    output reg carry,     // Carry-out (ADD) / Borrow (SUB)
    output zero           // Zero flag: 1 when Y == 0000
);

    // Zero flag is combinational on the result
    assign zero = (Y == 4'b0000);

    always @(*) begin
        // Default values
        Y     = 4'b0000;
        carry = 1'b0;

        case (opcode)
            // 000: ADD
            3'b000: begin
                {carry, Y} = A + B;
            end

            // 001: SUB (carry = borrow, 1 when A < B)
            3'b001: begin
                {carry, Y} = A - B;
                carry = (A < B);
            end

            // 010: AND
            3'b010: begin
                Y = A & B;
            end

            // 011: OR
            3'b011: begin
                Y = A | B;
            end

            // 100: XOR
            3'b100: begin
                Y = A ^ B;
            end

            // 101: NOT (of A)
            3'b101: begin
                Y = ~A;
            end

            // 110: NAND
            3'b110: begin
                Y = ~(A & B);
            end

            // 111: NOR
            3'b111: begin
                Y = ~(A | B);
            end

            default: begin
                Y     = 4'b0000;
                carry = 1'b0;
            end
        endcase
    end

endmodule
