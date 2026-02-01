`timescale 1ns / 1ps

import riscv_pkg::*;

module instruction_memory (
    input   logic   [ADDR_WIDTH-1:0]    Addr_i, // Instruction address
    output  logic   [DATA_WIDTH-1:0]    Instr_o // Instruction read
);

    logic   [WORDADDRWIDTH-1:0] word_addr;  // [11:0]
    logic   [   DATA_WIDTH-1:0] mem [DEPTH];

    // initialize from file (program.hex with 32-bit words)
    initial begin
        $readmemh(IMemInitFile, mem);
    end

    assign word_addr    = Addr_i[WORDADDRWIDTH+1:2]; // [13:2]
    assign Instr_o      = mem[word_addr];

endmodule
