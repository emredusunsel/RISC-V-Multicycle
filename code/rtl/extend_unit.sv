`timescale 1ns / 1ps

import riscv_pkg::*;

module extend_unit (
    input   logic   [XLEN-1:0]  Imm_i,          // Instruction[31:7]
    input   logic   [     2:0]  Imm_Src_i,   //  000: I, 001: S, 010: B, 011: J, 100: U
    output  logic   [XLEN-1:0]  Ext_o
);

    always_comb begin : extend
        Ext_o    = '0;
        case (Imm_Src_i)
            EXT_I:      Ext_o = {{20{Imm_i[31]}}, Imm_i[31:20]};
            EXT_S:      Ext_o = {{20{Imm_i[31]}}, Imm_i[31:25], Imm_i[11:7]};
            EXT_B:      Ext_o = {{20{Imm_i[31]}}, Imm_i[7], Imm_i[30:25], Imm_i[11:8], 1'b0};
            EXT_J:      Ext_o = {{12{Imm_i[31]}}, Imm_i[19:12], Imm_i[20], Imm_i[30:21], 1'b0};
            EXT_U:      Ext_o = {Imm_i[31:12], 12'b0};
            default:    Ext_o  = '0;
        endcase
    end

endmodule
