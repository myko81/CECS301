`timescale 1ns / 1ps
/*==================================================================================
 File Name:    PC.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    April 24, 2017

 Purpose:      The program counter module. Its purpose is to output a count
               up or load pc_in to pc_out. This is executed when the inputs have
               matched the case statement.
==================================================================================*/
module PC(clk, reset, pc_ld, pc_inc, pc_in, pc_out) ;
   input                clk, reset, pc_ld, pc_inc ;
   input       [15:0]   pc_in ;
   output reg  [15:0]   pc_out ;
   
   always @ (posedge clk, posedge reset)
      if (reset)
            pc_out <= 16'b0 ;
            
        else case ({pc_ld, pc_inc})
               2'b01   : pc_out <= pc_out + 1 ;   // incrementing pc reg by 1
               2'b10   : pc_out <= pc_in      ;   // load pc_in to pc_out
               default : pc_out <= pc_out     ;   // pc_out gets pc_out
        endcase
        
endmodule
