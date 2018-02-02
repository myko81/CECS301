`timescale 1ns / 1ps
/*==================================================================================
 File Name:    decoder_3to8.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    March 22, 2017

 Purpose:      When the enable input is true and matches the 3 bit in input, the y
               output will send a the 8-bit signal corresponding to the case 
               statement where all but one bit are zeroes and the one remaining bit
               is a one.
==================================================================================*/
module decoder_3to8(in, en, y);
   input          en ;
   input    [2:0] in ;
   output   [7:0] y ;
   
   reg [7:0] y;
   
   always @ (*) begin
        case({in, en})
            4'b000_1 : y = 8'b00000001 ;         
            4'b001_1 : y = 8'b00000010 ;
            4'b010_1 : y = 8'b00000100 ;
            4'b011_1 : y = 8'b00001000 ;
            4'b100_1 : y = 8'b00010000 ;
            4'b101_1 : y = 8'b00100000 ;
            4'b110_1 : y = 8'b01000000 ;
            4'b111_1 : y = 8'b10000000 ;
            
            default  : y = 8'b00000000 ;
            
         endcase
   end 

endmodule
