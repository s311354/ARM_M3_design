// Testbench for CellularRAM

// DO NOT CHANGE THE TIMESCALE
// MAKE SURE YOUR SIMULATOR USE "PS" RESOLUTION
`timescale 1ns / 1ps

module tb;

`include "cellram_parameters.vh"

    parameter                   tDS = tDW;
    parameter                   WAIT_LIMIT = 1000;

    // ports
    reg                         clk;
    reg                         adv_n;
    reg                         cre;
    reg                         ce_n;
    reg                         oe_n;
    reg                         we_n;
    reg           [BY_BITS-1:0] by_n;
    reg                  [31:0] addr;
    wire                 [31:0] dq;
    wire          [DQ_BITS-1:0] dq_in = dq;

    // configuration registers
    reg           [DQ_BITS-1:0] bus_configuration_reg;
    reg           [DQ_BITS-1:0] refr_configuration_reg;
    wire                        waitp = bus_configuration_reg[10];
    wire                  [3:0] latency_counter     = (bus_configuration_reg[13:11] == 3'b000) ? 4'd8 : bus_configuration_reg[13:11];

    // dq transmit
    reg           [DQ_BITS-1:0] dq_out;
    assign                      dq = {{32-DQ_BITS{1'bz}}, dq_out};

    // dq receive
    reg           [BY_BITS-1:0] rd_dm;
    reg           [DQ_BITS-1:0] rd_dq;
    reg                         rd_comp;
    realtime                    tm_rd_comp;
    wire                        o_wait;
    wire                        i_wait = waitp ? o_wait : ~o_wait;

    // timing definition
    realtime                    tclk;
    realtime                    tclk_min;

    initial begin
        $timeformat (-9, 1, " ns", 1);
`ifdef period
        tclk = `period ;
`else
        tclk =  tCLK;
`endif
    end

    // component instantiation
    cellram uut (
        .clk    (clk),
        .adv_n  (adv_n),
        .cre    (cre),
        .o_wait (o_wait),
        .ce_n   (ce_n),
        .oe_n   (oe_n),
        .we_n   (we_n),
        .ub_n   (by_n[1]),
        .lb_n   (by_n[0]),
        .addr   (addr[ADDR_BITS-1:0]),
        .dq     (dq[DQ_BITS-1:0])
    );


    function integer ceil;
        input number;
        real number;
        if (number > $rtoi(number))
            ceil = $rtoi(number) + 1;
        else
            ceil = number;
    endfunction

    function integer max;
        input arg1;
        input arg2;
        integer arg1;
        integer arg2;
        if (arg1 > arg2)
            max = arg1;
        else
            max = arg2;
    endfunction

    task clk_pulse;
        input [31:0] count;
        integer i;
        begin
            for (i=0; i<count; i=i+1) begin
                clk <= #(i*tclk) 1'b0;
                clk <= #((i + 0.5)*tclk) 1'b1;
            end
        end
    endtask

    task set_config_reg_copy;
        input [1:0] regnum;
        input [DQ_BITS-1:0] regval;
        begin
            case (regnum)
                BCR : bus_configuration_reg = regval;
                RCR : refr_configuration_reg = regval;
            endcase
            tclk_min = min_clk_period(bus_configuration_reg[14], bus_configuration_reg[13:11]);
        end
    endtask

    task power_up;
        begin
            clk   = 1'b0;
            adv_n = 1'b1;
            cre   = 1'b0;
            ce_n  = 1'b1;
            oe_n  = 1'b1;
            we_n  = 1'b1;
            by_n  = {BY_BITS{1'b1}};
            dq_out= {DQ_BITS{1'bz}};
            addr= {32{1'bz}};
            #(tPU);
        end
    endtask

    task async_write;
        input wr_cre;
        input [ADDR_BITS-1:0] wr_addr;
        input [DQ_BITS-1:0] wr_data;
        input [BY_BITS-1:0] wr_byte;
        input wr_adv;
        begin
            clk    <= 1'b0;
            adv_n  <= 1'b0;
            cre    <= wr_cre;
            ce_n   <= 1'b0;
            oe_n   <= 1'b1;
            we_n   <= 1'b1;
            if (GENERATION == CR20) begin
                we_n   <= #(tVP - tAVS + tAS) 1'b0;
            end else begin
                we_n   <= #(tWC - tWP) 1'b0;
            end
            by_n     <= wr_byte;
            addr     <= wr_addr;
            dq_out   <= #(tCW - tDS) wr_data;
            dq_out   <= #(tCW + tDH) {DQ_BITS{1'bz}};
            if (wr_adv) begin
                if (tCVS > tAVS) begin
                    cre    <= #(tCVS + tAVH) 1'b0;
                    adv_n  <= #(tCVS) 1'b1;
                    addr   <= #(tCVS + tAVH) {32{1'bz}};
                end else begin
                    cre    <= #(tAVS + tAVH) 1'b0;
                    adv_n  <= #(tAVS) 1'b1;
                    addr   <= #(tAVS + tAVH) {32{1'bz}};
                end
            end
            #(tCW);

            // save copy of configuration register (snoop addr bit 31 on cellular RAM 2.0 parts)
            if (wr_cre || ((GENERATION == CR20) && wr_addr[ADDR_BITS-1])) begin
                set_config_reg_copy(wr_addr>>REG_SEL, wr_addr);
            end

        end
    endtask

    task async_read;
        input rd_cre;
        input [ADDR_BITS-1:0] rd_addr;
        input [DQ_BITS-1:0] rd_data;
        input [BY_BITS:0] rd_byte;
        input rd_adv;
        begin
            clk    <= 1'b0;
            adv_n  <= 1'b0;
            cre    <= 1'b0;
            cre    <= rd_cre;
            ce_n   <= 1'b0;
            oe_n   <= 1'b1;
            oe_n   <= #(tCO - tOE) 1'b0;
            we_n   <= 1'b1;
            if (GENERATION > CR10) begin
                by_n   <= {BY_BITS{1'b0}};
            end else begin
                by_n   <= rd_byte;
            end
            addr   <= rd_addr;
            if (rd_adv) begin
                if (tCVS > tAVS) begin
                    cre    <= #(tCVS + tAVH) 1'b0;
                    adv_n  <= #(tCVS) 1'b1;
                    addr   <= #(tCVS + tAVH) {32{1'bz}};
                end else begin
                    cre    <= #(tAVS + tAVH) 1'b0;
                    adv_n  <= #(tAVS) 1'b1;
                    addr   <= #(tAVS + tAVH) {32{1'bz}};
                end
            end
            #(tCO);
            rd_dm     <= rd_byte;
            rd_dq     <= rd_data;
            rd_comp   <= #(tSP) 1'b1;
            tm_rd_comp<= $realtime + tSP;
            //keep data valid for a short time
            #(tSP + tHD);
        end
    endtask

    // one address cycle of a page mode read
    task page_read;
        input [ADDR_BITS-1 : 0] next_addr;
        input [DQ_BITS-1:0] next_data;
        input [BY_BITS:0] next_byte;
        begin
            clk    <= 1'b0;
            adv_n  <= 1'b0;
            cre    <= 1'b0;
            cre    <= 1'b0;
            ce_n   <= 1'b0;
            oe_n   <= 1'b0;
            we_n   <= 1'b1;
            by_n   <= {BY_BITS{1'b0}};
            addr   <= next_addr;
            if (addr[ADDR_BITS-1:4] ^ next_addr[ADDR_BITS-1:4]) begin
                #tAA;
            end else begin
                #tPC;
            end
            rd_dm     <= next_byte;
            rd_dq     <= next_data;
            rd_comp   <= #(tSP) 1'b1;
            tm_rd_comp<= $realtime + tSP;
            //keep data valid for a short time
            #(tSP + tHD);
        end
    endtask

    // controls how commands are terminated
    task idle;
        input [2:0] ctrl;
        begin
            // wait until any scheduled read compares are complete before ending the cycle
            if (tm_rd_comp > $realtime) begin
                //keep data valid for a short time
                # (tm_rd_comp - $realtime + tHD);
            end
            case (ctrl)
                0: begin
                   ce_n  <= 1'b1;
                   we_n  <= 1'b1;
                   by_n  <= {BY_BITS{1'b1}};
                   oe_n  <= 1'b1;
                   adv_n <= 1'b1;
                end
                1: we_n  <= 1'b1;
                2: by_n  <= {BY_BITS{1'b1}};
                3: oe_n  <= 1'b1;
                4: adv_n <= 1'b1;
                5: ce_n  <= 1'b1;
            endcase
        end
    endtask

    task sync_write;
        input wr_cre;
        input [ADDR_BITS-1:0] wr_addr;
        input [DQ_BITS-1:0] wr_data;
        input [BY_BITS-1:0] wr_byte;
        integer i,w;
        begin
            clk_pulse(2);
            adv_n  <= #(0.5*tclk - tSP) 1'b0;
            adv_n  <= #(0.5*tclk + tHD) 1'b1;
            cre    <= 1'bx;
            cre    <= #(0.5*tclk - tSP) wr_cre;
            cre    <= #(0.5*tclk + tHD + tAVH) 1'bx;
            ce_n   <= #(0.5*tclk - tCSP) 1'b0;
            oe_n   <= 1'b1;
            we_n   <= #(tAS) 1'b0;
            we_n   <= #(0.5*tclk + tHD) 1'b1;
            addr   <= {32{1'bz}};
            addr   <= #(0.5*tclk - tSP) wr_addr;
            addr   <= #(0.5*tclk + tHD + tAVH) {32{1'bz}};
            #(1.5*tclk);
            i = 0;
            while ((i_wait !== 1'b0) && (i<WAIT_LIMIT)) begin
                #(0.5*tclk);
                // schedule first data word in burst in anticipation of WAIT going inactive
                dq_out <= #((0.5)*tclk - tSP) wr_data;
                dq_out <= #((0.5)*tclk + tHD) {DQ_BITS{1'bz}};
                by_n <= #((0.5)*tclk - tSP) wr_byte;
                by_n <= #((0.5)*tclk + tHD) {BY_BITS{1'b1}};
                clk_pulse(1);
                #(0.5*tclk);
                i = i + 1;
            end
            if (i == WAIT_LIMIT) begin
                $display ("ENDING TEST: Wait not seen for %d clocks", WAIT_LIMIT);
                $stop();
            end
            #(0.5*tclk);
            // wait one more tclk if WAIT=1
            if (bus_configuration_reg[8]) begin
                dq_out <= #((0.5)*tclk - tSP) wr_data;
                dq_out <= #((0.5)*tclk + tHD) {DQ_BITS{1'bz}};
                by_n <= #((0.5)*tclk - tSP) wr_byte;
                by_n <= #((0.5)*tclk + tHD) {BY_BITS{1'b1}};
                clk_pulse(1);
                #(tclk);
            end
            clk    <= 1'b0;

            // save copy of configuration register (snoop addr bit 31 on cellular RAM 2.0 parts)
            if (wr_cre || ((GENERATION == CR20) && wr_addr[ADDR_BITS-1])) begin
                set_config_reg_copy(wr_addr>>REG_SEL, wr_addr);
            end

        end
    endtask

    // one cycle of a sync write burst
    task sync_write_burst;
        input [DQ_BITS-1:0] next_data;
        input [BY_BITS:0] next_byte;
        begin
            clk_pulse(1);
            adv_n  <= 1'b1;
            cre    <= 1'bx;
            ce_n   <= 1'b0;
            oe_n   <= 1'b1;
            we_n   <= 1'b1;
            by_n   <= #(0.5*tclk - tSP) next_byte;
            by_n   <= #(0.5*tclk + tHD) {BY_BITS{1'b1}};
            dq_out <= #(0.5*tclk - tSP) next_data;
            dq_out <= #(0.5*tclk + tHD) {DQ_BITS{1'bz}};
            #(tclk);
            clk    <= 1'b0;
        end
    endtask

    task sync_read;
        input rd_cre;
        input [ADDR_BITS-1:0] rd_addr;
        input [DQ_BITS-1:0] rd_data;
        input [BY_BITS-1:0] rd_byte;
        integer i;
        begin
            ce_n   <= 1'b0;
            adv_n  <= 1'b0;
            if (GENERATION > CR10) begin
                by_n   <= {BY_BITS{1'b0}};
            end else begin
                by_n <= #((0.5)*tclk - tSP) rd_byte;
            end
            addr   <= rd_addr;
            if (tAADV > ((bus_configuration_reg[13:11])+ 1.5)*tclk) begin
                #(tAADV-((bus_configuration_reg[13:11])+ 1.5)*tclk);
            end
            clk_pulse(2);
            adv_n  <= #(0.5*tclk + tHD) 1'b1;
            cre    <= 1'bx;
            cre    <= #(0.5*tclk - tSP) rd_cre;
            cre    <= #(0.5*tclk + tHD + tAVH) 1'bx;
            oe_n   <= 1'b1;
            oe_n   <= #((0.5*tclk) + tABA - tOE) 1'b0;
            we_n   <= 1'b1;
            addr   <= #(0.5*tclk + tHD + tAVH) {32{1'bz}};
            #(1.5*tclk);
            i = 0;
            while (((bus_configuration_reg[14] == 0) && (i_wait !== 1'b0) && (i < WAIT_LIMIT)) // variable latency = monitor wait
                || (bus_configuration_reg[14] && (i < (latency_counter - 1)))) begin // fixed latency = use latency count from BCR
                #(0.5*tclk);
                clk_pulse(1);
                #(0.5*tclk);
                i = i + 1;
            end
            if (i == WAIT_LIMIT) begin
                $display ("ENDING TEST: Wait not seen for %d clocks", WAIT_LIMIT);
                $stop();
            end

            rd_dm     <= #(tclk*(bus_configuration_reg[8] || bus_configuration_reg[14])) rd_byte;
            rd_dq     <= #(tclk*(bus_configuration_reg[8] || bus_configuration_reg[14])) rd_data;
            rd_comp   <= #(tclk*(bus_configuration_reg[8] || bus_configuration_reg[14])) 1'b1;
            tm_rd_comp<= $realtime + tclk*(bus_configuration_reg[8] || bus_configuration_reg[14]);

            #(0.5*tclk);
            clk    <= 1'b0;
        end
    endtask

    // one cycle of a sync read burst
    task sync_read_burst;
        input [DQ_BITS-1:0] next_data;
        input [BY_BITS:0] next_byte;
        reg [DQ_BITS-1:0] bit_mask;
        begin
            if ((bus_configuration_reg[8] == 0) && (bus_configuration_reg[14] == 0) && (next_byte !== rd_dm)) begin
                $display ("%m at time %t: ERROR: Changing BY# during Sync Read is not supported with variable latency and wait configuration = 0", $time);
            end
            clk_pulse(1);
            adv_n  <= 1'b1;
            cre    <= 1'bx;
            ce_n   <= 1'b0;
            oe_n   <= 1'b0;
            we_n   <= 1'b1;
            if (GENERATION > CR10) begin
                by_n   <= {BY_BITS{1'b0}};
            end else begin
                by_n   <= #(0.5*tclk - tSP) next_byte;
            end
            #(0.5*tclk);
            rd_dm     <= #(tclk*(bus_configuration_reg[8] || bus_configuration_reg[14])) next_byte;
            rd_dq     <= #(tclk*(bus_configuration_reg[8] || bus_configuration_reg[14])) next_data;
            rd_comp   <= #(tclk*(bus_configuration_reg[8] || bus_configuration_reg[14])) 1'b1;
            tm_rd_comp<= $realtime + tclk*(bus_configuration_reg[8] || bus_configuration_reg[14]);
            #(0.5*tclk);
            clk    <= 1'b0;
        end
    endtask

    // nop, wait with clk low
    task nop;
        input wait_time;
        real wait_time;
        begin
            clk   <= 1'b0;
            #(wait_time);
        end
    endtask

    always @(posedge rd_comp) begin : data_verify
        integer i;
        reg [DQ_BITS-1:0] bit_mask;

        for (i=0; i<DQ_BITS; i=i+1) begin
            bit_mask[i] = !rd_dm[i/8];
        end

        // Verify the data word after output delay
        if (((dq_in & bit_mask) ^ (rd_dq & bit_mask)) !== {DQ_BITS{1'b0}}) begin
            $display ("%m at time %t: ERROR: Read data miscompare: Expected = %h, Actual = %h, Mask = %h", $time, rd_dq, dq_in, bit_mask);
        //end else begin
        //    $display ("%m at time %t: INFO: Successful Read data compare: Expected = %h, Actual = %h, Mask = %h", $time, rd_dq, dq_in, bit_mask);
        end
        rd_comp <= 1'b0;
    end

    // End-of-test triggered in 'subtest.vh'
    task test_done;
        begin
            $display ("%m at time %t: INFO: Simulation is Complete", $time);
            $stop(0);
        end
    endtask

    // Test included from external file
    `include "subtest.vh"

endmodule
