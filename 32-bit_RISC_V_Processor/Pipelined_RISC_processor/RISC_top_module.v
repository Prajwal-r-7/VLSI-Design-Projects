`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//                    RISC Processor - Pipelined Architecture                   //
//////////////////////////////////////////////////////////////////////////////////
`include "Fetch_cycle.v"
`include "Decode_cycle.v"
`include "Execute_cycle.v"
`include "Memory_cycle.v"
`include "Write_back_cycle.v"

module RISC_top_module( 
    input clk, rst
);

    wire PCSrcE, RegWriteW, BranchE, ResultSrcE, MemWriteE, ALUSrcE, RegWriteE, RegWriteM, ResultSrcM, MemWriteM, ResultSrcW;
    wire [31:0] PCTargetE, InstrD, ResultW, RD1E, RD2E, ImmExtE, ALUResultM, WriteDataM, ALUResultW, ReadDataW;
    wire [31:0] PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W; 
    wire [31:0] PCD, PCE ;
    wire [2:0] ALUcontrolE; 
    wire [4:0] RDW, RdE, RdM;
    
    
    /////////////////////////// Fetch_cycle ///////////////////////////
    Fetch_cycle fetch_cycle(
                    .clk(clk), 
                    .rst(rst), 
                    .PCSrcE(PCSrcE),
                    .PCTargetE(PCTargetE), 
                    .InstrD(InstrD), 
                    .PCD(PCD), 
                    .PCPlus4D(PCPlus4D)
                    );
    
    /////////////////////////// Decode_cycle ///////////////////////////                 
    Decode_cycle decode_cycle(
                    .clk(clk), 
                    .rst(rst), 
                    .RegWriteW(RegWriteW), 
                    .InstrD(InstrD), 
                    .PCD(PCD), 
                    .PCPlus4D(PCPlus4D), 
                    .ResultW(ResultW), 
                    .RDW(RDW), 
                    .BranchE(BranchE), 
                    .ResultSrcE(ResultSrcE), 
                    .MemWriteE(MemWriteE), 
                    .ALUSrcE(ALUSrcE), 
                    .RegWriteE(RegWriteE),
                    .ALUcontrolE(ALUcontrolE),
                    .RdE(RdE),
                    .RD1E(RD1E), 
                    .RD2E(RD2E),
                    .PCE(PCE), 
                    .ImmExtE(ImmExtE), 
                    .PCPlus4E(PCPlus4E)
                    ); 
    
    /////////////////////////// Execute_cycle ///////////////////////////                 
    Execute_cycle execute_cycle(
                    .BranchE(BranchE), 
                    .ResultSrcE(ResultSrcE), 
                    .MemWriteE(MemWriteE), 
                    .ALUSrcE(ALUSrcE), 
                    .RegWriteE(RegWriteE), 
                    .clk(clk), 
                    .rst(rst), 
                    .ALUcontrolE(ALUcontrolE),
                    .RdE(RdE),
                    .RD1E(RD1E), 
                    .RD2E(RD2E),
                    .PCE(PCE), 
                    .ImmExtE(ImmExtE), 
                    .PCPlus4E(PCPlus4E), 
                    .RegWriteM(RegWriteM), 
                    .ResultSrcM(ResultSrcM), 
                    .MemWriteM(MemWriteM), 
                    .PCSrcE(PCSrcE),
                    .ALUResultM(ALUResultM), 
                    .WriteDataM(WriteDataM), 
                    .PCPlus4M(PCPlus4M), 
                    .PCTargetE(PCTargetE),
                    .RdM(RdM)
                    );
                    
    /////////////////////////// Memory_cycle ///////////////////////////                 
    Memory_cycle memory_cycle(
                    .clk(clk), 
                    .rst(rst), 
                    .RegWriteM(RegWriteM), 
                    .ResultSrcM(ResultSrcM), 
                    .MemWriteM(MemWriteM),
                    .ALUResultM(ALUResultM), 
                    .WriteDataM(WriteDataM), 
                    .PCPlus4M(PCPlus4M), 
                    .RdM(RdM), 
                    .RegWriteW(RegWriteW), 
                    .ResultSrcW(ResultSrcW),
                    .ALUResultW(ALUResultW), 
                    .PCPlus4W(PCPlus4W), 
                    .ReadDataW(ReadDataW),
                    .RdW(RDW)
                    );   
                    
    /////////////////////////// Write_back_cycle ///////////////////////////                 
    Write_back_cycle write_back_cycle(
                    .ResultSrcW(ResultSrcW),
                    .ALUResultW(ALUResultW), 
                    .ReadDataW(ReadDataW),
                    .ResultW(ResultW)
                    );                                              
endmodule
