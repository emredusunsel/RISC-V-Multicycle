`timescale 1ns / 1ps

import riscv_pkg::*;

module mux_2 (
    input   logic   [XLEN-1:0]  A_i,
    input   logic   [XLEN-1:0]  B_i,
    input   logic               sel_i,
    output  logic   [XLEN-1:0]  mux_o
);

    assign mux_o = sel_i ? B_i : A_i;

endmodule
