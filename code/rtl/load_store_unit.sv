`timescale 1ns / 1ps

import riscv_pkg::*;

module load_store_unit (
    input   logic   [XLEN-1:0]  mem_data_i,
    input   logic   [     2:0]  funct3_i,
    output  logic   [XLEN-1:0]  lsu_o
);

    logic   [ 7:0]  r_byte;
    logic   [15:0]  r_half;

    always_comb begin : load_store_unit
        r_byte  = '0;
        r_half  = '0;
        lsu_o   = '0;
        case (funct3_i)
            L_B:        lsu_o = {{24{mem_data_i[7]}}, mem_data_i[7:0]};
            L_H:        lsu_o = {{16{mem_data_i[15]}}, mem_data_i[15:0]};
            L_W:        lsu_o = mem_data_i;
            L_BU:       lsu_o = {{24'b0}, mem_data_i[7:0]};
            L_HU:       lsu_o = {{16'b0}, mem_data_i[15:0]};
            default:    lsu_o = '0;
        endcase
    end

endmodule
