`timescale 1ns / 1ps
/*==================================================================================
 File Name:    IR.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    April 24, 2017

 Purpose:      The instruction register module. Its purpose is to output 16-bits
               of information when the ir_ld is true. This info is distributed
               between Alu_Op, W_adr, R_adr, and S_adr.
==================================================================================*/
module IR(clk, reset, ir_ld, ir_in, ir_out) ;
   input                clk, reset, ir_ld ;
   input       [15:0]   ir_in  ;
   output reg  [15:0]   ir_out ;
   
   always @ (posedge clk, posedge reset)
      if (reset)
            ir_out <= 16'b0 ;
      
      else 
         case(ir_ld)
            1'b1 : ir_out <= ir_in    ;
            1'b0 : ir_out <= ir_out   ;
            default : ir_out <= 16'h0000 ;
         endcase
         
endmodule
