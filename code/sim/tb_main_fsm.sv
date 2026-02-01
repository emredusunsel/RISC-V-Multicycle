`timescale 1ns / 1ps

import riscv_pkg::*;

module tb_main_fsm();

    logic   clk_i, rstn_i;
    opcode_e    opcode_i;
    logic   Zero_i, Branch_o, PCUpdate_o, PCWrite_o;
    logic   RegWrite_o, MemWrite_o, IRWrite_o;
    logic   [1:0]   ResultSrc_o, ALUSrcA_o, ALUSrcB_o;
    logic   AdrSrc_o;
    logic   [1:0]   ALUOp_o;

    main_fsm dut(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .opcode_i       (opcode_i),
        .Zero_i         (Zero_i),
        .Branch_o       (Branch_o),
        .PCUpdate_o     (PCUpdate_o),
        .PCWrite_o      (PCWrite_o),
        .RegWrite_o     (RegWrite_o),
        .MemWrite_o     (MemWrite_o),
        .IRWrite_o      (IRWrite_o),
        .ResultSrc_o    (ResultSrc_o),
        .ALUSrcA_o      (ALUSrcA_o),
        .ALUSrcB_o      (ALUSrcB_o),
        .AdrSrc_o       (AdrSrc_o),
        .ALUOp_o        (ALUOp_o)
    );

    initial clk_i = 0;
    always #5 clk_i = ~clk_i;


    initial begin
        Zero_i = 0;
        rstn_i = 0;
        #10;
        rstn_i = 1;
        opcode_i = OP_INVALID;
        #50;
            opcode_i = OP_L;
        wait(dut.state == S_DECODE);
        wait(dut.next_state == S_FETCH)
            opcode_i = OP_S;

        wait(dut.state == S_DECODE);
        wait(dut.next_state == S_FETCH)
            opcode_i = OP_R;

        wait(dut.state == S_DECODE);
        wait(dut.next_state == S_FETCH)
            opcode_i = OP_B;

        wait(dut.state == S_DECODE);
        wait(dut.next_state == S_FETCH)
            opcode_i = OP_I;

        wait(dut.state == S_DECODE);
        wait(dut.next_state == S_FETCH)
            opcode_i = OP_JAL;

        wait(dut.state == S_DECODE);
        wait(dut.next_state == S_FETCH);
            opcode_i = OP_INVALID;

        #50;
        $finish;
    end

endmodule
