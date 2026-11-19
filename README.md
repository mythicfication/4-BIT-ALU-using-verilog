# 4-Bit ALU using Verilog

A 4-bit Arithmetic Logic Unit (ALU) designed in Verilog HDL. It performs arithmetic and logical operations on two 4-bit inputs, selected by a 3-bit opcode, and produces a 4-bit output along with carry/borrow and zero status flags.

## Overview

The ALU is the core computational block of a CPU. It takes two 4-bit operands `A` and `B`, performs the operation selected by the 3-bit `opcode`, and outputs the 4-bit result `Y`.

```
        +---------+
  A[3:0]--->|         |
            |   ALU   |---> Y[3:0]
  B[3:0]--->|  4-bit  |---> Carry
            |         |---> Zero
opcode[2:0]->|         |
        +---------+
```

## Features

- 8 operations controlled by a 3-bit opcode
- Carry-out generated on addition, borrow on subtraction
- Zero flag set to `1` when the result is `0000`
- Combinational design using a `case` statement
- Verified with a self-checking testbench covering all 8 operations and edge cases like overflow, underflow, and zero result

## Port List

| Port | Direction | Width | Description |
| :--- | :--- | :--- | :--- |
| `A` | Input | 4 bits | First operand |
| `B` | Input | 4 bits | Second operand |
| `opcode` | Input | 3 bits | Operation select |
| `Y` | Output | 4 bits | Result |
| `carry` | Output | 1 bit | Carry-out (ADD) / Borrow (SUB) |
| `zero` | Output | 1 bit | `1` when `Y == 0000` |

## Operations

| Opcode | Operation | Description |
| :----: | :-------: | :---------- |
| `000` | ADD | `A + B` |
| `001` | SUB | `A - B` |
| `010` | AND | `A & B` |
| `011` | OR | `A \| B` |
| `100` | XOR | `A ^ B` |
| `101` | NOT | `~A` |
| `110` | NAND | `~(A & B)` |
| `111` | NOR | `~(A \| B)` |

## Flags

- **Carry (`carry`)** — `1` on overflow during ADD (`A + B > 15`), and `1` on borrow during SUB (`A < B`). `0` for all logical operations.
- **Zero (`zero`)** — `1` when the result `Y` is `0000`, otherwise `0`.

## Files

| File | Description |
| :--- | :---------- |
| `alu_4bit.v` | 4-bit ALU design (synthesizable) |
| `tb_alu_4bit.v` | Self-checking testbench |

## How to Simulate

### Using Icarus Verilog

```bash
iverilog -o alu_sim alu_4bit.v tb_alu_4bit.v
vvp alu_sim
```

### Using Xilinx Vivado / ModelSim

1. Create a new project and add `alu_4bit.v` as a design source.
2. Add `tb_alu_4bit.v` as a simulation source.
3. Run behavioral simulation and check the waveform for `A`, `B`, `opcode`, `Y`, `carry`, and `zero`.

Expected testbench output (as printed by `tb_alu_4bit.v`):

```
PASS: ADD  5 op 3 = 8
PASS: SUB  9 op 4 = 5
PASS: AND  12 op 10 = 8
PASS: OR  12 op 10 = 14
PASS: XOR  12 op 10 = 6
PASS: NOT  5 op 0 = 10
PASS: NAND  12 op 10 = 7
PASS: NOR  12 op 10 = 1
PASS: ADD overflow  15 op 1 = 0
PASS: SUB borrow  3 op 5 = 14
PASS: Zero flag  5 op 5 = 0
All tests passed.
```

## Example

```
A = 0101 (5), B = 0011 (3), opcode = 000 (ADD)
Y = 1000 (8), carry = 0, zero = 0

A = 1111 (15), B = 0001 (1), opcode = 000 (ADD)
Y = 0000 (0), carry = 1, zero = 1
```

## Tools Used

- Verilog HDL
- Xilinx Vivado / ModelSim / Icarus Verilog

## Author

**Anmol Jaiswal** — B.Tech CSE (Data Science & AI), Shri Ramswaroop Memorial University
