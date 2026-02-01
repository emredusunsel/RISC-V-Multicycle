`timescale 1ns / 1ps

import riscv_pkg::*;

module reg_2 (
    input   logic               clk_i,
    input   logic               rstn_i,
    input   logic   [XLEN-1:0]  reg1_i,
    input   logic   [XLEN-1:0]  reg2_i,
    input   logic               wr_en_i,
    output  logic   [XLEN-1:0]  reg1_o,
    output  logic   [XLEN-1:0]  reg2_o
);

    always_ff @(posedge clk_i or negedge rstn_i) begin : reg_func
        if (!rstn_i) begin
            reg1_o  <= '0;
            reg2_o  <= '0;
        end else if (wr_en_i) begin
            reg1_o  <= reg1_i;
            reg2_o  <= reg2_i;
        end
    end

endmodule
