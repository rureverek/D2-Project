/////////////////////////////////////////////////////////////////////
// Design unit: ROM
//            :
// File name  : rom.sv
//            :
// Description: ROM for basic processor
//            : including simple program 
//            :
// Limitations: None
//            : 
// System     : SystemVerilog IEEE 1800-2005
//            :
// Author     : Mark Zwolinski
//            : School of Electronics and Computer Science
//            : University of Southampton
//            : Southampton SO17 1BJ, UK
//            : mz@ecs.soton.ac.uk
//
// Revision   : Version 1.0 12/12/14
/////////////////////////////////////////////////////////////////////

module ROM #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, MDR_bus, load_MDR, load_MAR, CS, R_NW,
                inout wire [WORD_W-1:0] sysbus);

`include "opcodes.h"
		

logic [WORD_W-OP_W-1:0] mar;
logic [WORD_W-1:0] mdr;

assign sysbus = (MDR_bus & (mar < 5'd20)) ? mdr : {WORD_W{1'bZ}};//change to mar < 20
//assign sysbus = (MDR_bus & ~mar[WORD_W-OP_W-1]) ? mdr : {WORD_W{1'bZ}};
always_ff @(posedge clock, negedge n_reset)
  begin
  if (~n_reset)
    begin 
    mar <= 0;
    end
  else
    if (load_MAR)
      mar <= sysbus[WORD_W-OP_W-1:0];
  end


always_comb
  begin
  mdr = 0;
  case (mar)
	//load pointer (5'd6) (0)
	0: mdr = {`LOAD, 5'd9};
	1: mdr = {`STORE, 5'd20};
	//save pointer in ram (5'd20) <-- bne function loop (1)
	2: mdr = {`LDE, 5'd20};
	//load from (5'd20) (2)
	3: mdr = {`XOR, 5'd10};
	//xor from (5'd7) (3)
	4: mdr = {`STORE, 5'd31};
	//store in hex (4)
	//4: 
	//increment pointer (load, add 1, (can use INC op code)) (5) (6)
	5: mdr = {`LOAD, 5'd20};
	6: mdr = {`INC, 5'd0};
	//mdr = {`STORE, 5'd20};
	//bne 1 (7)
	7: mdr = {`BNE, 5'd8};
	8: mdr = 1;
	9: mdr = 5'd11; //Start data pointer
	10: mdr = 5'b10101;//code
	11: mdr = 5'b01111;//data 1-8 bits to encode
	12: mdr = 5'b01000;
	13:mdr = 5'b11001;
	14:mdr = 5'b10100;
	15:mdr = 5'b01101;
	16:mdr = 5'b01101;
	17:mdr = 5'b11110;
	18:mdr = 5'b01011;
    default: mdr = 0;
  endcase
  end
  
endmodule