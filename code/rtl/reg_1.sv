`timescale 1ns / 1ps

import riscv_pkg::*;

module reg_1 (
    input   logic               clk_i,
    input   logic               rstn_i,
    input   logic   [XLEN-1:0]  reg_i,
    input   logic               wr_en_i,
    output  logic   [XLEN-1:0]  reg_o
);

    always_ff @(posedge clk_i or negedge rstn_i) begin : reg_func
        if (!rstn_i) begin
            reg_o  <= '0;
        end else if (wr_en_i) begin
            reg_o  <= reg_i;
        end
    end

endmodule
