`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Data Memory 
// memory State Registers

////////////////////////////////////////////////////////////////////
//                          Data memory                           //
//////////////////////////////////////////////////////////////////// 
module Data_memory(
    input clk, rst, WE,
    input [31:0] A, WD,
    output [31:0] RD 
);

    reg [31:0] data_mem [1023:0];
    
    // write 
    always @(posedge clk)
      begin  
        if(WE)
          data_mem[A] <= WD;
      end 
    
    
    // read   
    assign RD = (!WE) ? data_mem[A] : 32'h00000000;
    
    initial begin
        data_mem[0] = 32'h00000000;
        data_mem[6] = 32'h00000004;
        data_mem[15] = 32'h0000000A;
    end
endmodule 

    
////////////////////////////////////////////////////////////////////
//                          Memory cycle                          //
//////////////////////////////////////////////////////////////////// 
module Memory_cycle( 
    input clk, rst, 
    input RegWriteM, ResultSrcM, MemWriteM,
    input [31:0] ALUResultM, WriteDataM, PCPlus4M, 
    input [4:0] RdM, 
    output RegWriteW, ResultSrcW,
    output [31:0] ALUResultW, PCPlus4W, ReadDataW,
    output [4:0] RdW
    );
    
    wire [31:0] ReadDataM;
    
    reg RegWriteM_reg, ResultSrcM_reg;
    reg [31:0] ALUResultM_reg, ReadDataM_reg, PCPlus4M_reg; 
    reg [4:0] RdM_reg;
    
    
    Data_memory data_memory(
                    .clk(clk), 
                    .rst(rst), 
                    .WE(MemWriteM), 
                    .A(ALUResultM), 
                    .WD(WriteDataM),
                    .RD(ReadDataM)
                    );
                    
    
    always @(posedge clk or posedge rst)
      begin 
        if(rst)
          begin 
            RegWriteM_reg <= 1'b0;
            ResultSrcM_reg <= 1'b0;
            ALUResultM_reg <= 32'h00000000;
            ReadDataM_reg <= 32'h00000000;
            PCPlus4M_reg <= 32'h00000000;
            RdM_reg <= 5'b00000;
          end 
        else 
          begin 
            RegWriteM_reg <= RegWriteM;
            ResultSrcM_reg <= ResultSrcM;
            ALUResultM_reg <= ALUResultM;
            ReadDataM_reg <= ReadDataM;
            PCPlus4M_reg <= PCPlus4M;
            RdM_reg <= RdM; 
          end 
      end              
          
    assign RegWriteW = RegWriteM_reg;
    assign ResultSrcW = ResultSrcM_reg;
    assign ALUResultW = ALUResultM_reg;
    assign PCPlus4W = PCPlus4M_reg;
    assign ReadDataW = ReadDataM_reg;
    assign RdW = RdM_reg;        
                    
endmodule
