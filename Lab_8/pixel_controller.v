`timescale 1ns / 1ps
/*==================================================================================
 File Name:    pixel_controller.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    March 13, 2017

 Purpose:      This module is a Moore State Machine with no input controls. Instead,
               it generates the signals for the anode inputs to the 7 segment
               display and also generates the 8-to-1 mux select signals. 
 
 Notes:        This will be instantiated within the top_level module.
==================================================================================*/
module pixel_controller(clk, reset, anode, sel_out);
   input clk, reset ;
   output reg [7:0] anode ;
   output reg [2:0] sel_out ;
    
   //---------------------------------------------
   //    STATE REGISTER AND NEXT_STATE VARIABLE
   //---------------------------------------------
   
   reg [2:0] present_state;
   reg [2:0] next_state;

   //-------------------------------------------------------------------------------
   //    NEXT STATE COMBINATIONAL LOGIC
   //    (next state values can change anytime but will only be "clocked" below)
   //-------------------------------------------------------------------------------
   
   always @(present_state)  
         case(present_state)
         3'b000 : next_state = 3'b001;
         3'b001 : next_state = 3'b010;
         3'b010 : next_state = 3'b011;
         3'b011 : next_state = 3'b100;
         3'b100 : next_state = 3'b101;
         3'b101 : next_state = 3'b110;
         3'b110 : next_state = 3'b111;
         3'b111 : next_state = 3'b000;
         default: next_state = 3'b000;
      endcase
      
   //----------------------------------------------
   //    STATE REGISTER LOGIC (SEQUENTIAL LOGIC)
   //----------------------------------------------
   
   always @(posedge clk, posedge reset)
      if (reset)
         present_state <= 3'b000; 
                                  
      else
         present_state <= next_state;
   

   
         
   //-------------------------------------------------------------------------------
   //    OUTPUT COMBINATIONAL LOGIC
   //    (outputs will only change when present state changes)
   //-------------------------------------------------------------------------------
   always @ (present_state)
       case (present_state)
         3'b000 : {sel_out, anode} = 11'b000_11111110 ;
         3'b001 : {sel_out, anode} = 11'b001_11111101 ;
         3'b010 : {sel_out, anode} = 11'b010_11111011 ;
         3'b011 : {sel_out, anode} = 11'b011_11110111 ;
         3'b100 : {sel_out, anode} = 11'b100_11101111 ;
         3'b101 : {sel_out, anode} = 11'b101_11011111 ;
         3'b110 : {sel_out, anode} = 11'b110_10111111 ; 
         3'b111 : {sel_out, anode} = 11'b111_01111111 ;
         
         default: {sel_out, anode} = 11'b000_11111110 ; 
   endcase

endmodule 