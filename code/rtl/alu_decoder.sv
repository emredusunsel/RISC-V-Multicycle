`timescale 1ns / 1ps

import riscv_pkg::*;

module alu_decoder (
    input   opcode_e                opcode_i,
    input   logic   [       2:0]    funct3_i,
    input   logic   [       6:0]    funct7_i,
    input   logic                   ALUOP_ow_i,
    output  alu_op_e                ALUControl_o
);

    always_comb begin : alu_decoder
        ALUControl_o = ALU_ADD;
        case (opcode_i)
            OP_I: begin
                case (funct3_i)
                    IR_ADD:     ALUControl_o = ALU_ADD;
                    IR_SLL: if (funct7_i == 7'b0000000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SLL;
                    IR_SLT:     ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SLT;
                    IR_SLTU:    ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SLTU;
                    IR_XOR:     ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_XOR;
                    IR_SRL_SRA: begin
                        if (funct7_i == 7'b0000000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SRL;
                        else if (funct7_i == 7'b0100000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SRA;
                    end
                    IR_OR:      ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_OR;
                    IR_AND:     ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_AND;
                    default:    ALUControl_o = ALU_ADD;
                endcase
            end

            OP_R: begin
                case (funct3_i)
                    IR_ADD: begin
                        if (funct7_i == 7'b0000000)
                                ALUControl_o = ALU_ADD;
                        else if (funct7_i == 7'b0100000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SUB;
                    end
                    IR_SLL: if (funct7_i == 7'b0000000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SLL;
                    IR_SLT: if (funct7_i == 7'b0000000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SLT;
                    IR_SLTU:if (funct7_i == 7'b0000000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SLTU;
                    IR_XOR: if (funct7_i == 7'b0000000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_XOR;
                    IR_SRL_SRA: begin
                        if (funct7_i == 7'b0000000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SRL;
                        else if (funct7_i == 7'b0100000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_SRA;
                    end
                    IR_OR:  if (funct7_i == 7'b0000000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_OR;
                    IR_AND: if (funct7_i == 7'b0000000)
                                ALUControl_o = ALUOP_ow_i ? ALU_ADD : ALU_AND;
                    default:    ALUControl_o = ALU_ADD;
                endcase
            end

            default: ALUControl_o = ALU_ADD;
        endcase
    end

endmodule
