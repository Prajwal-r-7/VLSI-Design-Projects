`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

// PC Mux
// Program Counter 
// Adder
// Instruction Memory 
// Fetch Stage Register 

////////////////////////////////////////////////////////////////////
//                            PC Mux                              //
////////////////////////////////////////////////////////////////////           
module PC_mux( 
    input [31:0] i0, i1, 
    input sel, 
    output [31:0] y
); 

    assign y = sel ? i1 : i0;
endmodule 


////////////////////////////////////////////////////////////////////
//                        Program Counter                         //
//////////////////////////////////////////////////////////////////// 
module Program_counter(
    input clk, rst, 
    input [31:0] PC_in, 
    output reg [31:0] PC_next
);

    always @(posedge clk or posedge rst)
      begin 
        if(rst)
          PC_next <= {32{1'b0}};
        else 
          PC_next <= PC_in;
      end 
endmodule 


////////////////////////////////////////////////////////////////////
//                             Adder                              //
////////////////////////////////////////////////////////////////////
module Adder(
    input [31:0] a, b, 
    output [31:0] add
);
 
    assign add = a+b;
endmodule 


////////////////////////////////////////////////////////////////////
//                      Instruction Memory                        //
////////////////////////////////////////////////////////////////////
module Instruction_memory(
    input rst, 
    input [31:0] IM_in, 
    output [31:0] IM_out
);

    reg [31:0] mem [1023:0];
    
    initial begin
      mem[0] = 32'h00000000;
      mem[1] = 32'h00600283;   // lw x5, 6(x0)    
      mem[2] = 32'h00A08103;   // lw x2, 10(x1) 
           
      mem[3] = 32'h004283B3;   // add x7, x5, x4    
      mem[4] = 32'h402504B3;   // sub x9, x10, x2   
      mem[5] = 32'h00938633;   // add x12, x7, x9  
    end  
     
    assign IM_out =  mem[IM_in[31:2]];
    
endmodule 
 

////////////////////////////////////////////////////////////////////
//                          Fetch Cycle                           //
////////////////////////////////////////////////////////////////////   
module Fetch_cycle(
    input clk, rst, PCSrcE,
    input [31:0] PCTargetE, 
    output [31:0] InstrD, PCD, PCPlus4D
);
    wire [31:0] PCF, PCF_out, PC_plus4F, InstrF;
    
    reg [31:0] PCF_out_reg, PC_plus4F_reg, InstrF_reg;
    
    // PC mux instantiation
    PC_mux pc_mux(
                .i0(PC_plus4F), 
                .i1(PCTargetE), 
                .sel(PCSrcE), 
                .y(PCF)
                );
    
    // Program counter instantiation
    Program_counter program_counter(
                .clk(clk), 
                .rst(rst), 
                .PC_in(PCF), 
                .PC_next(PCF_out)
                );
    
    // Instruction memory instantiation
    Instruction_memory instruction_memory(
                .rst(rst), 
                .IM_in(PCF_out), 
                .IM_out(InstrF)
                );
    
    // Adder instantiation
    Adder adder(
                .a(PCF_out), 
                .b(32'h00000004), 
                .add(PC_plus4F)
                );
         
    
    // Fetch cycle reg logic       
    always @(posedge clk or posedge rst)        
      begin 
        if(rst)
          begin 
            PCF_out_reg <= 32'h00000000;
            PC_plus4F_reg <= 32'h00000000;
            InstrF_reg <= 32'h00000000;
          end 
        else 
          begin
            PCF_out_reg <= PCF_out;
            PC_plus4F_reg <= PC_plus4F;
            InstrF_reg <= InstrF;   
          end 
      end   
      
    // Assigning reg values to output port 
    assign InstrD =  InstrF_reg;
    assign PCD =   PCF_out_reg; 
    assign PCPlus4D =  PC_plus4F_reg;
    
endmodule
