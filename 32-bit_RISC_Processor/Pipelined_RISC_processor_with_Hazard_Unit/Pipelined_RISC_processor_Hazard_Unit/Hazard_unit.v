`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//                         Hazard Unit : Forwarding                             //
//////////////////////////////////////////////////////////////////////////////////


module Hazard_unit(
    input RegWriteM, RegWriteW, 
    input [4:0] RdM, RdW, Rs1E, Rs2E,      
    output [1:0] ForwardAE, ForwardBE
);
    // Forwarding A logic 
    assign  ForwardAE = ((RegWriteM == 1) && (RdM != 0) && (RdM == Rs1E)) ? 2'b10 : 
                        ((RegWriteW == 1) && (RdW != 0) && (RdW == Rs1E)) ? 2'b01 : 2'b00;
                        
    // Forwarding B logic 
    assign  ForwardBE = ((RegWriteM == 1) && (RdM != 0) && (RdM == Rs2E)) ? 2'b10 : 
                        ((RegWriteW == 1) && (RdW != 0) && (RdW == Rs2E)) ? 2'b01 : 2'b00;
                        
endmodule

