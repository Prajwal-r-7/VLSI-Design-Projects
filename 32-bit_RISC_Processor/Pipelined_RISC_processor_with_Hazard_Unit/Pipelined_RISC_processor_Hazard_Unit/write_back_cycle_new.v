`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Mux 

////////////////////////////////////////////////////////////////////
//                               Mux                              //
////////////////////////////////////////////////////////////////////
module mux_result(
    input [31:0] a, b, 
    input sel, 
    output [31:0] result
);

    assign result = sel ? b : a;
endmodule 


////////////////////////////////////////////////////////////////////
//                        Write back cycle                        //
////////////////////////////////////////////////////////////////////

module Write_back_cycle(
    input ResultSrcW,
    input [31:0] ALUResultW, ReadDataW,
    output [31:0] ResultW
);
    
    mux_result result_mux(
                    .a(ALUResultW), 
                    .b(ReadDataW),
                    .sel(ResultSrcW), 
                    .result(ResultW)
                    ); 
                           
endmodule
