`timescale 1ns / 1ps

import riscv_pkg::*;

module data_memory (
    input   logic               clk_i,
    input   logic   [XLEN-1:0]  addr_i,
    input   logic   [XLEN-1:0]  wr_data_i,
    input   logic               wr_en_i,
    input   logic   [     2:0]  funct3_i,
    output  logic   [XLEN-1:0]  rd_data_o
);

    logic   [     XLEN-1:0] mem_reg [DMEM_SIZE];
    logic   [DMEM_ADDR-1:0] word_addr;

    always_ff @(posedge clk_i) begin : synchronous_write
        if (wr_en_i) begin
            case (funct3_i)
                S_B:        mem_reg[word_addr] <= wr_data_i[7:0];
                S_H:        mem_reg[word_addr] <= wr_data_i[15:0];
                S_W:        mem_reg[word_addr] <= wr_data_i;
                default:    mem_reg[word_addr] <= wr_data_i;
            endcase
        end
    end

    assign word_addr = addr_i[DMEM_ADDR-1:0];
    assign rd_data_o = wr_en_i ? '0 : mem_reg[word_addr];

endmodule
