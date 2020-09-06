/////////////////////////////////////////////////////////////////////
// Design unit: CPU
//            :
// File name  : cpu.sv
//            :
// Description: Top level of basic processor
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
// Revision   : Version 1.0 05/08/08
//            : Version 1.1 17/12/13
//            : Version 1.2 11/12/14
//            : Version 1.3 15/01/18
/////////////////////////////////////////////////////////////////////

module CPU #(parameter WORD_W = 8, OP_W = 3)
                  (input logic clock, n_reset, input logic [7:0] switches,
                   output logic [6:0] disp0, disp1, disp2, disp3);
		   
logic ACC_bus, load_ACC, PC_bus, load_PC, load_IR, load_MAR,
MDR_bus, load_MDR, ALU_ACC, ALU_add, ALU_sub, ALU_xor, INC_PC,
Addr_bus, CS, R_NW, z_flag;

logic [OP_W-1:0] op;
wire [WORD_W-1:0] sysbus;
logic [3:0] hex1, hex2;


sequencer #(.WORD_W(WORD_W), .OP_W(OP_W)) s1  (.*);

IR #(.WORD_W(WORD_W), .OP_W(OP_W)) i1  (.*);

PC #(.WORD_W(WORD_W), .OP_W(OP_W)) p1 (.*);

ALU #(.WORD_W(WORD_W), .OP_W(OP_W)) a1 (.*);

RAM #(.WORD_W(WORD_W), .OP_W(OP_W)) r1 (.*);

ROM #(.WORD_W(WORD_W), .OP_W(OP_W)) r2 (.*);

SSR #(.WORD_W(WORD_W), .OP_W(OP_W)) r3 (.*);

//Display sysbus. Modify if WORD_W changes.

sevenseg d0 (.address(sysbus[3:0]), .data(disp0));
sevenseg d1 (.address(sysbus[7:4]), .data(disp1));
sevenseg d2 (.address(hex1), .data(disp2));
sevenseg d3 (.address(hex2), .data(disp3));
endmodule