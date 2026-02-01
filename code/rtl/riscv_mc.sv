`timescale 1ns / 1ps

import riscv_pkg::*;

module riscv_mc (
    input   logic               clk_i,
    input   logic               rstn_i
);

    logic               w_PCWrite;
    logic               w_MemWrite;
    logic               w_IRWrite;
    logic               w_RegWrite;
    logic   [     2:0]  w_ImmSrc;
    logic   [     1:0]  w_ALUSrcA;
    logic   [     1:0]  w_ALUSrcB;
    alu_op_e            w_ALUControl;
    logic   [     1:0]  w_ResultSrc;
    logic   [XLEN-1:0]  w_Instr;
    logic               w_Branch;
    logic               w_b_en;
    logic   [XLEN-1:0]  w_InstrPast;

    datapath datapath(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .PCWrite_i      (w_PCWrite),
        .MemWrite_i     (w_MemWrite),
        .IRWrite_i      (w_IRWrite),
        .RegWrite_i     (w_RegWrite),
        .ImmSrc_i       (w_ImmSrc),
        .ALUSrcA_i      (w_ALUSrcA),
        .ALUSrcB_i      (w_ALUSrcB),
        .ALUControl_i   (w_ALUControl),
        .ResultSrc_i    (w_ResultSrc),
        .B_EN_i         (w_b_en),
        .Instr_o        (w_Instr),
        .InstrPast_o    (w_InstrPast),
        .Branch_o       (w_Branch)
    );

    control_unit control_unit(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .Instr_i        (w_Instr),
        .InstrPast_i    (w_InstrPast),
        .branch_i       (w_Branch),
        .PCWrite_o      (w_PCWrite),
        .RegWrite_o     (w_RegWrite),
        .MemWrite_o     (w_MemWrite),
        .IRWrite_o      (w_IRWrite),
        .ResultSrc_o    (w_ResultSrc),
        .ALUSrcA_o      (w_ALUSrcA),
        .ALUSrcB_o      (w_ALUSrcB),
        .ALUControl_o   (w_ALUControl),
        .ImmSrc_o       (w_ImmSrc),
        .b_en_o         (w_b_en)
    );

endmodule
