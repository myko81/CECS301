`timescale 1ns / 1ps
/*==================================================================================
 File Name:    display_controller.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    March 22, 2017

 Purpose:      The purpose of this module is to instantiate all the modules that
               are associated with the display controller.
   
  Notes:        This module will be instantiated in the top_level module
==================================================================================*/

module display_controller(clk, reset, seg, anode, cathode);
   input    clk, reset ;
   input    [31:0] seg ;
   output   [7:0] anode, cathode ;
   
   wire pixel_clk_wire ;  // connects the pixel clk_out to clk in pixel controller
   wire [2:0]  sel_wire ; // connects the sel_out from controller to sel_in mux.
   wire [3:0]  hex_wire ; // connects the 8-to-1 mux to the hex_to_7segment module
     
      /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         pixel_clk - divides the 100MHz clock to 480Hz so that the LED's can be
                     seen by the human eye properly        
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
         pixel_clk
            led_clock(
               .clk_in  (clk),
               .reset   (reset),
               .clk_out (pixel_clk_wire)
            );
            
      /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         pixel_controller - generates signals for the anodes of the 7 segment
                            display and also the signals for the mux select
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
         pixel_controller
            leds(
               .clk     (pixel_clk_wire), 
               .reset   (reset), 
               .anode   (anode), 
               .sel_out (sel_wire)
            );
            
      /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         ad_mux - mux used to select one data input to be decoded in the
                  hex_to_7segment module.
        ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
         ad_mux
            mux_8to1(
               .data    (seg), 
               .sel     (sel_wire), 
               .y       (hex_wire)
            );
            
            
      /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         hex_to_7segment - the module contains the code required to display the
                           seven segment cathodes with a hex representation of
                           the state of the sequence detector.
         ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
         hex_to_7segment
           cathode_0(
               .hex     (hex_wire), 
               .cathode (cathode)
            ); 

endmodule
