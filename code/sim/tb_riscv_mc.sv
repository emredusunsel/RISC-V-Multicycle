`timescale 1ns / 1ps

import riscv_pkg::*;

module tb_riscv_mc();

    logic   clk_i, rstn_i;

//-- TB SIGNALS --//
    logic   [  XLEN-1:0]    InstrCurrent;
    logic   [  XLEN-1:0]    InstrPast;
    logic   [  XLEN-1:0]    PastResult;
    logic   [  XLEN-1:0]    PC_current;
    logic   [  XLEN-1:0]    PC_past;
    logic   [XWIDTH-1:0]    reg_addr;
    logic   [  XLEN-1:0]    reg_data;
    logic   [  XLEN-1:0]    mem_addr;
    logic   [  XLEN-1:0]    mem_data;
    logic                   Print_Out;
    opcode_e                opcode;
    logic   [  XLEN-1:0]    l_mem_addr;
    logic   [  XLEN-1:0]    l_PastData;

    assign InstrCurrent = dut.w_Instr;
    assign InstrPast    = dut.w_InstrPast;
    assign PC_current   = dut.datapath.PC_w;
    assign PC_past      = dut.datapath.r_instr_rd1_w;
    assign reg_addr     = dut.w_InstrPast[11:7];
    assign reg_data     = PastResult;
    always_comb begin
        if (opcode == OP_L) begin
            mem_addr    = l_mem_addr;
        end else if (opcode == OP_S) begin
            mem_addr    = PastResult;
        end
    end
    always_comb begin : mem_data_signal
        if (opcode == OP_L) begin
            mem_data     = l_PastData;
        end else if (opcode == OP_S) begin
            mem_data    = dut.datapath.r_rfout_rd2_w;
        end
    end
    assign Print_Out    = (dut.control_unit.main_fsm.state == S_FETCH) ? 1 : 0;
    assign opcode       = dut.control_unit.w_oppast_i;

    reg_1 PPastResult(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .reg_i          (PastResult),
        .wr_en_i        (1'b1),
        .reg_o          (l_mem_addr)
    );

    reg_1 r_RESULT_PAST(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .reg_i          (dut.datapath.RESULT_m),
        .wr_en_i        (1'b1),
        .reg_o          (PastResult)
    );

    reg_1 r_DATA_PAST(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i),
        .reg_i          (dut.datapath.r_data_w),
        .wr_en_i        (1'b1),
        .reg_o          (l_PastData)
    );
//-- TB SINGALS END --//

    riscv_mc dut(
        .clk_i          (clk_i),
        .rstn_i         (rstn_i)
    );

    initial clk_i = 0;
    always #5 clk_i = ~clk_i;

    task automatic dump_registers;
        integer i;
        integer file_pointer;
        file_pointer    = $fopen("sim_log.txt", "w");

        for (i = 0; i < 200; i = i + 1) begin
            @(posedge clk_i);
            i = 0;
            if (Print_Out) begin
                case (opcode)
                    OP_L: begin
                        if (reg_addr == 0) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end else if (reg_addr > 9) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d 0x%8h mem 0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data,
                                    mem_addr);
                        end else begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d  0x%8h mem 0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data,
                                    mem_addr);
                        end
                    end

                    OP_S:begin
                        $fwrite(file_pointer, "0x%8h (0x%8h) mem 0x%8h 0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    mem_addr,
                                    mem_data);
                    end

                    OP_R: begin
                        if (reg_addr == 0) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end else if (reg_addr > 9) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d 0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end else begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d  0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end
                    end

                    OP_B: begin
                        if (reg_addr == 0) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end else if (reg_addr > 9) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end else begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end
                    end

                    OP_I: begin
                        if (reg_addr == 0) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end else if (reg_addr > 9) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d 0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end else begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d  0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end
                    end

                    OP_JALR: begin
                        if (reg_addr == 0) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end else if (reg_addr > 9) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d 0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end else begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d  0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end
                    end

                    OP_JAL: begin
                        if (reg_addr == 0) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end else if (reg_addr > 9) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d 0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end else begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d  0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end
                    end

                    OP_AUIPC: begin
                        if (reg_addr == 0) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end else if (reg_addr > 9) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d 0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end else begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d  0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end
                    end

                    OP_LUI: begin
                        if (reg_addr == 0) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h)\n",
                                    PC_past,
                                    InstrPast);
                        end else if (reg_addr > 9) begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d 0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end else begin
                            $fwrite(file_pointer, "0x%8h (0x%8h) x%0d  0x%8h\n",
                                    PC_past,
                                    InstrPast,
                                    reg_addr,
                                    reg_data);
                        end
                    end
                    default: ;
                endcase
            end
            if (InstrPast == '0) begin
                $finish;
            end
        end
    endtask

    initial begin
        rstn_i = 0;
        #20;
        rstn_i = 1;
        #20;
        dump_registers();
    end

endmodule
