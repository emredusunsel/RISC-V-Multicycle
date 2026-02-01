`timescale 1ns / 1ps

package riscv_pkg;

    parameter DMemInitFile = "dmem.mem";         // delete "string" for lint
    parameter IMemInitFile = "imem.mem";         // delete "string" for lint

    parameter int XLEN          = 32;
    parameter int ADDR_WIDTH    = 32;
    parameter int DATA_WIDTH    = 32;
    parameter int DEPTH         = 4096;                 // # of instructions

    parameter int WORDADDRWIDTH = $clog2(DEPTH);
    parameter int XWIDTH        = $clog2(XLEN);

    parameter int DMEM_SIZE     = 4096;
    parameter int DMEM_ADDR     = $clog2(DMEM_SIZE);

    parameter int ALU_OP        = 4;
    typedef enum logic [ALU_OP-1:0] {
        ALU_ADD     = 4'h0,
        ALU_SUB     = 4'h1,
        ALU_AND     = 4'h2,
        ALU_OR      = 4'h3,
        ALU_XOR     = 4'h4,
        ALU_SLT     = 4'h5,
        ALU_SLTU    = 4'h6,
        ALU_SLL     = 4'h7,
        ALU_SRL     = 4'h8,
        ALU_SRA     = 4'hA
    } alu_op_e;

    typedef enum logic [2:0] {
        EXT_I       = 3'b000,
        EXT_S       = 3'b001,
        EXT_B       = 3'b010,
        EXT_J       = 3'b011,
        EXT_U       = 3'b111
    } ext_op_e;

    typedef enum logic [6:0] {
        OP_L        = 7'b0000011,
        OP_S        = 7'b0100011,
        OP_R        = 7'b0110011,
        OP_B        = 7'b1100011,
        OP_I        = 7'b0010011,
        OP_JALR     = 7'b1100111,
        OP_JAL      = 7'b1101111,
        OP_AUIPC    = 7'b0010111,
        OP_LUI      = 7'b0110111,
        OP_NOP      = 7'b0000000,
        OP_INVALID  = 7'bXXXXXXX
    } opcode_e;

    typedef enum logic [3:0] {
        S_FETCH,
        S_DECODE,
        S_MEM_ADR,
        S_MEM_RD,
        S_MEM_WB,
        S_MEM_WR,
        S_EXCT_R,
        S_ALU_WB,
        S_BQ,
        S_EXCT_I,
        S_JAL,
        S_JALR1,
        S_JALR2,
        S_LUI,
        S_AUIPC
    } state_t;

    typedef enum logic [2:0] {
        BEQ         = 3'd0,
        BNE         = 3'd1,
        BLT         = 3'd4,
        BGE         = 3'd5,
        BLTU        = 3'd6,
        BGEU        = 3'd7
    } branch_op_e;

    typedef enum logic [2:0] {
        L_B         = 3'b000,
        L_H         = 3'b001,
        L_W         = 3'b010,
        L_BU        = 3'b100,
        L_HU        = 3'b101,
        NOT_L       = 3'bXXX
    } load_op_e;

    typedef enum logic [2:0] {
        S_B         = 3'b000,
        S_H         = 3'b001,
        S_W         = 3'b010,
        NOT_S       = 3'bXXX
    } store_op_e;

    typedef enum logic [2:0] {
        IR_ADD      = 3'b000,
        IR_SLL      = 3'b001,
        IR_SLT      = 3'b010,
        IR_SLTU     = 3'b011,
        IR_XOR      = 3'b100,
        IR_SRL_SRA  = 3'b101,
        IR_OR       = 3'b110,
        IR_AND      = 3'b111
    } ir_op_e;

endpackage
