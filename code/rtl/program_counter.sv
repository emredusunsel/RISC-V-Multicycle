`timescale 1ns / 1ps

import riscv_pkg::*;

module program_counter (
    input   logic               clk_i,
    input   logic               rstn_i,
    input   logic   [XLEN-1:0]  PCNext_i,
    input   logic               en_i,
    output  logic   [XLEN-1:0]  PC_o
);

    always_ff @(posedge clk_i) begin : pc
        if (!rstn_i)
            PC_o    <= 32'h8000_0000;
        else if (en_i)
            PC_o    <= PCNext_i;
    end

endmodule
