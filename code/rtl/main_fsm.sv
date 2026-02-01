`timescale 1ns / 1ps

import riscv_pkg::*;

module main_fsm (
    input   logic           clk_i,
    input   logic           rstn_i,
    input   opcode_e        opcode_i,
    input   opcode_e        oppast_i,
    output  logic           PCUpdate_o,
    output  logic           RegWrite_o,
    output  logic           MemWrite_o,
    output  logic           IRWrite_o,
    output  logic   [1:0]   ResultSrc_o,
    output  logic   [1:0]   ALUSrcA_o,
    output  logic   [1:0]   ALUSrcB_o,
    output  logic           b_en_o,
    output  logic           ALUOP_ow_o,
    // for implementation
    output  state_t         state_o
);

    state_t state, next_state;

    always_ff @(posedge clk_i or negedge rstn_i) begin : initial_state_logic
        if (!rstn_i)
            state   <= S_FETCH;
        else
            state   <= next_state;
    end

    always_comb begin : next_state_logic
        next_state = state;     // default

        case (state)
            S_FETCH: begin
                if ((opcode_i == OP_L) | (opcode_i == OP_S) |
                    (opcode_i == OP_R) | (opcode_i == OP_B) |
                    (opcode_i == OP_I) | (opcode_i == OP_JALR) |
                    (opcode_i == OP_JAL) | (opcode_i == OP_AUIPC) |
                    (opcode_i == OP_LUI)) begin
                    next_state = S_DECODE;
                end else if (opcode_i == OP_NOP) begin
                    next_state = S_FETCH;
                end
            end

            S_DECODE: begin
                if ((oppast_i == OP_L) | (oppast_i == OP_S))
                    next_state = S_MEM_ADR;
                else if (oppast_i == OP_R)
                    next_state = S_EXCT_R;
                else if (oppast_i == OP_B)
                    next_state = S_BQ;
                else if (oppast_i == OP_I)
                    next_state = S_EXCT_I;
                else if (oppast_i == OP_JAL)
                    next_state = S_JAL;
                else if (oppast_i == OP_JALR)
                    next_state = S_JALR1;
                else if (oppast_i == OP_LUI)
                    next_state = S_LUI;
                else if (oppast_i == OP_AUIPC)
                    next_state = S_AUIPC;
            end

            S_MEM_ADR: begin
                if (oppast_i == OP_L)
                    next_state = S_MEM_RD;
                else if (oppast_i == OP_S)
                    next_state = S_MEM_WR;
            end

            S_MEM_RD:   next_state = S_MEM_WB;
            S_EXCT_R:   next_state = S_ALU_WB;
            S_EXCT_I:   next_state = S_ALU_WB;
            S_JAL:      next_state = S_ALU_WB;
            S_JALR1:    next_state = S_JALR2;
            S_JALR2:    next_state = S_ALU_WB;
            S_LUI:      next_state = S_FETCH;
            S_AUIPC:    next_state = S_FETCH;
            S_ALU_WB:   next_state = S_FETCH;
            S_BQ:       next_state = S_FETCH;
            S_MEM_WR:   next_state = S_FETCH;
            S_MEM_WB:   next_state = S_FETCH;
            default:    next_state = S_FETCH;
        endcase
    end

    always_comb begin : output_logic
        // mux signals are X / enable signals are LOW when not in use

        case (state)
            S_FETCH: begin
                IRWrite_o   = 1;
                ALUSrcA_o   = 2'b00;
                ALUSrcB_o   = 2'b10;
                ResultSrc_o = 2'b01;
                PCUpdate_o  = 1;
                ALUOP_ow_o  = 1;
                //
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                b_en_o      = 0;
            end

            S_DECODE: begin
                ALUSrcA_o   = 2'b01;
                ALUSrcB_o   = 2'b01;
                ALUOP_ow_o  = 1;
                //
                PCUpdate_o  = 0;
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                ResultSrc_o = 2'bXX;
                b_en_o      = 0;
            end

            S_MEM_ADR: begin
                ALUSrcA_o   = 2'b10;
                ALUSrcB_o   = 2'b01;
                //
                PCUpdate_o  = 0;
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                ResultSrc_o = 2'bXX;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_MEM_RD: begin
                ResultSrc_o = 2'b00;
                //
                PCUpdate_o  = 0;
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                ALUSrcA_o   = 2'bXX;
                ALUSrcB_o   = 2'bXX;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_EXCT_R: begin
                ALUSrcA_o   = 2'b10;
                ALUSrcB_o   = 2'b00;
                //
                PCUpdate_o  = 0;
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                ResultSrc_o = 2'bXX;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_EXCT_I: begin
                ALUSrcA_o   = 2'b10;
                ALUSrcB_o   = 2'b01;
                //
                PCUpdate_o  = 0;
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                ResultSrc_o = 2'bXX;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_JAL: begin
                ALUSrcA_o   = 2'b01;
                ALUSrcB_o   = 2'b10;
                ResultSrc_o = 2'b00;
                PCUpdate_o  = 1;
                //
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_JALR1: begin
                ALUSrcA_o   = 2'b10;
                ALUSrcB_o   = 2'b01;
                //
                ResultSrc_o = 2'bXX;
                PCUpdate_o  = 0;
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_JALR2: begin
                ALUSrcA_o   = 2'b01;
                ALUSrcB_o   = 2'b10;
                ResultSrc_o = 2'b00;
                PCUpdate_o  = 1;
                //
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_LUI: begin
                ResultSrc_o = 2'b10;
                RegWrite_o  = 1;
                //
                ALUSrcA_o   = 2'bXX;
                ALUSrcB_o   = 2'bXX;
                PCUpdate_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_AUIPC: begin
                ResultSrc_o = 2'b00;
                RegWrite_o  = 1;
                //
                ALUSrcA_o   = 2'bXX;
                ALUSrcB_o   = 2'bXX;
                PCUpdate_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_ALU_WB: begin
                ResultSrc_o = 2'b00;
                RegWrite_o  = 1;
                ALUOP_ow_o  = 1;
                //
                PCUpdate_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                ALUSrcA_o   = 2'bXX;
                ALUSrcB_o   = 2'bXX;
                b_en_o      = 0;
            end

            S_BQ: begin
                ResultSrc_o = 2'b00;
                b_en_o      = 1;
                //
                ALUSrcA_o   = 2'bXX;
                ALUSrcB_o   = 2'bXX;
                PCUpdate_o  = 0;
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                ALUOP_ow_o  = 0;
            end

            S_MEM_WR: begin
                ResultSrc_o = 2'b00;
                MemWrite_o  = 1;
                //
                PCUpdate_o  = 0;
                RegWrite_o  = 0;
                IRWrite_o   = 0;
                ALUSrcA_o   = 2'bXX;
                ALUSrcB_o   = 2'bXX;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            S_MEM_WB: begin
                ResultSrc_o = 2'b11;
                RegWrite_o  = 1;
                //
                PCUpdate_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                ALUSrcA_o   = 2'bXX;
                ALUSrcB_o   = 2'bXX;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end

            default: begin
                PCUpdate_o  = 0;
                RegWrite_o  = 0;
                MemWrite_o  = 0;
                IRWrite_o   = 0;
                ResultSrc_o = 2'bXX;
                ALUSrcA_o   = 2'bXX;
                ALUSrcB_o   = 2'bXX;
                b_en_o      = 0;
                ALUOP_ow_o  = 0;
            end
        endcase
    end

    assign state_o = state;

endmodule
