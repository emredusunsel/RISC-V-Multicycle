`timescale 1ns / 1ps

import riscv_pkg::*;

module branch_unit (
    input   logic   [XLEN-1:0]  A_i,
    input   logic   [XLEN-1:0]  B_i,
    input   logic   [     2:0]  funct3_i,
    input   logic               b_en_i,
    output  logic               branch_o
);

    always_comb begin : branch
        case (funct3_i)
            BEQ:        branch_o    = b_en_i ? (A_i == B_i) : 0;
            BNE:        branch_o    = b_en_i ? (A_i != B_i) : 0;
            BLT:        branch_o    = b_en_i ? ($signed(A_i) < $signed(B_i)) : 0;
            BGE:        branch_o    = b_en_i ? ($signed(A_i) >= $signed(B_i)) : 0;
            BLTU:       branch_o    = b_en_i ? (A_i < B_i) : 0;
            BGEU:       branch_o    = b_en_i ? (A_i >= B_i) : 0;
            default:    branch_o    = 0;
        endcase
    end

endmodule
