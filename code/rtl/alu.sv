`timescale 1ns / 1ps

import riscv_pkg::*;

module alu (
    input   logic   [  XLEN-1:0]    A_i,
    input   logic   [  XLEN-1:0]    B_i,
    input   alu_op_e                ALUControl_i,
    output  logic   [  XLEN-1:0]    ALUResult_o
);

    logic   [XWIDTH-1:0]    shamt;

    always_comb begin : alu
        ALUResult_o = '0;
        shamt       = B_i[XWIDTH-1:0];
        case (ALUControl_i)
            ALU_ADD:    ALUResult_o         = A_i + B_i;
            ALU_SUB:    ALUResult_o         = A_i - B_i;
            ALU_AND:    ALUResult_o         = A_i & B_i;
            ALU_OR:     ALUResult_o         = A_i | B_i;
            ALU_XOR:    ALUResult_o         = A_i ^ B_i;
            ALU_SLT: begin
                if ($signed(A_i) < $signed(B_i)) begin
                    ALUResult_o[XLEN-1:1]   = '0;
                    ALUResult_o[0]          = 1;
                end else
                    ALUResult_o             = '0;
            end
            ALU_SLTU: begin
                if ($unsigned(A_i) < $unsigned(B_i)) begin
                    ALUResult_o[XLEN-1:1]   = '0;
                    ALUResult_o[0]          = 1;
                end else
                    ALUResult_o             = '0;
            end
            ALU_SLL:    ALUResult_o         = A_i << shamt;
            ALU_SRL:    ALUResult_o         = A_i >> shamt;
            ALU_SRA:    ALUResult_o         = $signed(A_i) >>> shamt;
            default:    ALUResult_o         = '0;
        endcase
    end

endmodule
