`timescale 1ns / 1ps
/*==================================================================================
 File Name:    mem_dump.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    5/7/17

 Purpose:      Its purpose f the mem_dump module is to output a count up. This is
               executed when the input has matched the case statement.
==================================================================================*/
module mem_dump (clk, reset, step_mem, q);
   input             clk, reset, step_mem ;
   output reg [15:0] q ;
   
   
   always @(posedge clk, posedge reset)
      if (reset == 1)
         q <= 16'h00 ;
      else
         case (step_mem)
            1'h0 : q <= q ;
            1'b1 : q <= q + 1 ;
          default: q <= 16'b0 ;
         endcase

endmodule
