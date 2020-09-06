/////////////////////////////////////////////////////////////////////
// Design unit: SSR
//            :
// File name  : ssr.sv
//            :
// Description: Switch/Segment Register

module SSR #(parameter WORD_W = 8, OP_W = 3)
               (input logic clock, n_reset, MDR_bus, load_MDR, load_MAR, CS, R_NW,
                inout wire [WORD_W-1:0] sysbus, input logic [7:0] switches, output logic [7:0]hex1);

//`include "opcodes.h"
		
logic [WORD_W-1:0] mdr; 
logic [WORD_W-OP_W-1:0] mar; 
logic [WORD_W-1:0] mem [0:(1<<(WORD_W-OP_W-1))-1]; //top half of address range
//logic [WORD_W-1:0] mem [0:11]; //top half of address range
int i;

assign sysbus = (MDR_bus & mar == 5'd30) ? switches : {WORD_W{1'bZ}};// Switches data out to bus

always_ff @(posedge clock, negedge n_reset)
 begin
 if (~n_reset)
 	begin
 	mdr <= 0;
 	mar <= 0;
	hex1 <= 0;
 	end
 else
 	if (load_MAR)
 	mar <= sysbus[WORD_W-OP_W-1:0];
 	else if (load_MDR)
 		mdr <= sysbus;
 		else if (CS & mar == 5'd31) // if 7 segment display address
			begin
 			if (!R_NW) // Writing, so this signal needs to be low
			begin
			hex1 <= mdr;
			end
			else mdr <= {hex1[7:4],hex1[3:0]};
			end
 end


endmodule
