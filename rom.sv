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
	0: mdr = {`LOAD, 5'd10};
	1: mdr = {`STORE, 5'd21}; //Store counter
	2: mdr = {`LOAD, 5'd30}; //Get Char
	3: mdr = {`XOR,5'd11}; //Encrypt/Decrypt
	4: mdr = {`STORE, 5'd31}; //Display in HEX
	5: mdr = {`LOAD, 5'd21};
	6: mdr = {`SUB, 5'd9};//Decrement counter
	7: mdr = {`BNE, 5'd9};//Repeat, if 8bit block end
	8: mdr = 0;
	9: mdr = 1;
	10: mdr = 7;
	11: mdr = 5'b10101;//key
	
	
    default: mdr = 0;
  endcase
  end
  
endmodule