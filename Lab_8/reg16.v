`timescale 1ns / 1ps
/*==================================================================================
 File Name:    reg16.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    March 22, 2017

 Purpose:      This is the 16 bit register module with an asynchronous reset and a
               synchronous load. It contains two output ports, DA and DB, that are
               16 bits each. Both output ports have tri-state outputs that are
               controlled by the output-enable A and B.
==================================================================================*/

module reg16(clk, reset, ld, Din, DA, DB, oeA, oeB) ;
   input             clk, reset, ld, oeA, oeB ;
   input    [15:0]   Din ;
   output   [15:0]   DA, DB ;
   reg      [15:0]   Dout ;
   
   // behavioral section for writing to the register
   always @(posedge clk or posedge reset)
      if (reset)
         Dout <= 16'b0;
      else
         if (ld)
              Dout <= Din ;
         else Dout <= Dout ;
         
   // conditional continuous assignments for reading the register
   assign DA = oeA ? Dout : 16'hz;
   assign DB = oeB ? Dout : 16'hz;

endmodule
