`timescale 1ns / 1ps

import riscv_pkg::*;

module control_unit (
    input   logic                   clk_i,
    input   logic                   rstn_i,
    input   logic   [  XLEN-1:0]    Instr_i,
    input   logic   [  XLEN-1:0]    InstrPast_i,
    input   logic                   branch_i,
    output  logic                   PCWrite_o,
    output  logic                   RegWrite_o,
    output  logic                   MemWrite_o,
    output  logic                   IRWrite_o,
    output  logic   [       1:0]    ResultSrc_o,
    output  logic   [       1:0]    ALUSrcA_o,
    output  logic   [       1:0]    ALUSrcB_o,
    output  alu_op_e                ALUControl_o,
    output  logic   [       2:0]    ImmSrc_o,
    output  logic                   b_en_o,
    // for implementation
    output  state_t                 state_dbg
);

    logic       w_PCUpdate;
    opcode_e    w_opcode;
    opcode_e    w_oppast_i;
    logic       w_ALUOP_ow;

    main_fsm main_fsm(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .opcode_i       (w_opcode),
        .oppast_i       (w_oppast_i),
        .PCUpdate_o     (w_PCUpdate),
        .RegWrite_o     (RegWrite_o),
        .MemWrite_o     (MemWrite_o),
        .IRWrite_o      (IRWrite_o),
        .ResultSrc_o    (ResultSrc_o),
        .ALUSrcA_o      (ALUSrcA_o),
        .ALUSrcB_o      (ALUSrcB_o),
        .b_en_o         (b_en_o),
        .ALUOP_ow_o     (w_ALUOP_ow),
        // for implementation
        .state_o        (state_dbg)
    );

    alu_decoder alu_decoder(
        .opcode_i       (w_oppast_i),
        .funct3_i       (InstrPast_i[14:12]),
        .funct7_i       (InstrPast_i[31:25]),
        .ALUOP_ow_i     (w_ALUOP_ow),
        .ALUControl_o   (ALUControl_o)
    );

    instr_decoder instr_decoder(
        .opcode_i       (w_oppast_i),
        .ImmSrc_o       (ImmSrc_o)
    );

    assign PCWrite_o = (branch_i | w_PCUpdate);

    always_comb begin : opcode_to_enum
        case (Instr_i[6:0])
            OP_L:       w_opcode = OP_L;
            OP_S:       w_opcode = OP_S;
            OP_R:       w_opcode = OP_R;
            OP_B:       w_opcode = OP_B;
            OP_I:       w_opcode = OP_I;
            OP_JALR:    w_opcode = OP_JALR;
            OP_JAL:     w_opcode = OP_JAL;
            OP_AUIPC:   w_opcode = OP_AUIPC;
            OP_LUI:     w_opcode = OP_LUI;
            OP_NOP:     w_opcode = OP_NOP;
            default:    w_opcode = OP_INVALID;
        endcase
    end

    always_comb begin : opcode_to_enum2
        case (InstrPast_i[6:0])
            OP_L:       w_oppast_i = OP_L;
            OP_S:       w_oppast_i = OP_S;
            OP_R:       w_oppast_i = OP_R;
            OP_B:       w_oppast_i = OP_B;
            OP_I:       w_oppast_i = OP_I;
            OP_JALR:    w_oppast_i = OP_JALR;
            OP_JAL:     w_oppast_i = OP_JAL;
            OP_AUIPC:   w_oppast_i = OP_AUIPC;
            OP_LUI:     w_oppast_i = OP_LUI;
            OP_NOP:     w_oppast_i = OP_NOP;
            default:    w_oppast_i = OP_INVALID;
        endcase
    end

endmodule
