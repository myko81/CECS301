`timescale 1ns / 1ps

/*==================================================================================
 File Name:    pixel_clk.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    March 13, 2017

 Purpose:      The purpose of this module is reduce the speed of the clock. The 
                  incoming clock is running at a frequency of 100MHz which is much
                  too fast for our purposes. To rectify this, we use this divider
                  to slow down the clock to 480Hz.
   
  Notes:        This module will be instantiated in the display_controller module
==================================================================================*/
module pixel_clk(clk_in, reset, clk_out) ;
   
   input       clk_in, reset ;
   output reg  clk_out ;
   integer     i ;

   //*******************************************************************************
   //* The following verilog code will "divide" and incoming clock
   //* by the 32-bit decimal value specified in the "if condition"
   //* 
   //* The value of the counter that counts the incoming clock ticks
   //* is equal to [ (Incoming Freq / Outing ing Freq) / 2 ]
   //*******************************************************************************

   always @(posedge clk_in or posedge reset) begin
      if (reset == 1'b1) begin
         i = 0;
         clk_out = 0;
      end
      // got a clock, so increment the counter and
      // test to see if half a period has elapsed
      else begin
         i = i + 1;
         if (i >= 104167) begin
            clk_out = ~clk_out;
            i = 0;
         end // if
      end // else
      
   end //always

endmodule
