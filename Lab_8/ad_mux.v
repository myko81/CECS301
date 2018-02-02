`timescale 1ns / 1ps
/*==================================================================================
 File Name:    mux_8bit.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    March 14, 2017

 Purpose:      This is a 8-to-1 mux that is used within the display controller.
               Each input receives 4-bit information and outputs one at a time 
               dictated by the input case of sel.                
==================================================================================*/
module ad_mux(data, sel, y) ;
   input    [31:0] data ;
   input    [2:0] sel ;
   output   reg [3:0] y;
   
   always @ (*) begin
      case(sel)
         3'b000 : y = data[3:0]     ;         
         3'b001 : y = data[7:4]     ; 
         3'b010 : y = data[11:8]    ; 
         3'b011 : y = data[15:12]   ; 
         3'b100 : y = data[19:16]   ; 
         3'b101 : y = data[23:20]   ; 
         3'b110 : y = data[27:24]   ; 
         3'b111 : y = data[31:28]   ; 

         default: y = 4'b0000       ;
		endcase
   end 

endmodule     
 