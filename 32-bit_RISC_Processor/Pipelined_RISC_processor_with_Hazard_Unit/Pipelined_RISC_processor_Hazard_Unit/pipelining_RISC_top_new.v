`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
//                    RISC Processor - Pipelined Architecture                   //
//////////////////////////////////////////////////////////////////////////////////
`include "fetch_cycle_new.v"
`include "decode_cycle_new.v"
`include "execute_cycle_new.v"
`include "memory_cycle_new.v"
`include "write_back_cycle_new.v"

module RISC_top_module( 
    input clk, rst
);

    wire PCSrcE, RegWriteW, BranchE, ResultSrcE, MemWriteE, ALUSrcE, RegWriteE, RegWriteM, ResultSrcM, MemWriteM, ResultSrcW;
    wire [31:0] PCTargetE, InstrD, ResultW, RD1E, RD2E, ImmExtE, ALUResultM, WriteDataM, ALUResultW, ReadDataW;
    wire [31:0] PCPlus4D, PCPlus4E, PCPlus4M, PCPlus4W; 
    wire [31:0] PCD, PCE ;
    wire [2:0] ALUcontrolE; 
    wire [4:0] RDW, RdE, RdM;
    
    wire [1:0] ForwardAE_wire, ForwardBE_wire;
    wire [31:0] Rs1E_wire, Rs2E_wire;
    
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
                    .PCPlus4E(PCPlus4E),
                    .Rs1E(Rs1E_wire), 
                    .Rs2E(Rs2E_wire)
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
                    .RdM(RdM), 
                    .ForwardAE(ForwardAE_wire),
                    .ForwardBE(ForwardBE_wire),
                    .ALUResultM_in(ALUResultM),
                    .ResultW_in(ResultW)
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
         
                    
    /////////////////////////// Write_back_cycle ///////////////////////////                 
    Hazard_unit forwarding_unit(
                    .RegWriteM(RegWriteM), 
                    .RegWriteW(RegWriteW), 
                    .RdM(RdM), 
                    .RdW(RDW), 
                    .Rs1E(Rs1E_wire), 
                    .Rs2E(Rs2E_wire),
                    .ForwardAE(ForwardAE_wire), 
                    .ForwardBE(ForwardBE_wire)
                    );                   
endmodule
