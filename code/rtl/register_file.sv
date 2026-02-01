`timescale 1ns / 1ps

import riscv_pkg::*;

module register_file (
    input   logic                   clk_i,
    input   logic   [XWIDTH-1:0]    rd_addr1_i,
    input   logic   [XWIDTH-1:0]    rd_addr2_i,
    input   logic   [XWIDTH-1:0]    wr_addr_i,
    input   logic   [  XLEN-1:0]    wr_data_i,
    input   logic                   wr_en_i,
    output  logic   [  XLEN-1:0]    rd_data1_o,
    output  logic   [  XLEN-1:0]    rd_data2_o
);

    logic   [XLEN-1:0]  regs    [XLEN];

    // Initialize the registers
    // Setting all to '0 is recommended
    // Optional: Only x0 = '0, other registers are undefined
    integer i;
    initial begin
        for (i = 0; i < XLEN; i = i + 1) begin
            regs[i] = '0;
        end
    end

    // Write: Synchronous
    always_ff @(posedge clk_i) begin : synchronous_write
        if ((wr_en_i == 1) && (wr_addr_i != 0))
            regs[wr_addr_i]   <= wr_data_i;
    end

    // READ: Asynchronous
    assign rd_data1_o = (rd_addr1_i == 0) ? '0: regs[rd_addr1_i];
    assign rd_data2_o = (rd_addr2_i == 0) ? '0: regs[rd_addr2_i];

endmodule
