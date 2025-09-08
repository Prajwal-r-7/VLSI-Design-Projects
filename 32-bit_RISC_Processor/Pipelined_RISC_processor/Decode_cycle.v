`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Control Unit 
// Register File  
// Sign Extend

////////////////////////////////////////////////////////////////////
//                          Contorl Unit                          //
//////////////////////////////////////////////////////////////////// 
module main_decoder(
    input [6:0] op, 
    input Branch, 
    output ResultSrc, MemWrite, ALUSrc, RegWrite, 
    output [1:0] ALUop, ImmSrc
);

    assign RegWrite = (op == 7'b0000011 || op == 7'b0110011) ? 1 : 0;
    
    assign ImmSrc = (op == 7'b0000011 || op == 7'b0110011) ? 2'b00 : 
                    (op == 7'b0100011) ? 2'b01 : 
                    (op == 7'b1100011) ? 2'b10 : 2'b00;
                    
    assign ALUSrc = (op == 7'b0000011 || op == 7'b0100011) ? 1 : 0;
    
    assign MemWrite = (op == 7'b0100011) ? 1 : 0;
    
    assign ResultSrc = (op == 7'b0000011) ? 1 : 0;
    
    assign Branch = (op == 7'b1100011) ? 1 : 0;
    
    assign ALUop = (op == 7'b0000011 || op == 7'b0100011) ? 2'b00 : 
                   (op == 7'b0110011) ? 2'b10 : 
                   (op == 7'b1100011) ? 2'b01 : 2'b00; 
                     
endmodule 

module ALU_decoder(
    input [1:0] ALUop, 
    input [6:0] funct7, op, 
    input [2:0] funct3, 
    output [2:0] ALUcontrol
);

    wire [1:0] concatination = {op[5], funct7[5]};
    
    assign ALUcontrol = (ALUop == 2'b00) ? 3'b000 :  // add || lw, sw
                        (ALUop == 2'b01) ? 3'b001 :  // sub || beq
                        ((ALUop == 2'b10) && (funct3 == 3'b010)) ? 3'b101 :  // add || r-type
                        ((ALUop == 2'b10) && (funct3 == 3'b110)) ? 3'b011 :  // or || r-type
                        ((ALUop == 2'b10) && (funct3 == 3'b111)) ? 3'b010 :  // and || r-type
                        ((ALUop == 2'b10) && (funct3 == 3'b000) && (concatination == 2'b11)) ? 3'b001 :  // sub || r-type
                        ((ALUop == 2'b10) && (funct3 == 3'b000) && (concatination != 2'b11)) ? 3'b000 :  3'b000; // add || r-type
endmodule

// control unit 
module Control_unit(
    input [6:0] op, funct7, 
    input [2:0] funct3, 
    output Branch, ResultSrc, MemWrite, ALUSrc, RegWrite, 
    output [1:0] ImmSrc, 
    output [2:0] ALUcontrol
);
    wire [1:0] ALUop;
    
    main_decoder main_dec(
                    .op(op), 
                    .Branch(Branch), 
                    .ResultSrc(ResultSrc), 
                    .MemWrite(MemWrite), 
                    .ALUSrc(ALUSrc), 
                    .RegWrite(RegWrite), 
                    .ALUop(ALUop), 
                    .ImmSrc(ImmSrc) 
                    );
                
   ALU_decoder alu_decoder(
                    .ALUop(ALUop), 
                    .funct7(funct7), 
                    .op(op), 
                    .funct3(funct3), 
                    .ALUcontrol(ALUcontrol)
                    );
endmodule 
       
   
                    
////////////////////////////////////////////////////////////////////
//                        Register file                           //
////////////////////////////////////////////////////////////////////    
module Register_file(
    input [4:0] A1, A2, A3, 
    input clk, rst, WE3, 
    input [31:0] WD3, 
    output [31:0] RD1, RD2
);
    reg [31:0] register [31:0];
    
    assign RD1 = register[A1];
    assign RD2 = register[A2];
    
    always @(posedge clk)
        begin 
         if(WE3 && (A3 != 0))
           begin 
             register[A3] = WD3;
           end 
        end
        
        initial begin 
          register[0] = 32'h00000000;
          register[1] = 32'h00000005;
          register[6] = 32'h00000000;
          register[4] = 32'h00000002;
        end 
endmodule 


////////////////////////////////////////////////////////////////////
//                         Sign Extend                            //
////////////////////////////////////////////////////////////////////  
module Sign_Extend(
    input [31:0] in, 
    input [1:0] ImmSrc,
    output [31:0] ImmExt
);

    assign ImmExt = (ImmSrc == 2'b00) ? {{20{in[31]}}, in[31:20]} : 
                    (ImmSrc == 2'b01) ? {{20{in[31]}}, in[31:25], in[11:7]} : 32'h00000000;

endmodule 
                     
    

////////////////////////////////////////////////////////////////////
//                        Decode Cycle                            //
////////////////////////////////////////////////////////////////////               
module Decode_cycle(
    input clk, rst, RegWriteW, 
    input [31:0] InstrD, PCD, PCPlus4D, ResultW, 
    input [4:0] RDW, 
    output BranchE, ResultSrcE, MemWriteE, ALUSrcE, RegWriteE,
    output [2:0] ALUcontrolE,
    output [4:0] RdE,
    output [31:0] RD1E, RD2E,
    output [31:0] PCE, ImmExtE, PCPlus4E
);
  
    reg [31:0] PCD_reg, ImmExtD_reg, PCPlus4D_reg;
    reg [31:0] RD1D_reg, RD2D_reg;
    reg [2:0] ALUcontrolD_reg;
    reg [4:0] RdD_reg;
    reg BranchD_reg, ResultSrcD_reg, MemWriteD_reg, ALUSrcD_reg, RegWriteD_reg;
    
    wire [31:0] RD1D, ImmExtD, RD2D;
    wire [2:0] ALUcontrolD;
    wire [1:0] ImmSrcD;
    wire BranchD, ResultSrcD, MemWriteD, ALUSrcD, RegWriteD;
    
    
    // Control_unit
    Control_unit control_unit(
                    .op(InstrD[6:0]), 
                    .funct7(InstrD[31:25]), 
                    .funct3(InstrD[14:12]), 
                    .Branch(BranchD), 
                    .ResultSrc(ResultSrcD), 
                    .MemWrite(MemWriteD), 
                    .ALUSrc(ALUSrcD), 
                    .RegWrite(RegWriteD), 
                    .ImmSrc(ImmSrcD), 
                    .ALUcontrol(ALUcontrolD)
                    );
    
    // Register file        
    Register_file register_file(
                    .A1(InstrD[19:15]), 
                    .A2(InstrD[24:20]), 
                    .A3(RDW), 
                    .clk(clk), 
                    .rst(rst), 
                    .WE3(RegWriteW), 
                    .WD3(ResultW), 
                    .RD1(RD1D), 
                    .RD2(RD2D)
                    );
     
     
    // Sign Extend
    Sign_Extend sign_extend(
                    .in(InstrD), 
                    .ImmSrc(ImmSrcD),
                    .ImmExt(ImmExtD)
                    );
                    
    
    always @(posedge clk or posedge rst)
      begin 
        if(rst)
          begin 
            PCD_reg <= 32'h00000000;
            ImmExtD_reg <= 32'h00000000;
            PCPlus4D_reg <= 32'h00000000;
            RD1D_reg <= 32'h00000000;
            RD2D_reg <= 32'h00000000;
            ALUcontrolD_reg <= 3'b000;
            RdD_reg <= 5'b00000;
            BranchD_reg <= 1'b0;
            ResultSrcD_reg <= 1'b0; 
            MemWriteD_reg <= 1'b0;
            ALUSrcD_reg <= 1'b0;
            RegWriteD_reg <= 1'b0; 
          end     
          else begin 
            PCD_reg <= PCD;
            ImmExtD_reg <= ImmExtD;
            PCPlus4D_reg <= PCPlus4D;
            RD1D_reg <= RD1D;
            RD2D_reg <= RD2D;
            ALUcontrolD_reg <= ALUcontrolD;
            RdD_reg <= InstrD[11:7];
            BranchD_reg <= BranchD;
            ResultSrcD_reg <= ResultSrcD; 
            MemWriteD_reg <= MemWriteD;
            ALUSrcD_reg <= ALUSrcD;
            RegWriteD_reg <= RegWriteD;
          end 
      end 
      
      
    assign BranchE =  BranchD_reg;
    assign ResultSrcE =  ResultSrcD_reg;
    assign MemWriteE =  MemWriteD_reg;
    assign ALUSrcE =  ALUSrcD_reg;
    assign RegWriteE =  RegWriteD_reg;
    assign ALUcontrolE =  ALUcontrolD_reg;
    assign RdE = RdD_reg;
    assign RD1E = RD1D_reg;
    assign RD2E =  RD2D_reg;
    assign PCE =  PCD_reg;
    assign ImmExtE =  ImmExtD_reg;
    assign PCPlus4E = PCPlus4D_reg;
    
endmodule  