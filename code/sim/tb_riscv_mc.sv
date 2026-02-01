`timescale 1ns / 1ps

import riscv_pkg::*;

module tb_riscv_mc();

    logic   clk_i, rstn_i;

    riscv_mc dut(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i)
    );

    initial clk_i = 0;
    always #5 clk_i = ~clk_i;

    initial begin
        rstn_i = 0;
        #20;
        rstn_i = 1;
        #2000;
        $finish;
    end

endmodule
