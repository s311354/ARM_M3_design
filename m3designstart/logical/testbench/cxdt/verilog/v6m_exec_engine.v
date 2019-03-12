//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//            (C) COPYRIGHT 2013-2016 ARM Limited or its affiliates.
//                ALL RIGHTS RESERVED
//
// This entire notice must be reproduced on all copies of this file
// and copies of this file may only be made by a person if such person is
// permitted to do so under the terms of a subsisting license agreement
// from ARM Limited or its affiliates.
//
//   Release Information : TM840-MN-22010-r0p0-00rel0
//
//-----------------------------------------------------------------------------
// Verilog-2001 (IEEE Std 1364-2001)
//-----------------------------------------------------------------------------

//-----------------------------------------------------------------------------
// ARMv6-M EXECUTION ENGINE
//-----------------------------------------------------------------------------

// Define this if a tarmac trace is required:
// `define V6M_EXEC_TARMAC 1

// ----------------------------------------------------------------------------
// Engine private static state
// ----------------------------------------------------------------------------

event      v6m_event, v6m_interrupt;                 // WFE/WFI events
reg        v6m_initialized = 1'b0;                   // Initialization flag
reg [31:0] v6m_out [0:(2**v6m_log2_output_words)-1]; // Output buffer array
reg [31:0] v6m_mem [0:(2**v6m_log2_memory_words)-1]; // Shared memory and code

`ifdef V6M_EXEC_TARMAC
integer v6m_tarmac; // File handle for tarmac output
`include "v6m_exec_ualdis.v"
`endif


// ----------------------------------------------------------------------------
// Semihosting specific constants
// ----------------------------------------------------------------------------

localparam v6m_exec_path_max=1024;

// ----------------------------------------------------------------------------
// Propagate engine view of outputs to simulation view using non-blocking
// assignment on a per-32-bit vector basis:
// ----------------------------------------------------------------------------

genvar v6m_i;
generate
   for(v6m_i = 0; v6m_i < (2**v6m_log2_output_words); v6m_i = v6m_i + 1)
     begin : v6m_exec_nba
        always @(v6m_out[v6m_i])
          v6m_outputs[v6m_i] <= v6m_out[v6m_i];
     end
endgenerate

// ----------------------------------------------------------------------------
// Task for loading binary into memory and running initial task from first
// vector:
// ----------------------------------------------------------------------------

task v6m_load_binary(input [256*8-1:0] filename);
   integer fd, i;
   reg [31:0] data;

`ifdef V6M_EXEC_TARMAC
   reg [512*8-1:0] tarmacname;
`endif

   begin

`ifdef V6M_EXEC_TARMAC
      $swrite(tarmacname,"tarmac.%m.log");
      v6m_tarmac = $fopen(tarmacname,"w");
      if(!v6m_tarmac) begin
         $write("%m.v6m_load_binary(%0s).tarmac_init_failed(%0s)\n",
                filename, tarmacname);
         $finish(2);
      end

      $fwrite(v6m_tarmac,"# V6MEXEC TARMAC %0s\n",filename);
      $fwrite(v6m_tarmac,"# %m\n");
`endif

      fd = $fopen(filename,"rb");

      if(!fd) begin
         $write("%m.v6m_load_binary(%0s).file_not_found\n",filename);
         $finish(2);
      end

      for(i = 0;
          (i < (2**v6m_log2_memory_words)) && ($fread(data,fd) != -1);
          i = i + 1)
        begin
           v6m_mem[i] = {data[7:0],data[15:8],data[23:16],data[31:24]};
        end

      if(v6m_verbose)
        $write("%m.v6m_load_binary(%0s) = %0d\n",filename,i);

      v6m_exec_vector(1);
      v6m_initialized <= 1'b1;
   end
endtask

// ----------------------------------------------------------------------------
// Annotate memory reads and writes if tarmac tracing is requested
// ----------------------------------------------------------------------------

`ifdef V6M_EXEC_TARMAC
function [31:0] f_v6m_trace_r32(input integer vec, input integer cyc, input [31:0] addr, input [31:0] data);
   begin
      $fwrite(v6m_tarmac,"%t.%0d.%x MR4D %x %x\n",$time,vec,cyc,addr[31:0],data[31:0]);
      f_v6m_trace_r32 = data;
   end
endfunction

function [15:0] f_v6m_trace_r16(input integer vec, input integer cyc, input [31:0] addr, input [15:0] data);
   begin
      $fwrite(v6m_tarmac,"%t.%0d,%x MR2D %x %x\n",$time,vec, cyc,addr[31:0],data[15:0]);
      f_v6m_trace_r16 = data;
   end
endfunction

function [7:0] f_v6m_trace_r8(input integer vec, input integer cyc, input [31:0] addr, input [7:0] data);
   begin
      $fwrite(v6m_tarmac,"%t.%0d.%x MR1D %x %x\n",$time,vec,cyc,addr[31:0],data[7:0]);
      f_v6m_trace_r8 = data;
   end
endfunction

task f_v6m_trace_w32(input integer vec, input integer cyc, input [31:0] addr, input [31:0] data);
   $fwrite(v6m_tarmac,"%t.%0d.%x MW4D %x %x\n",$time,vec,cyc,addr[31:0],data[31:0]);
endtask

task f_v6m_trace_w16(input integer vec, input integer cyc, input [31:0] addr, input [15:0] data);
   $fwrite(v6m_tarmac,"%t.%0d,%x MW2D %x %x\n",$time,vec, cyc,addr[31:0],data[15:0]);
endtask

task f_v6m_trace_w8(input integer vec, input integer cyc, input [31:0] addr, input [7:0] data);
   $fwrite(v6m_tarmac,"%t.%0d.%x MW1D %x %x\n",$time,vec,cyc,addr[31:0],data[7:0]);
endtask

 `define V6M_EXEC_R32(vec, cyc, addr, data) f_v6m_trace_r32(vec, cyc, addr, data)
 `define V6M_EXEC_R16(vec, cyc, addr, data) f_v6m_trace_r16(vec, cyc, addr, data)
 `define V6M_EXEC_R8(vec, cyc, addr, data) f_v6m_trace_r8(vec, cyc, addr, data)
 `define V6M_EXEC_W32(vec, cyc, addr, data) f_v6m_trace_w32(vec, cyc, addr, data)
 `define V6M_EXEC_W16(vec, cyc, addr, data) f_v6m_trace_w16(vec, cyc, addr, data[15:0])
 `define V6M_EXEC_W8(vec, cyc, addr, data) f_v6m_trace_w8(vec, cyc, addr, data[7:0])
`else
 `define V6M_EXEC_R32(vec, cyc, addr, data) data
 `define V6M_EXEC_R16(vec, cyc, addr, data) data
 `define V6M_EXEC_R8(vec, cyc, addr, data) data
 `define V6M_EXEC_W32(vec, cyc, addr, data) data = data
 `define V6M_EXEC_W16(vec, cyc, addr, data) data = data
 `define V6M_EXEC_W8(vec, cyc, addr, data) data = data
`endif

// ----------------------------------------------------------------------------
// Macros for returning memory/IO data based upon the current value of "addr":
// ----------------------------------------------------------------------------

`define V6M_EXEC_GET_WORD `V6M_EXEC_R32(vector, cyc, addr, addr[30] ? (addr[31] ? v6m_inputs[addr[v6m_log2_input_words+1:2]] : v6m_out[addr[v6m_log2_output_words+1:2]]) : (addr[31] ? s[addr[v6m_log2_stack_words+1:2]] : v6m_mem[addr[v6m_log2_memory_words+1:2]] ))

`define V6M_EXEC_GET_HALF `V6M_EXEC_R16(vector, cyc, addr, addr[30] ? (addr[31] ? v6m_inputs[addr[v6m_log2_input_words+1:2]][16*addr[1]+:16] : v6m_out[addr[v6m_log2_output_words+1:2]][16*addr[1]+:16]) : (addr[31] ? s[addr[v6m_log2_stack_words+1:2]][16*addr[1]+:16] : v6m_mem[addr[v6m_log2_memory_words+1:2]][16*addr[1]+:16] ))

`define V6M_EXEC_GET_BYTE `V6M_EXEC_R8(vector, cyc, addr, addr[30] ? (addr[31] ? v6m_inputs[addr[v6m_log2_input_words+1:2]][8*addr[1:0]+:8] : v6m_out[addr[v6m_log2_output_words+1:2]][8*addr[1:0]+:8]) : (addr[31] ? s[addr[v6m_log2_stack_words+1:2]][8*addr[1:0]+:8] : v6m_mem[addr[v6m_log2_memory_words+1:2]][8*addr[1:0]+:8] ))

// ----------------------------------------------------------------------------
// Macros for updating memory/IO based upon the values of "addr" and "data":
// ----------------------------------------------------------------------------

`define V6M_EXEC_SET_WORD case(addr[31:30]) 2'b00 : v6m_mem[addr[v6m_log2_memory_words+1:2]] = data; 2'b01 : v6m_out[addr[v6m_log2_output_words+1:2]] = data; 2'b11 : begin $write("%t : %m(%0d).input_write\n",$time,vector); $finish(2); end 2'b10 : s[addr[v6m_log2_stack_words+1:2]] = data; endcase `V6M_EXEC_W32(vector, cyc, addr, data)

`define V6M_EXEC_SET_HALF case(addr[31:30]) 2'b00 : v6m_mem[addr[v6m_log2_memory_words+1:2]][16*addr[1]+:16] = data[15:0]; 2'b01 : v6m_out[addr[v6m_log2_output_words+1:2]][16*addr[1]+:16] = data[15:0]; 2'b11 : begin $write("%t : %m(%0d).input_write\n",$time,vector); $finish(2); end 2'b10 : s[addr[v6m_log2_stack_words+1:2]][16*addr[1]+:16] = data[15:0]; endcase `V6M_EXEC_W16(vector, cyc, addr, data)

`define V6M_EXEC_SET_BYTE case(addr[31:30]) 2'b00 : v6m_mem[addr[v6m_log2_memory_words+1:2]][8*addr[1:0]+:8] = data[7:0]; 2'b01 : v6m_out[addr[v6m_log2_output_words+1:2]][8*addr[1:0]+:8] = data[7:0]; 2'b11 : begin $write("%t : %m(%0d).input_write\n",$time,vector); $finish(2); end 2'b10 : s[addr[v6m_log2_stack_words+1:2]][8*addr[1:0]+:8] = data[7:0]; endcase `V6M_EXEC_W8(vector, cyc, addr, data)

// ----------------------------------------------------------------------------
// Execution engine task with private stack and register state:
// ----------------------------------------------------------------------------

task automatic v6m_exec_vector (input integer vector);
   reg [31:0] s [0:(1<<v6m_log2_stack_words)-1];  // Private stack space
   reg [15:0] op;       // Current ARMv6-M opcode
   reg [32:0] t33;      // Temporary 33-bit value
   reg [31:0] t32;      // Temporary 32-bit value
   reg [15:0] t16;      // Temporary 16-bit value
   reg [ 7:0] t8;       // Temporary 8-bit value
   reg [31:0] r [0:15]; // 16x 32-bit register file
   reg        v;        // Overflow V-flag
   reg        c;        // Carry C-flag
   reg [31:0] nz;       // Combined unprocessed Negative and Zero flag data
   reg        active;   // Active bit for this vector handler
   reg [31:0] addr;     // 32-bit address used by GET/SET_BYTE/HALF/WORD macros
   reg [31:0] data;     // 32-bit data used by SET_BYTE/HALF/WORD macros
   integer    i;        // Private loop iterator variable
   integer    cyc;      // Private cycle count
   reg [8*v6m_exec_path_max-1:0] str; // String for semihosting

`ifdef V6M_EXEC_TARMAC
   reg [31:0] rlast[0:14]; // Previous register file values
   reg        vlast;       // Previous V-flag
   reg        clast;       // Previous C-flag
   reg [31:0] nzlast;      // Previous NZ-flags
`endif

   begin

      // ----------------------------------------------------------------------
      // Signal WFI advance for all other processes:
      // ----------------------------------------------------------------------

      -> v6m_interrupt;

      // ----------------------------------------------------------------------
      // Determine initial PC from requested vector:
      // ----------------------------------------------------------------------

      r[15] = {v6m_mem[vector][31:1],1'b0};

      if(v6m_verbose)
        $write("%t : %m(%0d).run\n",$time,vector);

      // ----------------------------------------------------------------------
      // Vector 1 is the reset / main code vector
      // ----------------------------------------------------------------------

      if(vector == 1) begin
         r[14]      = 32'hFFFFFFFF;
         r[13]      = (32'h1 << v6m_log2_memory_words) << 2;
         v6m_mem[0] = (32'h1 << v6m_log2_memory_words) << 2;
         active     = 1;
         if(v6m_verbose)
           $write("%t : %m(%0d).initializing\n",$time,vector);
      end else begin
         r[14]     = 32'hFFFFFFFF;
         r[13]     = (32'h1 << v6m_log2_stack_words) << 2;
         r[13][31] = 1'b1;
         active    = v6m_initialized;
      end

      // ----------------------------------------------------------------------
      // Postpone execution if main thread hasn't started and this isn't main
      // ----------------------------------------------------------------------

      if(v6m_verbose & !active)
        $write("%t : %m(%0d).skipped_not_active\n",$time,vector);

      // ----------------------------------------------------------------------
      // Reset cycle count and execute all code associated with this vector
      // ----------------------------------------------------------------------

      cyc = 0;

`ifdef V6M_EXEC_TARMAC
      $fwrite(v6m_tarmac,"%t.%0d.%x E EXEC_START %x %x\n",$time,vector,cyc,vector,active);
`endif

      while(active) begin

         // -------------------------------------------------------------------
         // Extract opcode from memory and increment program and cycle counters
         // -------------------------------------------------------------------

         op = v6m_mem[r[15][31:2]][16*r[15][1]+:16];

`ifdef V6M_EXEC_TARMAC

         for(i=0;i<15;i=i+1) if(rlast[i] !== r[i]) begin
            rlast[i] = r[i];
            $fwrite(v6m_tarmac,"%t.%0d.%x R r%0d %x\n",
                    $time,vector,cyc,i,r[i]);
         end

         if((v !== vlast) || (c !== clast) || (nz !== nzlast)) begin

            if((nz === nzlast) || (nz[31] !== nzlast[31]) || (|nz !== |nzlast))
              $fwrite(v6m_tarmac,"%t.%0d.%x R PSR %x\n",
                    $time,vector,cyc, { nz[31], ~|nz, c, v, 28'b0 } );

            vlast = v;
            clast = c;
            nzlast = nz;
         end

`endif

         cyc = cyc + 1;

`ifdef V6M_EXEC_TARMAC

         if((op[15:12] == 4'b1101) && (op[11:9] != 3'b111)) begin
            t8 = "S";
            case(op[11:8])
              4'b0000 : if(!nz)                  t8 = "T";
              4'b0001 : if(nz)                   t8 = "T";
              4'b0010 : if(c)                    t8 = "T";
              4'b0011 : if(!c)                   t8 = "T";
              4'b0100 : if(nz[31])               t8 = "T";
              4'b0101 : if(!nz[31])              t8 = "T";
              4'b0110 : if(v)                    t8 = "T";
              4'b0111 : if(!v)                   t8 = "T";
              4'b1000 : if(c && nz)              t8 = "T";
              4'b1001 : if(!c || !nz)            t8 = "T";
              4'b1010 : if(nz[31] == v)          t8 = "T";
              4'b1011 : if(nz[31] != v)          t8 = "T";
              4'b1100 : if(nz && (nz[31] == v))  t8 = "T";
              4'b1101 : if(!nz || (nz[31] != v)) t8 = "T";
              default : t8 = "?";
            endcase
            $fwrite(v6m_tarmac,"%t.%0d.%x I%c %x     %x %0s\n",
                   $time,vector,cyc,t8,r[15],op,ual_dec_t16(op,r[15]));
         end else if(op[15:11] != 5'b11110)
           $fwrite(v6m_tarmac,"%t.%0d.%x IT %x     %x %0s\n",
                   $time,vector,cyc,r[15],op,ual_dec_t16(op,r[15]));
         else begin
            t32 = r[15] + 2;
            t16 = v6m_mem[t32[31:2]][16*t32[1]+:16];
            $fwrite(v6m_tarmac,"%t.%0d.%x IT %x %x %0s\n",
                    $time,vector,cyc,r[15],{op,t16},ual_dec_t32({op,t16},r[15]));
         end
`endif

         r[15] = r[15] + 2'd2;

         // -------------------------------------------------------------------
         // Decode opcode and perform associated execution behaviour
         // -------------------------------------------------------------------

         casez(op)
           // ----------------------------------------------------------- ADC
           16'b0100000101?????? : begin : ADC
              t33 = r[op[2:0]] + r[op[5:3]] + c;
              v = (r[op[2:0]][31] == r[op[5:3]][31]) &&
                  (r[op[2:0]][31] != t33[31]);
              {c,nz} = t33; r[op[2:0]] = t33[31:0];
           end
           // ---------------------------------------------------------- ADD1
           16'b0001110????????? : begin : ADD1
              t33 = r[op[5:3]] + op[8:6];
              v = ~r[op[5:3]][31] & t33[31];
              {c,nz} = t33; r[op[2:0]] = t33[31:0];
           end
           // ---------------------------------------------------------- ADD2
           16'b00110??????????? : begin : ADD2
              t33 = r[op[10:8]] + op[7:0];
              v = ~r[op[10:8]][31] & t33[31];
              {c,nz} = t33; r[op[10:8]] = t33[31:0];
           end
           // ---------------------------------------------------------- ADD3
           16'b0001100????????? : begin : ADD3
              t33 = r[op[5:3]] + r[op[8:6]];
              v = (r[op[5:3]][31] == r[op[8:6]][31]) &&
                  (r[op[5:3]][31] != t33[31]);
              {c,nz} = t33; r[op[2:0]] = t33[31:0];
           end
           // ---------------------------------------------------------- ADD4
           16'b01000100???????? : begin : ADD4
              r[{op[7],op[2:0]}] = r[op[6:3]] + r[{op[7],op[2:0]}] +
                                   {op[6:3] == 4'hF, 1'b0} +
                                   {{op[7],op[2:0]} == 4'hF, 1'b0};
              r[15][0] = 1'b0;
              r[13][1:0] = 2'b0;
           end
           // ---------------------------------------------------------- ADD5
           16'b10100??????????? : begin : ADD5
              t32 = r[15] + 2'd2;
              r[op[10:8]] = {t32[31:2],2'b0} + {op[7:0],2'b0};
           end
           // ---------------------------------------------------------- ADD6
           16'b10101??????????? : begin : ADD6
              r[op[10:8]] = r[13] + {op[7:0],2'b0};
           end
           // ---------------------------------------------------------- ADD7
           16'b101100000??????? : begin : ADD7
              r[13] = r[13] + {op[6:0],2'b0};
           end
           // ----------------------------------------------------------- AND
           16'b0100000000?????? : begin : AND
              t32 = r[op[5:3]] & r[op[2:0]]; r[op[2:0]] = t32; nz = t32;
           end
           // ---------------------------------------------------------- ASR1
           16'b00010??????????? : begin : ASR1
              t33 = $signed({r[op[5:3]],c}) >>> (op[10:6] ? op[10:6] : 32);
              {nz,c} = t33; r[op[2:0]] = t33[32:1];
           end
           // ---------------------------------------------------------- ASR2
           16'b0100000100?????? : begin : ASR2
              t33 = $signed({r[op[2:0]],c}) >>> r[op[5:3]][7:0];
              {nz,c} = t33; r[op[2:0]] = t33[32:1];
           end
           // ------------------------------------------------------------ B1
           16'b1101???????????? : begin : B1
              t32 = r[15] + 2'd2 + {{23{op[7]}}, op[7:0],1'b0};
              case(op[11:8])
                4'b0000 : if(!nz)                  r[15] = t32;
                4'b0001 : if(nz)                   r[15] = t32;
                4'b0010 : if(c)                    r[15] = t32;
                4'b0011 : if(!c)                   r[15] = t32;
                4'b0100 : if(nz[31])               r[15] = t32;
                4'b0101 : if(!nz[31])              r[15] = t32;
                4'b0110 : if(v)                    r[15] = t32;
                4'b0111 : if(!v)                   r[15] = t32;
                4'b1000 : if(c && nz)              r[15] = t32;
                4'b1001 : if(!c || !nz)            r[15] = t32;
                4'b1010 : if(nz[31] == v)          r[15] = t32;
                4'b1011 : if(nz[31] != v)          r[15] = t32;
                4'b1100 : if(nz && (nz[31] == v))  r[15] = t32;
                4'b1101 : if(!nz || (nz[31] != v)) r[15] = t32;
                // ------------------------------------------------------ UND
                4'b1110 : begin : UND
                   $write("%t : %m(%0d).undefined_opcode\n",$time,vector);
                   $finish(2);
                end
                // ------------------------------------------------------ SVC
                4'b1111 : begin : SVC
                   $write("%t : %m(%0d).taken %x\n",$time,vector,op[7:0]);

                   addr = r[13] - 4;
                   data = {nz[31],~|nz,c,v,28'b0};
                   `V6M_EXEC_SET_WORD;

                   addr = addr - 4; data = r[15]; `V6M_EXEC_SET_WORD;
                   addr = addr - 4; data = r[14]; `V6M_EXEC_SET_WORD;
                   addr = addr - 4; data = r[12]; `V6M_EXEC_SET_WORD;
                   addr = addr - 4; data = r[3]; `V6M_EXEC_SET_WORD;
                   addr = addr - 4; data = r[2]; `V6M_EXEC_SET_WORD;
                   addr = addr - 4; data = r[1]; `V6M_EXEC_SET_WORD;
                   addr = addr - 4; data = r[0]; `V6M_EXEC_SET_WORD;

                   r[13] = addr;
                   r[14] = 32'hFFFFFFF1;
                end
              endcase
           end
           // ------------------------------------------------------------ B2
           16'b11100??????????? : begin : B2
              r[15] = r[15] + 2'd2 + {{20{op[10]}},op[10:0],1'b0};
              if(op == 16'he7fe) begin : TOSELF
                 if(v6m_verbose)
                   $write("%t : %m(%0d).spin\n",$time,vector);
                 active = 1'b0;
              end
           end
           // ----------------------------------------------------------- BIC
           16'b0100001110?????? : begin : BIC
              t32 = ~r[op[5:3]] & r[op[2:0]]; r[op[2:0]] = t32; nz = t32;
           end
           // ---------------------------------------------------------- BKPT
           16'b10111110???????? : begin : BKPT
              if(v6m_verbose)
                $write("%t : %m(%0d).breaktpoint_%0x\n",$time,vector,op);
              // ---------------------------------------------- SEMIHOSTING
              if(op == 16'hBEAB) begin : SEMIHOST

                 if(v6m_verbose)
                   $write("%t : %m(%0d).semihost = 0x%0x\n",$time,vector,r[0]);

                 case(r[0])
                   // ---------------------------------------- SYS_OPEN
                   32'h01 : begin : SYS_OPEN
                      if(v6m_verbose)
                        $write("%t : %m(%0d).open = %0x\n",$time,vector,r[1]);

                      addr = r[1] + 8;
                      t32 = `V6M_EXEC_GET_WORD;
                      addr = r[1];
                      addr = `V6M_EXEC_GET_WORD;
                      str = {v6m_exec_path_max*8{1'b0}};

                      for(i=0;i<t32;i=i+1) begin
                         t8 = `V6M_EXEC_GET_BYTE;
                         str = {str[8*v6m_exec_path_max-9:0], t8};
                         addr = addr + 1;
                      end

                      addr = r[1] + 4;
                      t32 = `V6M_EXEC_GET_WORD;

                      if(str == ":tt") begin : CONSOLE
                         r[0] = 1;
                      end else begin : FILE

                         case(t32)
                           0 : t32 = $fopen(str,"r");
                           1 : t32 = $fopen(str,"rb");
                           2 : t32 = $fopen(str,"r+");
                           3 : t32 = $fopen(str,"r+b");
                           4 : t32 = $fopen(str,"w");
                           5 : t32 = $fopen(str,"wb");
                           6 : t32 = $fopen(str,"w+");
                           7 : t32 = $fopen(str,"w+b");
                           8 : t32 = $fopen(str,"a");
                           9 : t32 = $fopen(str,"ab");
                           10 : t32 = $fopen(str,"a+");
                           11 : t32 = $fopen(str,"a+b");
                           default: begin
                              $write("%t : %m(%0d).unsupported = %0d,%0s\n",
                                     $time,vector,t32,str);
                              $finish(2);
                           end
                         endcase
                         if(t32 == 0) r[0] = {32{1'b1}};
                         else r[0] = -t32;
                      end
                   end
                   // --------------------------------------- SYS_CLOSE
                   32'h02 : begin : SYS_CLOSE
                      addr = r[1];
                      t32 = `V6M_EXEC_GET_WORD;

                      if(t32 != 1) $fclose(-t32);

                      r[0] = 0;
                   end
                   // -------------------------------------- SYS_WRITEC
                   32'h03 : begin : SYS_WRITEC
                      $write("%c",r[1][7:0]);
                   end
                   // -------------------------------------- SYS_WRITE0
                   32'h04 : begin : SYS_WRITE0
                      addr = r[1];

                      t8 = `V6M_EXEC_GET_BYTE;

                      while(t8 != 8'b0) begin
                         $write("%c",t8);
                         addr = addr + 1;
                         t8 = `V6M_EXEC_GET_BYTE;
                      end
                   end
                   // --------------------------------------- SYS_WRITE
                   32'h05 : begin : SYS_WRITE
                      addr = r[1];
                      t32 = `V6M_EXEC_GET_WORD;

                      addr = r[1] + 8;
                      i    = `V6M_EXEC_GET_WORD;

                      addr = r[1] + 4;
                      addr = `V6M_EXEC_GET_WORD;

                      r[0] = 0;

                      for(i=i; i; i=i-1) begin
                         if(t32 == 1) $write("%c",`V6M_EXEC_GET_BYTE);
                         else $fwrite(-t32,"%c",`V6M_EXEC_GET_BYTE);
                         addr = addr + 1;
                      end
                   end
                   // --------------------------------------- SYS_READ
                   32'h06 : begin : SYS_READ
                      addr = r[1];
                      t32 = `V6M_EXEC_GET_WORD;

                      addr = r[1] + 8;
                      i    = `V6M_EXEC_GET_WORD;

                      addr = r[1] + 4;
                      addr = `V6M_EXEC_GET_WORD;

                      if(t32 == 1)
                         r[0] = i;
                      else begin

                        t16 = 16'b0;

                         for(i=i; i; i=i-1) begin
                            if($fread(t8,-t32)) begin
                               t16 = t16 + 1;
                               data = t8;
                               `V6M_EXEC_SET_BYTE;
                               addr = addr + 1;
                            end
                         end

                         if(t16 == 16'b0) begin
                            addr = r[1];
                            r[0] = `V6M_EXEC_GET_WORD;
                         end else
                           r[0] = t16;

                      end
                   end
                   // --------------------------------------- SYS_ISTTY
                   32'h09 : begin : SYS_ISTTY
                      addr = r[1];
                      t32 = `V6M_EXEC_GET_WORD;
                      if(t32 == 1) r[0] = 1;
                      else r[1] = 0;
                   end
                   // ---------------------------------------- SYS_SEEK
                   32'h0A : begin : SYS_SEEK
                      addr = r[1];
                      t32 = `V6M_EXEC_GET_WORD;
                      addr = r[1] + 4;
                      addr = `V6M_EXEC_GET_WORD;
                      r[0] = $fseek(-t32,addr,0);
                   end
                   // ---------------------------------------- SYS_FLEN
                   32'h0C : begin : SYS_FLEN
                      addr = r[1];
                      t32 = `V6M_EXEC_GET_WORD;
                      if(v6m_verbose)
                        $write("%t : %m(%0d).flen = 0x%02x\n",
                               $time,vector,-t32);
                      if(t32 == 1) r[0] = 0;
                      else begin
                         addr = $ftell(-t32);
                         r[0] = $fseek(-t32,0,2);
                         if(r[0] != {32{1'b1}}) r[0] = $ftell(-t32);
                         t32 = $fseek(-t32,addr,0);
                         if(t32 != 32'h0) r[0] = {32{1'b1}};
                      end
                   end
                   // ---------------------------------------- SYS_TIME
                   32'h11 : begin : SYS_TIME
                      r[0] = $time;
                   end
                   // --------------------------------------- SYS_ERRNO
                   32'h13 : begin : SYS_ERRNO
                      if(v6m_verbose)
                        $write("%t : %m(%0d).errno_accessed\n",
                               $time,vector);
                      r[0] = 32'h0;
                   end
                   // --------------------------------- SYS_GET_CMDLINE
                   32'h15 : begin : SYS_GET_CMDLINE
                      addr = r[1] + 4;
                      i = `V6M_EXEC_GET_WORD;
                      addr = r[1];
                      addr = `V6M_EXEC_GET_WORD;
                      $swrite(str,"%m");
                      str = str >> (8*46);
                      t8 = 8'b0;
                      while(!t8) {t8,str} = {str,8'b0};
                      for(i=i;i>0;i=i-1) begin
                         data = t8;
                         if(data) begin
                            `V6M_EXEC_SET_BYTE;
                            addr = addr + 1;
                         end
                         {t8,str} = {str,8'b0};
                      end
                      data = 32'b0;
                      `V6M_EXEC_SET_BYTE;
                      r[0] = 0;
                   end
                   // ------------------------------------ SYS_HEAPINFO
                   32'h16 : begin : SYS_HEAPINFO

                      addr = r[1];

                      addr = `V6M_EXEC_GET_WORD;
                      data = 32'h0;
                      `V6M_EXEC_SET_WORD;

                      addr = addr + 4;
                      data = (32'h1<<v6m_log2_memory_words)<<2;
                      `V6M_EXEC_SET_WORD;

                      addr     = addr + 4;
                      data     = (32'h1<<v6m_log2_stack_words)<<2;
                      data[31] = 1'b1;
                      `V6M_EXEC_SET_WORD;

                      addr = addr + 4;
                      data = 32'h80000000;
                      `V6M_EXEC_SET_WORD;
                   end
                   // ---------------------------------------- SYS_EXIT
                   32'h18 : begin : SYS_EXIT
                      $write("%t : %m(%0d)\n",$time,vector);
                      $finish(2);
                   end
                   // ------------------------------- SYS_UNIMPLEMENTED
                   default : begin
                      $write("%t : %m(%0d).bad_semihosting = 0x%02x\n",
                             $time,vector,r[0]);
                      $finish(2);
                   end
                 endcase
                 // ------------------------------------------------ HALT
              end else begin : HALT
                 $write("%t : %m(%0d).halt\n",$time,vector);
                 $finish(2);
              end
           end
           // ------------------------------------------------------------ BL
           16'b11110??????????? : begin : BL
              t16 = v6m_mem[r[15][31:2]][16*r[15][1]+:16];
              if({t16[15:14],t16[12]} == 3'b111) begin
                 r[14] = r[15] + 2'd3;
                 r[15] = r[15] + 2'd2 + { {8{op[10]}}, ~(t16[13] ^ op[10]),
                                          ~(t16[11] ^ op[10]), op[9:0],
                                          t16[10:0], 1'b0 };
              end else begin
                 r[15] = r[15] + 2'd2;
                 // ----------------------------------------------------- MRS
                 if((op[15:5] == 11'b11110_0_1111_1) &
                    ({t16[15:14],t16[12]} == 3'b10_0) ) begin : MRS
                    r[t16[11:8]] = {nz[31],~|nz,c,v,28'b0};
                 // ----------------------------------------------------- MSR
                 end else if((op[15:5] == 11'b11110_0_1110_0) &
                             ({t16[15:14],t16[12]} == 3'b10_0) ) begin : MSR
                    if(r[op[3:0]][31:30] == 2'b11)
                      $write("%t : %m(%0d).warning_APSR_NZ\n",$time,vector);

                    nz = {r[op[3:0]][31],30'b0,~r[op[3:0]][30]};
                    c = r[op[3:0]][29];
                    v = r[op[3:0]][28];
                 end
              end
           end
           // ----------------------------------------------------------- BLX
           16'b010001111??????? : begin : BLX
              r[14] = r[15] + 32'h00000001; r[15] = {r[op[6:3]][31:1],1'b0};
           end
           // ------------------------------------------------------------ BX
           16'b010001110??????? : begin : BX
              r[15] = r[op[6:3]];

              if(r[15][31:28] == 4'hF) begin
                 if(r[15][3:1] != 3'b000) begin
                    if(v6m_verbose)
                      $write("%t : %m(%0d).return_to_thread\n", $time, vector);
                    active = 1'b0;
                 end else begin
                    $write("%t : %m(%0d).bx_from_svc\n",$time,vector);

                    addr = r[13];    r[0] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[1] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[2] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[3] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[12] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[14] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[15] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; t32 = `V6M_EXEC_GET_WORD;

                    r[13] = addr + 4;

                    {nz[31], nz[30:0], c, v}
                      = { t32[31], 30'b0, ~t32[0], t32[29:28] };

                 end
              end
              r[15][0] = 1'b0;
           end
           // ----------------------------------------------------------- CMN
           16'b0100001011?????? : begin : CMN
              t33 = r[op[2:0]] + r[op[5:3]]; {c,nz} = t33;
              v = (r[op[2:0]][31] == r[op[5:3]][31]) &&
                  (r[op[2:0]][31] != t33[31]);
           end
           // ---------------------------------------------------------- CMP1
           16'b00101??????????? : begin : CMP1
              t33 = r[op[10:8]] - op[7:0]; c = ~t33[32]; nz = t33[31:0];
              v = r[op[10:8]][31] & ~t33[31];
           end
           // ---------------------------------------------------------- CMP2
           16'b0100001010?????? : begin : CMP2
              t33 = r[op[2:0]] - r[op[5:3]]; c = ~t33[32]; nz = t33[31:0];
              v = (r[op[2:0]][31] == ~r[op[5:3]][31]) &&
                  (r[op[2:0]][31] != t33[31]);
           end
           // ---------------------------------------------------------- CMP3
           16'b01000101???????? : begin : CMP3
              t33 = r[{op[7],op[2:0]}] - r[op[6:3]]; c = ~t33[32];
              nz = t33[31:0];
              v = (r[{op[7],op[2:0]}][31] == ~r[op[6:3]][31]) &&
                  (r[{op[7],op[2:0]}][31] != t33[31]);
           end
           // ----------------------------------------------------------- EOR
           16'b0100000001?????? : begin : EOR
              t32 = r[op[5:3]] ^ r[op[2:0]]; r[op[2:0]] = t32; nz = t32;
           end
           // ----------------------------------------------------------- LDM
           16'b11001??????????? : begin : LDM
              addr = r[op[10:8]];
              for(i=0;i<8;i=i+1) if(op[i]) begin
                 r[i] = `V6M_EXEC_GET_WORD;
                 addr = addr + 4;
              end
              if(~op[op[10:8]]) r[op[10:8]] = addr;
           end
           // ---------------------------------------------------------- LDR1
           16'b01101??????????? : begin : LDR1
              addr = r[op[5:3]] + {op[10:6],2'b0};
              r[op[2:0]] = `V6M_EXEC_GET_WORD;
           end
           // ---------------------------------------------------------- LDR2
           16'b0101100????????? : begin : LDR2
              addr = r[op[8:6]] + r[op[5:3]];
              r[op[2:0]] = `V6M_EXEC_GET_WORD;
           end
           // ---------------------------------------------------------- LDR3
           16'b01001??????????? : begin : LDR3
              t32 = r[15] + 2'd2;
              addr = {t32[31:2],2'b0} + {op[7:0],2'b0};
              r[op[10:8]] = `V6M_EXEC_GET_WORD;
           end
           // ---------------------------------------------------------- LDR4
           16'b10011??????????? : begin : LDR4
              addr = r[13] + {op[7:0],2'b0};
              r[op[10:8]] = `V6M_EXEC_GET_WORD;
           end
           // --------------------------------------------------------- LDRB1
           16'b01111??????????? : begin : LDRB1
              addr = r[op[5:3]] + op[10:6];
              t8 = `V6M_EXEC_GET_BYTE;
              r[op[2:0]] = {24'b0, t8};
           end
           // --------------------------------------------------------- LDRB2
           16'b0101110????????? : begin : LDRB2
              addr = r[op[5:3]] + r[op[8:6]];
              t8 = `V6M_EXEC_GET_BYTE;
              r[op[2:0]] = {24'b0, t8};
           end
           // --------------------------------------------------------- LDRH1
           16'b10001??????????? : begin : LDRH1
              addr = r[op[5:3]] + {op[10:6], 1'b0};
              t16 = `V6M_EXEC_GET_HALF;
              r[op[2:0]] = {16'b0, t16};
           end
           // --------------------------------------------------------- LDRH2
           16'b0101101????????? : begin : LDRH2
              addr = r[op[5:3]] + r[op[8:6]];
              t16 = `V6M_EXEC_GET_HALF;
              r[op[2:0]] = {16'b0, t16};
           end
           // --------------------------------------------------------- LDRSB
           16'b0101011????????? : begin : LDRSB
              addr = r[op[5:3]] + r[op[8:6]];
              t8 = `V6M_EXEC_GET_BYTE;
              r[op[2:0]] = {{24{t8[7]}}, t8};
           end
           // --------------------------------------------------------- LDRSH
           16'b0101111????????? : begin : LDRSH
              addr = r[op[5:3]] + r[op[8:6]];
              t16 = `V6M_EXEC_GET_HALF;
              r[op[2:0]] = {{16{t16[15]}}, t16};
           end
           // ---------------------------------------------------------- LSL1
           16'b00000??????????? : begin : LSL1
              t33 = {c,r[op[5:3]]} << op[10:6];
              r[op[2:0]] = t33[31:0]; {c,nz} = t33;
           end
           // ---------------------------------------------------------- LSL2
           16'b0100000010?????? : begin : LSL2
              t33 = {c,r[op[2:0]]} << r[op[5:3]][7:0];
              r[op[2:0]] = t33[31:0]; {c,nz} = t33;
           end
           // ---------------------------------------------------------- LSR1
           16'b00001??????????? : begin : LSR1
              t33 = {r[op[5:3]],c} >> (op[10:6] ? op[10:6] : 32);
              {nz,c} = t33; r[op[2:0]] = t33[32:1];
           end
           // ---------------------------------------------------------- LSR2
           16'b0100000011?????? : begin : LSR2
              t33 = {r[op[2:0]],c} >> r[op[5:3]][7:0];
              {nz,c} = t33; r[op[2:0]] = t33[32:1];
           end
           // ---------------------------------------------------------- MOV1
           16'b00100??????????? : begin : MOV1
              t32 = {24'b0,op[7:0]}; r[op[10:8]] = t32; nz = t32;
           end
           // ----------------------------------------------------------- CPY
           16'b01000110???????? : begin : CPY
              r[{op[7],op[2:0]}] = r[op[6:3]] + {op[6:3] == 4'hF, 1'b0};
              r[15][0] = 1'b0;
              r[13][1:0] = 2'b0;
           end
           // ----------------------------------------------------------- MUL
           16'b0100001101?????? : begin : MUL
              t32 = r[op[2:0]] * r[op[5:3]]; r[op[2:0]] = t32; nz = t32;
           end
           // ----------------------------------------------------------- MVN
           16'b0100001111?????? : begin : MVN
              t32 = ~r[op[5:3]]; r[op[2:0]] = t32; nz = t32;
           end
           // ----------------------------------------------------------- NEG
           16'b0100001001?????? : begin : NEG
              t33 = -r[op[5:3]]; c = ~t33[32]; nz = t33[31:0];
              v = r[op[5:3]][31] && t33[31];
              r[op[2:0]] = t33[31:0];
           end
           // ----------------------------------------------------------- ORR
           16'b0100001100?????? : begin : ORR
              t32 = r[op[5:3]] | r[op[2:0]]; r[op[2:0]] = t32; nz = t32;
           end
           // ----------------------------------------------------------- POP
           16'b1011110????????? : begin : POP
              addr = r[13];
              for(i=0;i<8;i=i+1) if(op[i]) begin
                 r[i] = `V6M_EXEC_GET_WORD;
                 addr = addr + 4;
              end
              if(op[8]) begin
                 r[15] = `V6M_EXEC_GET_WORD;
                 addr = addr + 4;
              end
              r[13] = addr;

              if(op[8] && (r[15][31:28] == 4'hF)) begin
                 if(r[15][3:1] != 3'b000) begin
                    if(v6m_verbose)
                      $write("%t : %m(%0d).pop_complete\n", $time,vector);
                    active = 1'b0;
                 end else begin
                    $write("%t : %m(%0d).pop_from_svc\n",$time,vector);

                    addr = r[13];    r[0] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[1] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[2] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[3] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[12] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[14] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; r[15] = `V6M_EXEC_GET_WORD;
                    addr = addr + 4; t32 = `V6M_EXEC_GET_WORD;

                    r[13] = addr + 4;

                    {nz[31], nz[30:0], c, v}
                      = { t32[31], 30'b0, ~t32[0], t32[29:28] };

                    r[13] = r[13] + (8*4);
                 end
              end
              r[15][0] = 1'b0;
           end
           // ---------------------------------------------------------- PUSH
           16'b1011010????????? : begin : PUSH
              addr = r[13];
              if(op[8]) begin
                 addr = addr - 4;
                 data = r[14];
                 `V6M_EXEC_SET_WORD;
              end
              for(i=7;i>=0;i=i-1) if(op[i]) begin
                 addr = addr - 4;
                 data = r[i];
                 `V6M_EXEC_SET_WORD;
              end
              r[13] = addr;
           end
           // ----------------------------------------------------------- REV
           16'b1011101000?????? : begin : REV
              t32 = r[op[5:3]];
              r[op[2:0]] = {t32[7:0],t32[15:8],t32[23:16],t32[31:24]};
            end
           // --------------------------------------------------------- REV16
            16'b1011101001?????? : begin : REV16
              t32 = r[op[5:3]];
              r[op[2:0]] = {t32[23:16],t32[31:24],t32[7:0],t32[15:8]};
            end
           // --------------------------------------------------------- REVSH
           16'b1011101011?????? : begin : REVSH
              t32 = r[op[5:3]];
              r[op[2:0]] = {{16{t32[7]}},t32[7:0],t32[15:8]};
            end
           // ----------------------------------------------------------- ROR
           16'b0100000111?????? : begin : ROR
              t32 = {2{r[op[2:0]]}} >> r[op[5:3]][4:0];
              c = r[op[5:3]][7:0] ? r[op[2:0]][(r[op[5:3]][4:0]+31)%32] : c;
              r[op[2:0]] = t32; nz = t32;
           end
           // ----------------------------------------------------------- SBC
           16'b0100000110?????? : begin : SBC
              t33 = r[op[2:0]] - r[op[5:3]] - !c;
              v = (r[op[2:0]][31] == ~r[op[5:3]][31]) &&
                  (r[op[2:0]][31] != t33[31]);
              c = ~t33[32]; nz = t33[31:0]; r[op[2:0]] = t33[31:0];
           end
           // ----------------------------------------------------------- STM
           16'b11000??????????? : begin : STM
              addr = r[op[10:8]];
              for(i=0;i<8;i=i+1) if(op[i]) begin
                 data = r[i];
                 `V6M_EXEC_SET_WORD;
                 addr = addr + 4;
              end
              r[op[10:8]] = addr;
            end
           // ---------------------------------------------------------- STR1
           16'b01100??????????? : begin : STR1
              addr = r[op[5:3]] + {op[10:6],2'b0};
              data = r[op[2:0]];
              `V6M_EXEC_SET_WORD;
            end
           // ---------------------------------------------------------- STR2
            16'b0101000????????? : begin : STR2
              addr = r[op[8:6]] + r[op[5:3]];
              data = r[op[2:0]];
              `V6M_EXEC_SET_WORD;
            end
           // ---------------------------------------------------------- STR3
            16'b10010??????????? : begin : STR3
              addr = r[13] + {op[7:0],2'b0};
              data = r[op[10:8]];
              `V6M_EXEC_SET_WORD;
            end
           // --------------------------------------------------------- STRB1
           16'b01110??????????? : begin : STRB1
              addr = r[op[5:3]] + op[10:6];
              data = r[op[2:0]];
              `V6M_EXEC_SET_BYTE;
           end
           // --------------------------------------------------------- STRB2
           16'b0101010????????? : begin : STRB2
              addr = r[op[5:3]] + r[op[8:6]];
              data = r[op[2:0]];
              `V6M_EXEC_SET_BYTE;
           end
           // --------------------------------------------------------- STRH1
           16'b10000??????????? : begin : STRH1
              addr = r[op[5:3]] + {op[10:6], 1'b0};
              data = r[op[2:0]];
              `V6M_EXEC_SET_HALF;
           end
           // --------------------------------------------------------- STRH2
           16'b0101001????????? : begin : STRH2
              addr = r[op[5:3]] + r[op[8:6]];
              data = r[op[2:0]];
              `V6M_EXEC_SET_HALF;
           end
           // ---------------------------------------------------------- SUB1
           16'b0001111????????? : begin : SUB1
              t33 = r[op[5:3]] - op[8:6];
              v = r[op[5:3]][31] & ~t33[31];
              c = ~t33[32]; nz = t33[31:0]; r[op[2:0]] = t33[31:0];
           end
           // ---------------------------------------------------------- SUB2
           16'b00111??????????? : begin : SUB2
              t33 = r[op[10:8]] - op[7:0];
              v = r[op[10:8]][31] & ~t33[31];
              c = ~t33[32]; nz = t33[31:0];  r[op[10:8]] = t33[31:0];
           end
           // ---------------------------------------------------------- SUB3
           16'b0001101????????? : begin : SUB3
              t33 = r[op[5:3]] - r[op[8:6]];
              v = (r[op[5:3]][31] == ~r[op[8:6]][31]) &&
                  (r[op[5:3]][31] != t33[31]);
              c = ~t33[32]; nz = t33[31:0]; r[op[2:0]] = t33[31:0];
           end
           // ---------------------------------------------------------- SUB4
           16'b101100001??????? : begin : SUB4
              r[13] = r[13] - {op[6:0],2'b0};
           end
           // ---------------------------------------------------------- SXTB
           16'b1011001001?????? : begin : SXTB
              t32 = r[op[5:3]]; r[op[2:0]] = {{24{t32[7]}},t32[7:0]};
           end
           // ---------------------------------------------------------- SXTH
           16'b1011001000?????? : begin : SXTH
              t32 = r[op[5:3]]; r[op[2:0]] = {{16{t32[15]}},t32[15:0]};
           end
           // ----------------------------------------------------------- TST
           16'b0100001000?????? : begin : TST
              t32 = r[op[5:3]] & r[op[2:0]]; nz = t32;
           end
           // ---------------------------------------------------------- UXTB
           16'b1011001011?????? : begin : UXTB
              r[op[2:0]] = {24'b0,r[op[5:3]][7:0]};
           end
           // ---------------------------------------------------------- UXTH
           16'b1011001010?????? : begin : UXTH
              r[op[2:0]] = {16'b0,r[op[5:3]][15:0]};
           end
           // ----------------------------------------------------------- SEV
           16'b1011111101000000 : begin : SEV
              if(v6m_verbose)
                $write("%t : %m(%0d).send_event\n",$time,vector);

`ifdef V6M_EXEC_TARMAC
              $fwrite(v6m_tarmac,"%t.%0d.%x E SENT_EVENT\n",$time,vector,cyc);
`endif

              -> v6m_event;
           end
           // ----------------------------------------------------------- WFE
           16'b1011111100100000 : begin : WFE
              if(v6m_verbose)
                $write("%t : %m(%0d).wait_for_event\n",$time,vector);

`ifdef V6M_EXEC_TARMAC
              $fwrite(v6m_tarmac,"%t.%0d.%x E WFE_SUSPEND\n",$time,vector,cyc);
`endif

              v6m_initialized <= 1'b1;
              @v6m_event;

`ifdef V6M_EXEC_TARMAC
              $fwrite(v6m_tarmac,"%t.%0d.%x E WFE_RESUME\n",$time,vector,cyc);
`endif

           end
           // ----------------------------------------------------------- WFI
           16'b1011111100110000 : begin : WFI
              if(v6m_verbose)
                $write("%t : %m(%0d).wait_for_interrupt = %0d\n",$time,vector,cyc);

`ifdef V6M_EXEC_TARMAC
              $fwrite(v6m_tarmac,"%t.%0d.%x E WFI_SUSPEND\n",$time,vector,cyc);
`endif

              v6m_initialized <= 1'b1;
              @v6m_interrupt;

`ifdef V6M_EXEC_TARMAC
              $fwrite(v6m_tarmac,"%t.%0d.%x E WFI_RESUME\n",$time,vector,cyc);
`endif

           end
           // ----------------------------------------------------------- NOP
           16'b1011111100000000 : begin : NOP end
           // --------------------------------------------------------- YIELD
           16'b1011111100010000 : begin : YIELD end
           // ------------------------------------------------ DECODE-FAILURE
           default: begin
              $write("%t : %m(%0d).internal_error = %0d:%0x:%0x\n",$time,vector,cyc,r[15],op);
              $finish(2);
           end
           // ---------------------------------------------------------------
         endcase // casez (op)

      end

      // ----------------------------------------------------------------------
      // Report cycles spent in handler if verbosity enabled
      // ----------------------------------------------------------------------

      if(v6m_verbose)
        $write("%t : %m(%0d).executed = %0d\n", $time,vector, cyc);

`ifdef V6M_EXEC_TARMAC
      $fwrite(v6m_tarmac,"%t.%0d.%x E EXEC_FINISH %x\n",$time,vector,cyc,vector);
`endif

   end
endtask

// ----------------------------------------------------------------------------
// Clear out defines
// ----------------------------------------------------------------------------

`undef V6M_EXEC_GET_WORD
`undef V6M_EXEC_GET_HALF
`undef V6M_EXEC_GET_BYTE
`undef V6M_EXEC_SET_WORD
`undef V6M_EXEC_SET_HALF
`undef V6M_EXEC_SET_BYTE

//-----------------------------------------------------------------------------
// EOF
//-----------------------------------------------------------------------------
