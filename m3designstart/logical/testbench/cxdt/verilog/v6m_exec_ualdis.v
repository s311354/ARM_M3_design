//-----------------------------------------------------------------------------
// The confidential and proprietary information contained in this file may
// only be used by a person authorised under and to the extent permitted
// by a subsisting licensing agreement from ARM Limited or its affiliates.
//
//            (C) COPYRIGHT 2006-2016 ARM Limited or its affiliates.
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

// ----------------------------------------------------------------------------
// ARMv6-M Verilog disassembler include file for Cortex-M0
// ----------------------------------------------------------------------------

// This file is intended to be included inside a module and provides the
// following public function interfaces:
//
//   function [ual_str_len:0] ual_dec_t32 (opcode[31:0],address[31:0])
//   function [ual_str_len:0] ual_dec_t16 (opcode[15:0],address[31:0])
//
// These functions disassemble a Thumb 32 or 16-bit opcode (respectively),
// from a given instruction address. Note that the address is only used for
// branch and literal load type operations in order to provide a more
// meaningful dis-assembly.

// ----------------------------------------------------------------------------
// Setup constants
// ----------------------------------------------------------------------------

// Set up defines for include files.

localparam ual_str_chars = 40;
localparam ual_str_len   = ((ual_str_chars*8)-1);
localparam ual_str_empty = {ual_str_len{1'b0}};
localparam ual_tab_stop  = 8;

// ----------------------------------------------------------------------------
// UAL disassembler helper function:
// Translates up-to a 32-bit value to a minimal hexadecimal string
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_fun_hex;

   input [ual_str_len:0] in;
   input [31:0]          num;

   reg [ual_str_len:0]   o;
   reg [31:0]            tmp;
   reg                   emit;
   integer               count;
   integer               i;

   begin

      o    = in;
      emit = 1'b0;
      tmp  = num;

      if(!num) o = { o, "0" };

      for(i=0; i<8; i=i+1)
        begin

           if(tmp[31:28] != 4'b0) emit = 1'b1;

           if(emit)
             case(tmp[31:28])
               4'h0    : o = { o, "0" };
               4'h1    : o = { o, "1" };
               4'h2    : o = { o, "2" };
               4'h3    : o = { o, "3" };
               4'h4    : o = { o, "4" };
               4'h5    : o = { o, "5" };
               4'h6    : o = { o, "6" };
               4'h7    : o = { o, "7" };
               4'h8    : o = { o, "8" };
               4'h9    : o = { o, "9" };
               4'hA    : o = { o, "a" };
               4'hB    : o = { o, "b" };
               4'hC    : o = { o, "c" };
               4'hD    : o = { o, "d" };
               4'hE    : o = { o, "e" };
               4'hF    : o = { o, "f" };
               default : o = { o, "?" };
             endcase

           tmp = { tmp[27:0], 4'b0 };
        end

      ual_fun_hex = o;

   end
endfunction

// ----------------------------------------------------------------------------
// UAL disassembler helper function:
// Translates a four bit value to an ARM/Thumb register name
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_fun_reg_name;

   input [ual_str_len:0] in;
   input [3:0]           num;

   reg [ual_str_len:0]   o;

   begin

      o = in;

      case(num)
        4'h0    : o = { o, "r0" };
        4'h1    : o = { o, "r1" };
        4'h2    : o = { o, "r2" };
        4'h3    : o = { o, "r3" };
        4'h4    : o = { o, "r4" };
        4'h5    : o = { o, "r5" };
        4'h6    : o = { o, "r6" };
        4'h7    : o = { o, "r7" };
        4'h8    : o = { o, "r8" };
        4'h9    : o = { o, "r9" };
        4'hA    : o = { o, "r10" };
        4'hB    : o = { o, "r11" };
        4'hC    : o = { o, "r12" };
        4'hD    : o = { o, "sp" };
        4'hE    : o = { o, "lr" };
        4'hF    : o = { o, "pc" };
        default : o = { o, "??" };
      endcase

      ual_fun_reg_name = o;

   end
endfunction

// ----------------------------------------------------------------------------
// UAL disassembler helper function:
// Translates a 16 bit value to an ARM/Thumb register list
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_fun_reg_list;

   input [ual_str_len:0] in;
   input [15:0]          list;

   reg [ual_str_len:0]   o;

   reg [3:0]             elem;
   reg [17:0]            tmp;
   reg                   first;
   integer               i;

   begin

      o     = in;
      elem  = 4'd0;
      tmp   = {list, 2'b0};
      first = 1'b1;

      // Note that tmp[2] is considered to be the current register
      // being processed on said iteration through the loop.

      for(i = 0; i < 16; i = i + 1)
        begin
           if(tmp[2] & ((!tmp[1]) | (!tmp[0] & tmp[1] & !tmp[3])))
             begin
                if(!first) o = { o, "," };
                o = ual_fun_reg_name(o, elem);
                first = 1'b0;
             end
           else if(tmp[0] & tmp[1] & tmp[2] & !tmp[3])
             begin
                o = { o, "-" };
                o = ual_fun_reg_name(o, elem);
             end
           elem = elem + 4'd1;
           tmp  = {1'b0, tmp[17:1]};
        end

      ual_fun_reg_list = o;

   end
endfunction

// ----------------------------------------------------------------------------
// UAL disassembler helper function:
// Pads out current string with spaces to operand tab stop
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_fun_tab_align;

   input [ual_str_len:0] in;
   reg [ual_str_len:0]   o;
   integer               i;

   begin

      o = in;

      // Should use a while loop, but we use a "for" to make the
      // problem tractable for synthesis.

      for(i=0; i<(ual_tab_stop); i = i + 1)
        if(~|o[(ual_tab_stop*8)+7:ual_tab_stop*8])
          o = { o, " " };

      ual_fun_tab_align = o;

   end
endfunction

// ----------------------------------------------------------------------------
// UAL disassembler helper function:
// Translates a five bit value to a decimal string in the range 0-31
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_fun_decimal;

   input [ual_str_len:0] in;
   input [5:0]           num;

   reg [ual_str_len:0]   o;

   begin

      o = in;

      case(num)
        6'd0    : o = { o, "0" };
        6'd1    : o = { o, "1" };
        6'd2    : o = { o, "2" };
        6'd3    : o = { o, "3" };
        6'd4    : o = { o, "4" };
        6'd5    : o = { o, "5" };
        6'd6    : o = { o, "6" };
        6'd7    : o = { o, "7" };
        6'd8    : o = { o, "8" };
        6'd9    : o = { o, "9" };
        6'd10   : o = { o, "10" };
        6'd11   : o = { o, "11" };
        6'd12   : o = { o, "12" };
        6'd13   : o = { o, "13" };
        6'd14   : o = { o, "14" };
        6'd15   : o = { o, "15" };
        6'd16   : o = { o, "16" };
        6'd17   : o = { o, "17" };
        6'd18   : o = { o, "18" };
        6'd19   : o = { o, "19" };
        6'd20   : o = { o, "20" };
        6'd21   : o = { o, "21" };
        6'd22   : o = { o, "22" };
        6'd23   : o = { o, "23" };
        6'd24   : o = { o, "24" };
        6'd25   : o = { o, "25" };
        6'd26   : o = { o, "26" };
        6'd27   : o = { o, "27" };
        6'd28   : o = { o, "28" };
        6'd29   : o = { o, "29" };
        6'd30   : o = { o, "30" };
        6'd31   : o = { o, "31" };
        6'd32   : o = { o, "32" };
        6'd33   : o = { o, "33" };
        6'd34   : o = { o, "34" };
        6'd35   : o = { o, "35" };
        6'd36   : o = { o, "36" };
        6'd37   : o = { o, "37" };
        6'd38   : o = { o, "38" };
        6'd39   : o = { o, "39" };
        6'd40   : o = { o, "40" };
        6'd41   : o = { o, "41" };
        6'd42   : o = { o, "42" };
        6'd43   : o = { o, "43" };
        6'd44   : o = { o, "44" };
        6'd45   : o = { o, "45" };
        6'd46   : o = { o, "46" };
        6'd47   : o = { o, "47" };
        6'd48   : o = { o, "48" };
        6'd49   : o = { o, "49" };
        6'd50   : o = { o, "50" };
        6'd51   : o = { o, "51" };
        6'd52   : o = { o, "52" };
        6'd53   : o = { o, "53" };
        6'd54   : o = { o, "54" };
        6'd55   : o = { o, "55" };
        6'd56   : o = { o, "56" };
        6'd57   : o = { o, "57" };
        6'd58   : o = { o, "58" };
        6'd59   : o = { o, "59" };
        6'd60   : o = { o, "60" };
        6'd61   : o = { o, "61" };
        6'd62   : o = { o, "62" };
        6'd63   : o = { o, "63" };
        default : o = { o, "??" };
      endcase

      ual_fun_decimal = o;

   end
endfunction

// ----------------------------------------------------------------------------
// UAL disassembler helper function:
// Translates a 16 bit value to a decimal string in the range 0-65535
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_fun_big_decimal;

   input [ual_str_len:0] in;
   input [15:0]          num;

   reg [ual_str_len:0]   o;
   reg [7:0]             digit;
   reg [47:0]            decimal;
   reg [15:0]            tmp;
   reg                   emit;

   integer               i;

   begin

      o     = in;
      tmp   = num;
      emit  = 1'b0;

      // Calculate tens of thousands.

      digit = 8'd0;

      for(i=0; i<10; i=i+1)
        begin
           if(tmp >= 16'd10000)
             begin
                tmp   = tmp - 16'd10000;
                digit = digit + 8'd1;
             end
        end

      emit = |digit;

      if(emit) o = { o, "0" + digit };

      // Calculate thousands.

      digit = 8'd0;

      for(i=0; i<10; i=i+1)
        begin
           if(tmp >= 16'd1000)
             begin
                tmp   = tmp - 16'd1000;
                digit = digit + 8'd1;
             end
        end

      emit = |digit | emit;

      if(emit) o = { o, "0" + digit };

      // Calculate hundreds.

      digit = 8'd0;

      for(i=0; i<10; i=i+1)
        begin
           if(tmp >= 16'd100)
             begin
                tmp   = tmp - 16'd100;
                digit = digit + 8'd1;
             end
        end

      emit = |digit | emit;

      if(emit) o = { o, "0" + digit };

      // Calculate tens.

      digit = 8'd0;

      for(i=0; i<10; i=i+1)
        begin
           if(tmp >= 16'd10)
             begin
                tmp   = tmp - 16'd10;
                digit = digit + 8'd1;
             end
        end

      emit = |digit | emit;

      if(emit) o = { o, "0" + digit };

      // Calculate units.

      digit = 8'd0;

      for(i=0; i<10; i=i+1)
        begin
           if(tmp >= 16'd1)
             begin
                tmp   = tmp - 16'd1;
                digit = digit + 8'd1;
             end
        end

      o = { o, "0" + digit };

      ual_fun_big_decimal = o;

   end
endfunction

// ----------------------------------------------------------------------------
// UAL disassembler helper function:
// Translates 4-bit value to condition field name
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_fun_cond_field;

   input [ual_str_len:0] in;
   input [3:0]           cond;

   reg [ual_str_len:0]   o;

   begin

      o = in;

      case(cond)
        4'b0000 : o = { o, "EQ" };
        4'b0001 : o = { o, "NE" };
        4'b0010 : o = { o, "CS" };
        4'b0011 : o = { o, "CC" };
        4'b0100 : o = { o, "MI" };
        4'b0101 : o = { o, "PL" };
        4'b0110 : o = { o, "VS" };
        4'b0111 : o = { o, "VC" };
        4'b1000 : o = { o, "HI" };
        4'b1001 : o = { o, "LS" };
        4'b1010 : o = { o, "GE" };
        4'b1011 : o = { o, "LT" };
        4'b1100 : o = { o, "GT" };
        4'b1101 : o = { o, "LE" };
        4'b1110 : o = o; // AL
        default : o = { o, "??" };
      endcase

      ual_fun_cond_field = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, ................
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_unpredictable;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      o = { o, "DCI" };
      o = ual_fun_tab_align(o);
      o = { o, "0x" };
      o = ual_fun_hex(o, opcode);
      o = { o, "  ; ? Undefined" };

      ual_t16_unpredictable = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, ................
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_undefined;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      o = { o, "DCI" };
      o = ual_fun_tab_align(o);
      o = { o, "0x" };
      o = ual_fun_hex(o, opcode);
      o = { o, "  ; ? Undefined" };

      ual_t16_undefined = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 10111110........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_bkpt;

   input [15:0]           opcode;

   reg [ual_str_len:0]    o;

   begin

      o   = ual_str_empty;
      o   = { o, "BKPT" };
      o   = ual_fun_tab_align(o);

      if(opcode[7:0] > 8'd9) o = { o, "#0x" };
      else                   o = { o, "#" };

      o   = ual_fun_hex(o, opcode[7:0]);

      ual_t16_bkpt = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 10111111....0000
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_hints;

   input [15:0] opcode;

   reg [ual_str_len:0] o;
   reg                 misc;

   begin

      o    = ual_str_empty;

      if(opcode[7:4] > 4'b0100)
        begin

           o = { o, "DCI" };
           o = ual_fun_tab_align(o);
           o = { o, "0x" };
           o = ual_fun_hex(o, opcode);
           o = { o, "  ; ? Undefined, NOP Hint" };

        end
      else
        begin

           case(opcode[7:4])
             4'b0000 : o = { o, "NOP" };
             4'b0001 : o = { o, "YIELD" };
             4'b0010 : o = { o, "WFE" };
             4'b0011 : o = { o, "WFI" };
             4'b0100 : o = { o, "SEV" };
             default : o = { o, "????" };
           endcase

        end

      ual_t16_hints = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 10111111........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_it;

   input [15:0]           opcode;

   reg [ual_str_len:0]    o;

   begin

      o = ual_str_empty;
      o = { o, "IT" };

      if(|opcode[2:0])
        o = { o, (opcode[3] ^ opcode[4]) ? "E" : "T" };

      if(|opcode[1:0])
        o = { o, (opcode[2] ^ opcode[4]) ? "E" : "T" };

      if(opcode[0])
        o = { o, (opcode[1] ^ opcode[4]) ? "E" : "T" };

      o = ual_fun_tab_align(o);

      case(opcode[7:4])
        4'hE    : o = { o, "AL" };
        4'hF    : o = { o, "NV" };
        default : o = ual_fun_cond_field(o, opcode[7:4]);
      endcase

      ual_t16_it = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 11011111........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_svc;

   input [15:0]           opcode;

   reg [ual_str_len:0]    o;

   begin

      o = ual_str_empty;

      o = { o, "SVC" };
      o = ual_fun_tab_align(o);
      o = { o, "#0x" };
      o = ual_fun_hex(o, opcode[7:0]);
      o = { o, "  ; formerly SWI" };

      ual_t16_svc = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 010000..........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_dp_reg;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   reg                 twoop;
   reg                 rsbs;
   reg                 muls;

   begin

      o     = ual_str_empty;

      twoop = (opcode[9:8] == 2'b10) | (opcode[9:6] == 4'b1111);
      rsbs  = (opcode[9:6] == 4'b1001);
      muls  = (opcode[9:6] == 4'b1101);

      case(opcode[9:6])
        4'b0000 : o = { o, "ANDS" };
        4'b0001 : o = { o, "EORS" };
        4'b0010 : o = { o, "LSLS" };
        4'b0011 : o = { o, "LSRS" };
        4'b0100 : o = { o, "ASRS" };
        4'b0101 : o = { o, "ADCS" };
        4'b0110 : o = { o, "SBCS" };
        4'b0111 : o = { o, "RORS" };
        4'b1000 : o = { o, "TST"  };
        4'b1001 : o = { o, "RSBS" };
        4'b1010 : o = { o, "CMP"  };
        4'b1011 : o = { o, "CMN"  };
        4'b1100 : o = { o, "ORRS" };
        4'b1101 : o = { o, "MULS" };
        4'b1110 : o = { o, "BICS" };
        4'b1111 : o = { o, "MVNS" };
        default : o = { o, "???"  };
      endcase

      o = ual_fun_tab_align(o);

      if(!twoop & !muls)
        begin
           o = ual_fun_reg_name(o, opcode[2:0]);
           o = { o, "," };
        end

      o = ual_fun_reg_name(o, opcode[2:0]);
      o = { o, "," };
      o = ual_fun_reg_name(o, opcode[5:3]);

      if(muls)
        begin
           o = { o, "," };
           o = ual_fun_reg_name(o, opcode[2:0]);
        end

      if(rsbs) o = { o, ",#0" };

      ual_t16_dp_reg = o;

   end
endfunction


// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 000.............
// ----------------------------------------------------------------------------


function [ual_str_len:0] ual_t16_shift_imm;

   input [15:0] opcode;

   reg [ual_str_len:0] o;
   reg [5:0]           val;

   begin

      o     = ual_str_empty;

      casez({opcode[12:11],|opcode[10:6]})
        3'b00_0 : o = { o, "MOVS" };
        3'b00_1 : o = { o, "LSLS" };
        3'b01_? : o = { o, "LSRS" };
        3'b10_? : o = { o, "ASRS" };
        default : o = { o, "????"  };
      endcase

      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, opcode[2:0]);
      o = { o, "," };

      o = ual_fun_reg_name(o, opcode[5:3]);

      val = {1'b0, opcode[10:6]};

      if(|opcode[12:11] & ~|opcode[10:6]) val = 6'd32;

      if((|opcode[12:11]) | (|opcode[10:6]))
        begin
           o = { o, ",#" };
           o = ual_fun_decimal(o, val);
        end

      ual_t16_shift_imm = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 001.............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_dp_imm;

   input [15:0] opcode;

   reg [ual_str_len:0] o;
   reg [5:0]           val;

   begin

      o = ual_str_empty;

      case(opcode[12:11])
        2'b00   : o = { o, "MOVS" };
        2'b01   : o = { o, "CMP" };
        2'b10   : o = { o, "ADDS" };
        2'b11   : o = { o, "SUBS" };
        default : o = { o, "????" };
      endcase

      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, opcode[10:8]);
      o = { o, "," };

      // UAL requires special handling to allow distinction
      // between 3-bit and 8-bit immediate encodings

      if(opcode[12] & (opcode[7:0] > 8'h7))
        begin
           o = ual_fun_reg_name(o, opcode[10:8]);
           o = { o, "," };
        end

      if(opcode[7:0] > 8'd9) o = { o, "#0x" };
      else                   o = { o, "#" };

      o = ual_fun_hex(o, opcode[7:0]);

      ual_t16_dp_imm = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 010001..........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_dp_hi_reg;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o     = ual_str_empty;

      // only MOV and ADD are allowed to use two low-registers

      if(opcode[7] | opcode[6] | ~opcode[8])
        begin

           case(opcode[9:8])
             2'b00   : o = { o, "ADD" };
             2'b01   : o = { o, "CMP" };
             2'b10   : o = { o, "MOV" };
             2'b11   : o = { o, "???" }; // BLX not in this decoder
             default : o = { o, "???" };
           endcase

           o = ual_fun_tab_align(o);

           o = ual_fun_reg_name(o, {opcode[7],opcode[2:0]});
           o = { o, "," };

           if(!(|opcode[9:8]))
             begin
                o = ual_fun_reg_name(o, {opcode[7],opcode[2:0]});
                o = { o, "," };
             end

           o = ual_fun_reg_name(o, opcode[6:3]);

        end
      else
        begin
           o = ual_t16_undefined(opcode);
        end

      ual_t16_dp_hi_reg = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 10101...........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_add_sp;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      o = { o, "ADD" };
      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, opcode[10:8]);
      o = { o, ",sp,#" };

      if(opcode[7:0] > 2) o = { o, "0x" };

      o = ual_fun_hex(o, {opcode[7:0], 2'b00});

      ual_t16_add_sp = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 10110000........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_add_sub_sp;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o   = ual_str_empty;

      if(opcode[7]) o = { o, "SUB" };
      else          o = { o, "ADD" };

      o = ual_fun_tab_align(o);

      if(opcode[6:0] > 7'd2) o = { o, "sp,sp,#0x" };
      else                   o = { o, "sp,sp,#" };

      o = ual_fun_hex(o, {opcode[6:0], 2'b0});

      ual_t16_add_sub_sp = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 00011...........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_add_sub;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      if(opcode[9]) o = { o, "SUBS" };
      else          o = { o, "ADDS" };

      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, {1'b0,opcode[2:0]});
      o = { o, "," };
      o = ual_fun_reg_name(o, {1'b0,opcode[5:3]});

      if(opcode[10])
        begin
           o = { o, ",#"};
           o = ual_fun_hex(o, opcode[8:6]);
        end
      else
        begin
           o = { o, "," };
           o = ual_fun_reg_name(o, {1'b0,opcode[8:6]});
        end

      ual_t16_add_sub = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 10100...........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_adr;

   input [15:0] opcode;
   input [31:0] address;

   reg [ual_str_len:0] o;
   reg [31:0]          offset;
   reg [31:0]          dest;

   begin

      o      = ual_str_empty;

      if(address[1]) offset = ({opcode[7:0], 2'b00} + 32'd2);
      else           offset = ({opcode[7:0], 2'b00} + 32'd4);

      dest   = address + offset;

      o      = { o, "ADR" };
      o      = ual_fun_tab_align(o);
      o      = ual_fun_reg_name(o, opcode[10:8]);
      o      = { o, ",{pc}+" };

      if(offset > 32'd9) o = { o, "0x" };

      o      = ual_fun_hex(o, offset);
      o      = { o, "  ; 0x" };
      o      = ual_fun_hex(o, dest);

      ual_t16_adr = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 1100............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_ldm_stm;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      if(opcode[11] ) o = { o, "LDM" };
      else            o = { o, "STM" };

      o = ual_fun_tab_align(o);
      o = ual_fun_reg_name(o, opcode[10:8]);

      // LDM with base in list is not a write-back operation
      if(~opcode[11] | ~opcode[{2'b0,opcode[10:8]}]) o = { o, "!" };

      o = { o, ",{" };
      o = ual_fun_reg_list(o, {8'b0,opcode[7:0]});
      o = { o, "}" };

      ual_t16_ldm_stm = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 1011.10.........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_push_pop;

   input [15:0] opcode;

   reg [ual_str_len:0] o;
   reg [15:0]          list;

   begin

      o    = ual_str_empty;
      list = {8'b0, opcode[7:0]};

      if(opcode[11])
        begin
           o = { o, "POP" };
           if(opcode[8]) list = list | 16'h8000;
        end
      else
        begin
           o = { o, "PUSH" };
           if(opcode[8]) list = list | 16'h4000;
        end

      o = ual_fun_tab_align(o);

      o = { o, "{" };
      o = ual_fun_reg_list(o, list);
      o = { o, "}" };

      ual_t16_push_pop = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 01000111........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_bx_blx;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      if(opcode[7]) o = { o, "BLX" };
      else          o = { o, "BX" };

      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, opcode[6:3]);

      if(|opcode[2:0])
        begin
           o = { o, "  ; ? SBZ = 0x" };
           o = ual_fun_hex(o, opcode[2:0]);
        end

      ual_t16_bx_blx = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 01001...........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_literal;

   input [15:0] opcode;
   input [31:0] address;

   reg [ual_str_len:0] o;
   reg [ 9:0]          base;
   reg [31:0]          dest;

   begin

      o    = ual_str_empty;

      base = {opcode[7:0], 2'b0};
      dest = {address[31:2], 2'b0} + {22'b0, base} + 32'd4;

      o    = { o, "LDR" };
      o    = ual_fun_tab_align(o);

      o    = ual_fun_reg_name(o, opcode[10:8]);
      o    = { o, ",[pc,#" };
      o    = ual_fun_big_decimal(o, {6'b0, base});
      o    = { o, "]  ; [0x" };
      o    = ual_fun_hex(o, dest);
      o    = { o, "]" };

      ual_t16_literal = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 1001............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_ls_sp;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      if(opcode[11]) o = { o, "LDR" };
      else           o = { o, "STR" };

      o = ual_fun_tab_align(o);
      o = ual_fun_reg_name(o, opcode[10:8]);


      if(opcode[7:0] > 8'd2) o = { o, ",[sp,#0x" };
      else                   o = { o, ",[sp,#" };

      o = ual_fun_hex(o, {opcode[7:0], 2'b0});
      o = { o, "]" };

      ual_t16_ls_sp = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 0101............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_ls_reg;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o     = ual_str_empty;

      case(opcode[11:9])
        3'b000  : o = { o, "STR" };
        3'b001  : o = { o, "STRH" };
        3'b010  : o = { o, "STRB" };
        3'b011  : o = { o, "LDRSB" };
        3'b100  : o = { o, "LDR" };
        3'b101  : o = { o, "LDRH" };
        3'b110  : o = { o, "LDRB" };
        3'b111  : o = { o, "LDRSH" };
        default : o = { o, "????" };
      endcase

      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, opcode[2:0]);
      o = { o, ",[" };
      o = ual_fun_reg_name(o, opcode[5:3]);
      o = { o, "," };
      o = ual_fun_reg_name(o, opcode[8:6]);
      o = { o, "]" };

      ual_t16_ls_reg = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 011.............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_ls_imm;

   input [15:0] opcode;

   reg [ual_str_len:0] o;
   reg [6:0]           offset;

   begin

      o      = ual_str_empty;
      offset = opcode[12] ? {2'b0, opcode[10:6]} : {opcode[10:6], 2'b0};

      case(opcode[12:11])
        2'b00   : o = { o, "STR" };
        2'b01   : o = { o, "LDR" };
        2'b10   : o = { o, "STRB" };
        2'b11   : o = { o, "LDRB" };
        default : o = { o, "????" };
      endcase

      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, opcode[2:0]);
      o = { o, ",[" };
      o = ual_fun_reg_name(o, opcode[5:3]);

      if(offset > 7'd9) o = { o, ",#0x" };
      else              o = { o, ",#" };

      o = ual_fun_hex(o, offset);
      o = { o, "]" };

      ual_t16_ls_imm = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 1000............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_ls_h_imm;

   input [15:0] opcode;

   reg [ual_str_len:0] o;
   reg [5:0]           offset;

   begin

      o      = ual_str_empty;
      offset = {opcode[10:6], 1'b0};

      if(opcode[11]) o = { o, "LDRH" };
      else           o = { o, "STRH" };

      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, opcode[2:0]);
      o = { o, ",[" };
      o = ual_fun_reg_name(o, opcode[5:3]);

      if(offset > 7'd9) o = { o, ",#0x" };
      else              o = { o, ",#" };

      o = ual_fun_hex(o, offset);
      o = { o, "]" };

      ual_t16_ls_h_imm = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 10110110011.0...
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_cps;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      if(opcode[4]) o = { o, "CPSID" };
      else          o = { o, "CPSIE" };

      o = ual_fun_tab_align(o);

      if(opcode[2]) o = { o, "a" };
      if(opcode[1]) o = { o, "i" };
      if(opcode[0]) o = { o, "f" };

      if(~(|opcode[2:0])) o = { o, "; ? aif = 0x0" };

      ual_t16_cps = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 1101............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_b_cond;

   input [15:0]           opcode;
   input [31:0]           address;

   reg [31:0]             val;

   reg [ual_str_len:0]    o;

   begin

      o = ual_str_empty;

      if(opcode[11:8] != 4'hE)
        begin
           o = { o, "B" };
           o = ual_fun_cond_field(o, opcode[11:8]);
           o = ual_fun_tab_align(o);

           val = { {23{opcode[7]}}, opcode[7:0], 1'b0 };
           val = val + 32'd4;

           if(val == 32'b0)
             begin
                o = { o, "{pc}  ; 0x" };
                o = ual_fun_hex(o, address);
             end
           else if(val[31])
             begin
                o   = { o, "{pc} - 0x" };
                val = (~val) + 32'd1;
                o   = ual_fun_hex(o, val);
                o   = { o, "  ; 0x" };
                val = (~val) + 32'd1;
                val = val + address;
                o   = ual_fun_hex(o, val);
             end
           else
             begin
                o   = { o, "{pc} + 0x" };
                o   = ual_fun_hex(o, val);
                o   = { o, "  ; 0x" };
                val = val + address;
                o   = ual_fun_hex(o, val);
             end
        end
      else
        begin
           o = ual_t16_undefined(opcode);
        end

      ual_t16_b_cond = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 11100...........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_b;

   input [15:0]           opcode;
   input [31:0]           address;

   reg [31:0]             val;

   reg [ual_str_len:0]    o;

   begin

      o = ual_str_empty;

      o = { o, "B" };
      o = ual_fun_tab_align(o);

      val = { {20{opcode[10]}}, opcode[10:0], 1'b0 };
      val = val + 32'd4;

      if(val == 32'b0)
        begin
           o = { o, "{pc}  ; 0x" };
           o   = ual_fun_hex(o, address);
        end
      else if(val[31])
        begin
           o   = { o, "{pc} - 0x" };
           val = (~val) + 32'd1;
           o   = ual_fun_hex(o, val);
           o   = { o, "  ; 0x" };
           val = (~val) + 32'd1;
           val = val + address;
           o   = ual_fun_hex(o, val);
        end
      else
        begin
           o   = { o, "{pc} + 0x" };
           o   = ual_fun_hex(o, val);
           o   = { o, "  ; 0x" };
           val = val + address;
           o   = ual_fun_hex(o, val);
        end

      ual_t16_b = o;

   end
endfunction


// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 1011.0.1........
// ----------------------------------------------------------------------------


function [ual_str_len:0] ual_t16_cbz;

   input [15:0]           opcode;
   input [31:0]           address;

   reg [31:0]             val;

   reg [ual_str_len:0]    o;

   begin

      o = ual_str_empty;

      val = { {25{1'b0}}, opcode[9], opcode[7:3], 1'b0 };
      val = val + 32'd4;

      if(opcode[11]) o = { o, "CBNZ" };
      else           o = { o, "CBZ" };

      o = ual_fun_tab_align(o);
      o = ual_fun_reg_name(o, opcode[2:0]);
      o = { o, "," };

      if(val == 32'b0)
        begin
           o = { o, "{pc}  ; 0x" };
           o   = ual_fun_hex(o, address);
        end
      else if(val[31])
        begin
           o   = { o, "{pc} - 0x" };
           val = (~val) + 32'd1;
           o   = ual_fun_hex(o, val);
           o   = { o, "  ; 0x" };
           val = (~val) + 32'd1;
           val = val + address;
           o   = ual_fun_hex(o, val);
        end
      else
        begin
           o   = { o, "{pc} + 0x" };
           o   = ual_fun_hex(o, val);
           o   = { o, "  ; 0x" };
           val = val + address;
           o   = ual_fun_hex(o, val);
        end

      ual_t16_cbz = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 10111010........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_rev;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      if(opcode[7:6] != 2'b10)
        begin

           case(opcode[7:6])
             2'b00   : o = { o, "REV" };
             2'b01   : o = { o, "REV16" };
             2'b10   : o = { o, "?????" }; // unreachable
             2'b11   : o = { o, "REVSH" };
             default : o = { o, "?????" };
           endcase

           o = ual_fun_tab_align(o);

           o = ual_fun_reg_name(o, opcode[2:0]);
           o = { o, "," };
           o = ual_fun_reg_name(o, opcode[5:3]);

        end
      else
        begin
           o = ual_t16_undefined(opcode);
        end


      ual_t16_rev = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 10110010.1......
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_extend;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      case(opcode[7:6])
        2'b00   : o = { o, "SXTH" };
        2'b01   : o = { o, "SXTB" };
        2'b10   : o = { o, "UXTH" };
        2'b11   : o = { o, "UXTB" };
        default : o = { o, "????" };
      endcase

      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, opcode[2:0]);
      o = { o, "," };
      o = ual_fun_reg_name(o, opcode[5:3]);

      ual_t16_extend = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 101101100101....
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_setend;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      o = { o, "SETEND" };
      o = ual_fun_tab_align(o);

      if(opcode[3]) o = { o, "BE" };
      else          o = { o, "LE" };

      if(|opcode[2:0])
        begin
           o = { o, "  ; ? SBZ = 0x" };
           o = ual_fun_hex(o, opcode[2:0]);
        end

      ual_t16_setend = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 16, 11101...........
// Decodes: THUMB, 16, 1111............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t16_prefix_t32;

   input [15:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      o = { o, "DCI" };
      o = ual_fun_tab_align(o);
      o = { o, "0x" };
      o = ual_fun_hex(o, opcode);
      o = { o, " ; 32-bit prefix" };

      ual_t16_prefix_t32 = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 32, ................................
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t32_undefined;

   input [31:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      o = { o, "DCI.W" };
      o = ual_fun_tab_align(o);
      o = { o, "0x" };
      o = ual_fun_hex(o, opcode);
      o = { o, "  ; ? Undefined" };

      ual_t32_undefined = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 32, 111100111000....10.01000........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t32_msr;

   input [31:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      o = { o, "MSR" };
      o = ual_fun_tab_align(o);

      case(opcode[7:0])

        8'd0   : o = { o, "APSR" };
        8'd1   : o = { o, "IAPSR" };
        8'd2   : o = { o, "EAPSR" };
        8'd3   : o = { o, "PSR" };
        8'd5   : o = { o, "IPSR" };
        8'd6   : o = { o, "EPSR" };
        8'd7   : o = { o, "IEPSR" };
        8'd8   : o = { o, "MSP" };
        8'd9   : o = { o, "PSP" };

        8'd16  : o = { o, "PRIMASK" };
        8'd17  : o = { o, "BASEPRI" };
        8'd18  : o = { o, "BASEPRI_MAX" };
        8'd19  : o = { o, "FAULTMASK" };
        8'd20  : o = { o, "CONTROL" };

        default:
          begin
             o = { o, "#" };
             o = ual_fun_big_decimal(o, opcode[7:0]);
          end
      endcase

      o = { o, "," };
      o = ual_fun_reg_name(o, opcode[19:16]);

      if(opcode[13])
        o = { o, "  ; ? SBZ = 0x1" };

      ual_t32_msr = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 32, 111100111110....10.0............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t32_mrs;

   input [31:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      o = { o, "MRS" };
      o = ual_fun_tab_align(o);

      o = ual_fun_reg_name(o, opcode[11:8]);
      o = { o, "," };

      case(opcode[7:0])

        8'd0   : o = { o, "APSR" };
        8'd1   : o = { o, "IAPSR" };
        8'd2   : o = { o, "EAPSR" };
        8'd3   : o = { o, "PSR" };
        8'd5   : o = { o, "IPSR" };
        8'd6   : o = { o, "EPSR" };
        8'd7   : o = { o, "IEPSR" };
        8'd8   : o = { o, "MSP" };
        8'd9   : o = { o, "PSP" };
        8'd10  : o = { o, "DSP" };

        8'd16  : o = { o, "PRIMASK" };
        8'd17  : o = { o, "BASEPRI" };
        8'd18  : o = { o, "BASEPRI_MAX" };
        8'd19  : o = { o, "FAULTMASK" };
        8'd20  : o = { o, "CONTROL" };

        default:
          begin
             o = { o, "#" };
             o = ual_fun_big_decimal(o, opcode[7:0]);
          end
      endcase

      if(opcode[13] || !(&opcode[19:16]))
        begin
           o = { o, "  ; ? SBO/SBZ = 0x" };
           o = ual_fun_hex(o, {opcode[19:16], opcode[13]});
        end

      ual_t32_mrs = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 32, 111100111011....10.0............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t32_dsb_dmb_isb;

   input [31:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      if((opcode[7:6] != 2'b01) || (opcode[5:4] == 2'b11))
        begin
           o = ual_t32_undefined(opcode);
        end
      else
        begin

           case(opcode[7:4])
             4'b0100 : o = { o, "DSB" };
             4'b0101 : o = { o, "DMB" };
             4'b0110 : o = { o, "ISB" };
             default : o = { o, "???" }; // unreachable
           endcase

           if((|opcode[3:0]) || !(&{opcode[19:16], ~opcode[13], opcode[11:8]}))
             o = ual_fun_tab_align(o);

           if((|opcode[3:0]))
             begin
                o = { o, "0x" };
                o = ual_fun_hex(o, opcode[3:0]);
             end

           if(!(&{opcode[19:16], ~opcode[13], opcode[11:8]}))
             begin
                o = { o, "  ? SBO/SBZ = 0x" };
                o = ual_fun_hex(o, {opcode[19:16], opcode[13], opcode[11:8]});
             end

        end

      ual_t32_dsb_dmb_isb = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 32, 111100111010....10.0.000........
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t32_hints;

   input [31:0] opcode;

   reg [ual_str_len:0] o;

   begin

      o = ual_str_empty;

      if(opcode[7:0] < 8'b00000101)
        begin

           case(opcode[7:0])
             8'b00000000 : o = { "NOP.W" };
             8'b00000001 : o = { "YIELD.W" };
             8'b00000010 : o = { "WFE.W" };
             8'b00000011 : o = { "WFI.W" };
             8'b00000100 : o = { "SEV.W" };
             default     : o = { "?????" }; // unreachable
           endcase

           if(opcode[13] || opcode[11] || !(|opcode[19:16]))
             begin
                o = ual_fun_tab_align(o);
                o = { o, "? SBZ/SBO = 0x" };
                o = ual_fun_hex(o, {opcode[19:16], opcode[13], opcode[11]});
             end

        end
      else
        begin
           o = ual_t32_undefined(opcode);
        end


      ual_t32_hints = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 32, 11110........... 10.0............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t32_b_cond;

   input [31:0]           opcode;
   input [31:0]           address;

   reg [31:0]             val;

   reg [ual_str_len:0]    o;

   begin

      val = { {12{opcode[26]}},
              opcode[11],
              opcode[13],
              opcode[21:16],
              opcode[10:0],
              1'b0 };

      val = val + 32'd4;

      o = ual_str_empty;

      o = { o, "B" };
      o = ual_fun_cond_field(o, opcode[25:22]);
      o = { o, ".W"};


      o = ual_fun_tab_align(o);

      if(val == 32'b0)
        begin
           o = { o, "{pc}  ; 0x" };
           o   = ual_fun_hex(o, address);
        end
      else if(val[31])
        begin
           o   = { o, "{pc} - 0x" };
           val = (~val) + 32'd1;
           o   = ual_fun_hex(o, val);
           o   = { o, "  ; 0x" };
           val = (~val) + 32'd1;
           val = val + address;
           o   = ual_fun_hex(o, val);
        end
      else
        begin
           o   = { o, "{pc} + 0x" };
           o   = ual_fun_hex(o, val);
           o   = { o, "  ; 0x" };
           val = val + address;
           o   = ual_fun_hex(o, val);
        end

      ual_t32_b_cond = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 32, 11110........... 1..1............
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t32_b_bl;
   input [31:0] opcode;
   input [31:0] address;

   reg [31:0]   val;

   reg [ual_str_len:0] o;

   begin

      val = { {8{opcode[26]}},
              ~(opcode[26] ^ opcode[13]),
              ~(opcode[26] ^ opcode[11]),
              opcode[25:16],
              opcode[10:0],
              1'b0 };

      val = val + 32'd4;

      o = ual_str_empty;

      o = { o, "B" };

      if(opcode[14]) o = { o, "L" };
      else           o = { o, ".W"};


      o = ual_fun_tab_align(o);

      if(val == 32'b0)
        begin
           o = { o, "{pc}  ; 0x" };
           o   = ual_fun_hex(o, address);
        end
      else if(val[31])
        begin
           o   = { o, "{pc} - 0x" };
           val = (~val) + 32'd1;
           o   = ual_fun_hex(o, val);
           o   = { o, "  ; 0x" };
           val = (~val) + 32'd1;
           val = val + address;
           o   = ual_fun_hex(o, val);
        end
      else
        begin
           o   = { o, "{pc} + 0x" };
           o   = ual_fun_hex(o, val);
           o   = { o, "  ; 0x" };
           val = val + address;
           o   = ual_fun_hex(o, val);
        end

      ual_t32_b_bl = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Instruction decoder:
// Decodes: THUMB, 32, ................................
// ----------------------------------------------------------------------------

function [ual_str_len:0] ual_t32_opcode_t16 ( input [31:0] opcode );
   reg   [ual_str_len:0] o;
   begin

      o = ual_str_empty;

      o = { o, "DCI" };
      o = ual_fun_tab_align(o);
      o = { o, "0x" };
      o = ual_fun_hex(o, opcode[31:16]);
      o = { o, ", 0x" };
      o = ual_fun_hex(o, opcode[15:0]);
      o = { o, "  ; ? T16 opcode" };

      ual_t32_opcode_t16 = o;

   end
endfunction

// ----------------------------------------------------------------------------
// UAL disassembler primary decoder for Thumb state T16
// ----------------------------------------------------------------------------

// Note that the order of entries in the decode table below is critical,
// Verilog always works top to bottom for a decode match.

function [ual_str_len:0] ual_dec_t16;

   input [15:0] opcode;
   input [31:0] address;

   reg [ual_str_len:0] o;

   begin

      casez(opcode[15:0])

        16'b00011??????????? : o = ual_t16_add_sub(opcode);
        16'b000????????????? : o = ual_t16_shift_imm(opcode);
        16'b001????????????? : o = ual_t16_dp_imm(opcode);
        16'b010000?????????? : o = ual_t16_dp_reg(opcode);
        16'b01000111???????? : o = ual_t16_bx_blx(opcode);
        16'b010001?????????? : o = ual_t16_dp_hi_reg(opcode);
        16'b01001??????????? : o = ual_t16_literal(opcode,address);
        16'b0101???????????? : o = ual_t16_ls_reg(opcode);
        16'b011????????????? : o = ual_t16_ls_imm(opcode);
        16'b1000???????????? : o = ual_t16_ls_h_imm(opcode);
        16'b1001???????????? : o = ual_t16_ls_sp(opcode);
        16'b10111110???????? : o = ual_t16_bkpt(opcode);
        16'b10100??????????? : o = ual_t16_adr(opcode,address);
        16'b10101??????????? : o = ual_t16_add_sp(opcode);
        16'b10110000???????? : o = ual_t16_add_sub_sp(opcode);
        16'b10110010???????? : o = ual_t16_extend(opcode);
        16'b101101100101???? : o = ual_t16_setend(opcode);
        16'b10110110011?0??? : o = ual_t16_cps(opcode);
        16'b10110110011?1??? : o = ual_t16_unpredictable(opcode);
        16'b10111010???????? : o = ual_t16_rev(opcode);
        16'b1011?0?1???????? : o = ual_t16_cbz(opcode,address);
        16'b1011?10????????? : o = ual_t16_push_pop(opcode);
        16'b10111111????0000 : o = ual_t16_hints(opcode);
        16'b10111111???????? : o = ual_t16_it(opcode);
        16'b1100???????????? : o = ual_t16_ldm_stm(opcode);
        16'b11011111???????? : o = ual_t16_svc(opcode);
        16'b1101???????????? : o = ual_t16_b_cond(opcode,address);
        16'b11100??????????? : o = ual_t16_b(opcode,address);
        16'b1111???????????? : o = ual_t16_prefix_t32(opcode);

        default : o = ual_t16_undefined(opcode);
      endcase

      ual_dec_t16 = o;

   end
endfunction

// ----------------------------------------------------------------------------
// UAL disassembler primary decoder for Thumb state T32
// ----------------------------------------------------------------------------

// Note that the order of entries in the decode table below is critical,
// Verilog always works top to bottom for a decode match.

function [ual_str_len:0] ual_dec_t32;

   input [31:0] opcode;
   input [31:0] address;

   reg [ual_str_len:0] o;

   begin

      casez(opcode[31:0])

        32'b111100111000????_10?01000???????? : o = ual_t32_msr(opcode);
        32'b111100111010????_10?0?000???????? : o = ual_t32_hints(opcode);
        32'b111100111110????_10?0???????????? : o = ual_t32_mrs(opcode);
        32'b111100111011????_10?0???????????? : o = ual_t32_dsb_dmb_isb(opcode);
        32'b111101111111????_1010????1111???? : o = ual_t32_undefined(opcode);
        32'b11110?1110??????_10?0???????????? : o = ual_t32_undefined(opcode);
        32'b11110?1111??????_10?0???????????? : o = ual_t32_undefined(opcode);
        32'b11110???????????_10?0???????????? : o = ual_t32_b_cond(opcode,address);
        32'b11110???????????_1??1???????????? : o = ual_t32_b_bl(opcode,address);
        32'b11110???????????_1??????????????? : o = ual_t32_undefined(opcode);

        default : o = ual_t32_undefined(opcode);
      endcase

      if(opcode[31:27] != 5'b11110) o = ual_t32_opcode_t16(opcode);

      ual_dec_t32 = o;

   end
endfunction

// ----------------------------------------------------------------------------
// Display banner for each inclusion
// ----------------------------------------------------------------------------

// Call this task from an initial statement

task display_ualdis_banner;
   begin
      $write("---------------------------------------------------------\n");
      $write("ARMv6-M Thumb UAL Verilog Disassembler for ARM Cortex-M0\n");
      $write("(C) COPYRIGHT 2006-2016 ARM Limited - All Rights Reserved\n");
      $write("---------------------------------------------------------\n");
   end
endtask

// ----------------------------------------------------------------------------
// EOF
// ----------------------------------------------------------------------------
