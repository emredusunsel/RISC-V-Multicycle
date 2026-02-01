`timescale 1ns / 1ps

import riscv_pkg::*;

module mux_4 (
    input   logic   [XLEN-1:0]  A_i,
    input   logic   [XLEN-1:0]  B_i,
    input   logic   [XLEN-1:0]  C_i,
    input   logic   [XLEN-1:0]  D_i,
    input   logic   [     1:0]  sel_i,
    output  logic   [XLEN-1:0]  mux_o
);

    always_comb begin : mux_8
        case (sel_i)
            2'b00:      mux_o = A_i;
            2'b01:      mux_o = B_i;
            2'b10:      mux_o = C_i;
            2'b11:      mux_o = D_i;
            default:    mux_o = '0;
        endcase
    end

endmodule
