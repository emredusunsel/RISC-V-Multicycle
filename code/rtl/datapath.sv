`timescale 1ns / 1ps

import riscv_pkg::*;

module datapath (
    input   logic                   clk_i,
    input   logic                   rstn_i,
    input   logic                   PCWrite_i,
    input   logic                   MemWrite_i,
    input   logic                   IRWrite_i,
    input   logic                   RegWrite_i,
    input   logic   [       2:0]    ImmSrc_i,
    input   logic   [       1:0]    ALUSrcA_i,
    input   logic   [       1:0]    ALUSrcB_i,
    input   alu_op_e                ALUControl_i,
    input   logic   [       1:0]    ResultSrc_i,
    input   logic                   B_EN_i,
    output  logic   [  XLEN-1:0]    Instr_o,
    output  logic   [  XLEN-1:0]    InstrPast_o,
    output  logic                   Branch_o,
    // for implementation
    output  logic   [  XLEN-1:0]    PC_o,
    output  logic   [XWIDTH-1:0]    dbg_reg_addr,
    output  logic   [  XLEN-1:0]    dbg_reg_data,
    output  logic   [  XLEN-1:0]    dbg_mem_addr,
    output  logic   [  XLEN-1:0]    dbg_mem_data
);

    // wires are named considering which port they are coming out off
    logic   [XLEN-1:0]  ALU_w;
    logic   [XLEN-1:0]  r_rfout_rd1_w;
    logic   [XLEN-1:0]  r_rfout_rd2_w;
    logic   [XLEN-1:0]  Instr_w;            // exception for instruction
    logic   [XLEN-1:0]  EXT_w;
    logic   [XLEN-1:0]  IDMEM_w;
    logic   [XLEN-1:0]  r_data_w;
    logic   [XLEN-1:0]  LSU_w;
    logic   [XLEN-1:0]  PC_w;
    logic   [XLEN-1:0]  RF_RD1_w;
    logic   [XLEN-1:0]  RF_RD2_w;
    logic   [XLEN-1:0]  r_instr_rd1_w;
    logic   [XLEN-1:0]  r_aluout_w;
    logic   [XLEN-1:0]  PCP4_w;
    logic   [XLEN-1:0]  DMEM_w;

    // mux outputs are named by port they are connected to and with "m" tag
    logic   [XLEN-1:0]  ALU_A_m;
    logic   [XLEN-1:0]  ALU_B_m;
    logic   [XLEN-1:0]  IDMEM_Adr_m;
    logic   [XLEN-1:0]  RESULT_m;

    alu alu(
        .A_i            (ALU_A_m),
        .B_i            (ALU_B_m),
        .ALUControl_i   (ALUControl_i),
        .ALUResult_o    (ALU_w)
    );

    branch_unit branch_unit(
        .A_i            (r_rfout_rd1_w),
        .B_i            (r_rfout_rd2_w),
        .funct3_i       (Instr_w[14:12]),
        .b_en_i         (B_EN_i),
        .branch_o       (Branch_o)
    );

    data_memory data_memory(
        .clk_i          (clk_i),
        .addr_i         (RESULT_m),
        .wr_data_i      (r_rfout_rd2_w),
        .wr_en_i        (MemWrite_i),
        .funct3_i       (Instr_w[14:12]),
        .rd_data_o      (DMEM_w)
    );

    extend_unit extend_unit(
        .Imm_i          (Instr_w),
        .Imm_Src_i      (ImmSrc_i),
        .Ext_o          (EXT_w)
    );

    instruction_memory instruction_memory(
        .Addr_i         (PC_w),
        .Instr_o        (IDMEM_w)
    );

    load_store_unit load_store_unit(
        .mem_data_i     (r_data_w),
        .funct3_i       (Instr_w[14:12]),
        .lsu_o          (LSU_w)
    );

    program_counter program_counter(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .PCNext_i       (RESULT_m),
        .en_i           (PCWrite_i),
        .PC_o           (PC_w)
    );

    register_file register_file(
        .clk_i          (clk_i),
        .rd_addr1_i     (Instr_w[19:15]),
        .rd_addr2_i     (Instr_w[24:20]),
        .wr_addr_i      (Instr_w[11:7]),
        .wr_data_i      (RESULT_m),
        .wr_en_i        (RegWrite_i),
        .rd_data1_o     (RF_RD1_w),
        .rd_data2_o     (RF_RD2_w)
    );

    reg_1 r_data(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .reg_i          (DMEM_w),
        .wr_en_i        (1'b1),
        .reg_o          (r_data_w)
    );

    reg_2 r_instr(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .reg1_i         (PC_w),
        .reg2_i         (IDMEM_w),
        .wr_en_i        (IRWrite_i),
        .reg1_o         (r_instr_rd1_w),
        .reg2_o         (Instr_w)
    );

    reg_2 r_rfout(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .reg1_i         (RF_RD1_w),
        .reg2_i         (RF_RD2_w),
        .wr_en_i        (1'b1),
        .reg1_o         (r_rfout_rd1_w),
        .reg2_o         (r_rfout_rd2_w)
    );

    reg_1 r_aluout(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .reg_i          (ALU_w),
        .wr_en_i        (1'b1),
        .reg_o          (r_aluout_w)
    );

    mux_4 m_alua(
        .A_i            (PC_w),
        .B_i            (r_instr_rd1_w),
        .C_i            (r_rfout_rd1_w),
        .D_i            ('0),
        .sel_i          (ALUSrcA_i),
        .mux_o          (ALU_A_m)
    );

    mux_4 m_alub(
        .A_i            (r_rfout_rd2_w),
        .B_i            (EXT_w),
        .C_i            (PCP4_w),
        .D_i            ('0),
        .sel_i          (ALUSrcB_i),
        .mux_o          (ALU_B_m)
    );

    mux_4 m_result(
        .A_i            (r_aluout_w),
        .B_i            (ALU_w),
        .C_i            (EXT_w),
        .D_i            (LSU_w),
        .sel_i          (ResultSrc_i),
        .mux_o          (RESULT_m)
    );

    assign PCP4_w       = {29'b0, 3'b100};
    assign Instr_o      = IDMEM_w;
    assign InstrPast_o  = Instr_w;

    assign PC_o         = PC_w;
    assign dbg_reg_addr = Instr_w[11:7];
    assign dbg_reg_data = RESULT_m;
    assign dbg_mem_addr = RESULT_m;
    assign dbg_mem_data = r_rfout_rd2_w;

endmodule
