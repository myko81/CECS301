`timescale 1ns / 1ps
/*==================================================================================
 File Name:    one_shot.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    February 20, 2017

 Purpose:      The one_shot module's purpose is to debounce the signal when the
               input d_in is pressed. Because of the nature of physical buttons,
               instead of a clean off/on sequence, the signal recieved from the
               button bounces from 0 to 1 several times before a steady reading
               is established. 
               
               To filter this "bouncing" signal, this module receives the
               unstable signal and samples ten bits, one bit at a time
               at every positive edge of the clock through the input d_in. There
               are 10 registers (q9 - q0) and at every posedge of the clock, q0
               gets the value of d_in, q1 gets the value of q0, and it continues
               in this cascading effect until all the registers have values. The
               values must match the assignment placed on output d_out. When 
               d_out's assigned criteria has been met, then a solitary signal is
               sent out through port d_out.

 Notes:        This module will be instantiated within the top_level module.
==================================================================================*/

module one_shot(clk, reset, d_in, d_out);
   // inputs
      input clk, reset ;
      input d_in ;
   
   // outputs
      output d_out;
   
   // registers
      reg q9, q8, q7, q6, q5, q4, q3, q2, q1, q0;
      
   // assignments
      assign d_out = !q9 & q8 & q7 & q6 & q5 & q4 & q3 & q2 & q1 & q0;
      /* this assignment ensures that only one solitary signal is sent
         out. By having a !q9 anded with the remaining registers, only
         makes this true for one positive edge of the clock. So even if
         the button is held down, the output is a clear "one shot" until
         the button is pressed again. */

   always @ (posedge clk, posedge reset)
      if (reset)
         {q9, q8, q7, q6, q5, q4, q3, q2, q1, q0} <= 10'b0;
      else begin
         q9 <= q8 ;     q8 <= q7 ;     q7 <= q6 ;     q6 <= q5 ;     q5 <= q4 ;
         q4 <= q3 ;     q3 <= q2 ;     q2 <= q1 ;     q1 <= q0 ;     q0 <= d_in ;
      end
 endmodule
