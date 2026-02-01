`timescale 1ns / 1ps

import riscv_pkg::*;

module instr_decoder (
    input   opcode_e        opcode_i,
    output  logic   [2:0]   ImmSrc_o
);

    always_comb begin : immediate_source
        case (opcode_i)
            OP_L:       ImmSrc_o = EXT_I;
            OP_S:       ImmSrc_o = EXT_S;
            OP_R:       ImmSrc_o = 3'bXXX;
            OP_B:       ImmSrc_o = EXT_B;
            OP_I:       ImmSrc_o = EXT_I;
            OP_JALR:    ImmSrc_o = EXT_I;
            OP_JAL:     ImmSrc_o = EXT_J;
            OP_AUIPC:   ImmSrc_o = EXT_U;
            OP_LUI:     ImmSrc_o = EXT_U;
            default:    ImmSrc_o = EXT_I;
        endcase
    end

endmodule
