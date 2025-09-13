`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// ALU  
// Mux
// Adder
// And gate 
// Execute Stage Registers

////////////////////////////////////////////////////////////////////
//                               ALU                              //
//////////////////////////////////////////////////////////////////// 
module ALU(
    input [31:0] a, b, 
    input [2:0] ALUcontrol, 
    output [31:0] result, 
    output Zero 
);
    wire cout; 
    wire [31:0] sum;
    
    assign sum = (ALUcontrol[0] == 1'b0) ? (a+b) : (a + (~b+1)) ;
    
    assign {cout, result} =  (ALUcontrol == 3'b000) ? sum : 
                             (ALUcontrol == 3'b001) ? sum : 
                             (ALUcontrol == 3'b010) ? a&b :
                             (ALUcontrol == 3'b011) ? a|b : {33{1'b0}};
                         
    assign Zero = &(~result);
endmodule 
    
    
////////////////////////////////////////////////////////////////////
//                               Mux                              //
////////////////////////////////////////////////////////////////////  
module Mux(
    input [31:0] i0, i1, 
    input sel, 
    output [31:0] y
);

    assign y = sel ? i1 : i0;
endmodule 


////////////////////////////////////////////////////////////////////
//                               Add                              //
//////////////////////////////////////////////////////////////////// 
module adder_unit(
    input [31:0] a, b, 
    output [31:0] sum
);

    assign sum = a+ b;
endmodule 


////////////////////////////////////////////////////////////////////
//                        Forwarding mux                          //
//////////////////////////////////////////////////////////////////// 
module f_mux(
    input [31:0] in_00, in_01, in_10, 
    input [1:0] sel,
    output [31:0] f_mux_out
);

    assign f_mux_out =  (sel == 2'b00) ? in_00 : 
                     (sel == 2'b01) ? in_01 :  
                     (sel == 2'b10) ? in_10 : 2'b00;
endmodule 



////////////////////////////////////////////////////////////////////
//                         Execute_cycle                          //
////////////////////////////////////////////////////////////////////
module Execute_cycle(
    input BranchE, ResultSrcE, MemWriteE, ALUSrcE, RegWriteE, clk, rst, 
    input [2:0] ALUcontrolE,
    input [4:0] RdE,
    input [31:0] RD1E, RD2E,
    input [31:0] PCE, ImmExtE, PCPlus4E, 
    
    input [1:0] ForwardAE, ForwardBE,
    input [31:0] ALUResultM_in, ResultW_in,
    
    output RegWriteM, ResultSrcM, MemWriteM, PCSrcE,
    output [31:0] ALUResultM, WriteDataM, PCPlus4M, 
    output [31:0] PCTargetE,
    output [4:0] RdM
);
    
    reg [31:0] ALUResultE_reg, WriteDataE_reg, PCPlus4E_reg;
    reg [4:0] RdE_reg;
    reg RegWriteE_reg, ResultSrcE_reg, MemWriteE_reg;
    
    wire [31:0] f_mux_out1, f_mux_out2;
    
    wire [31:0] SrcBE;
    wire [31:0] ALUResultE;
    wire ZeroE;
 
    
    adder_unit addr(
                    .a(PCE), 
                    .b(ImmExtE), 
                    .sum(PCTargetE)
                    );
                    
    
    f_mux forwarding_mux1(
                    .in_00(RD1E), 
                    .in_01(ResultW_in), 
                    .in_10(ALUResultM_in), 
                    .sel(ForwardAE),
                    .f_mux_out(f_mux_out1)
                    );
    

    f_mux forwarding_mux2(
                    .in_00(RD2E), 
                    .in_01(ResultW_in), 
                    .in_10(ALUResultM_in), 
                    .sel(ForwardBE),
                    .f_mux_out(f_mux_out2)
                    );
                    
                        
    Mux mux(
                    .i0(f_mux_out2), 
                    .i1(ImmExtE), 
                    .sel(ALUSrcE), 
                    .y(SrcBE)
                    ); 
                    
    ALU alu(
                    .a(f_mux_out1), 
                    .b(SrcBE), 
                    .ALUcontrol(ALUcontrolE), 
                    .result(ALUResultE), 
                    .Zero(ZeroE)
                    );
                    
                    
    always @(posedge clk or posedge rst)
      begin 
        if(rst)
          begin 
            ALUResultE_reg <=  32'h00000000;
            WriteDataE_reg <= 32'h00000000;
            PCPlus4E_reg <= 32'h00000000;
            RdE_reg <= 5'b00000;
            RegWriteE_reg <= 1'b0;
            ResultSrcE_reg <= 1'b0;
            MemWriteE_reg <= 1'b0;
          end 
        else 
          begin
            ALUResultE_reg <= ALUResultE;  
            WriteDataE_reg <= f_mux_out2;
            PCPlus4E_reg <= PCPlus4E;
            RdE_reg <= RdE;
            RegWriteE_reg <= RegWriteE;
            ResultSrcE_reg <= ResultSrcE;
            MemWriteE_reg <= MemWriteE; 
          end 
      end  
      
      
    assign RegWriteM = RegWriteE_reg;
    assign ResultSrcM = ResultSrcE_reg;
    assign MemWriteM = MemWriteE_reg;
    assign ALUResultM = ALUResultE_reg;
    assign WriteDataM = WriteDataE_reg;
    assign PCPlus4M = PCPlus4E_reg;
    assign RdM = RdE_reg;
    assign PCSrcE = ZeroE & BranchE;
    
endmodule

