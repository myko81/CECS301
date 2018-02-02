`timescale 1ns / 1ps
/*==================================================================================
 File Name:    hex_to_7segment.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    March 13, 2017

 Purpose:      This module is the decoder for the seven segment display.
==================================================================================*/
module hex_to_7segment(hex, cathode) ;
      input  [3:0] hex ; 
      
      output reg [7:0] cathode ;

     always @(*)
      begin
      /* the 8 bits is mapped to each segment with the MSB starting dp.
         The 8 bits are in the represent the following LED segments in this order:
         
         dp, a, b, c, d, e, f, g
         
         They are wired active low. A one represents an OFF LED and a zero an ON. */
    
         case(hex)
            4'b0000: cathode  =  8'b10000001 ; // 0
            4'b0001: cathode  =  8'b11001111 ; // 1
            4'b0010: cathode  =  8'b10010010 ; // 2
            4'b0011: cathode  =  8'b10000110 ; // 3
            4'b0100: cathode  =  8'b11001100 ; // 4
            4'b0101: cathode  =  8'b10100100 ; // 5
            4'b0110: cathode  =  8'b10100000 ; // 6
            4'b0111: cathode  =  8'b10001111 ; // 7
            4'b1000: cathode  =  8'b10000000 ; // 8
            4'b1001: cathode  =  8'b10000100 ; // 9
            4'b1010: cathode  =  8'b10001000 ; // A
            4'b1011: cathode  =  8'b11100000 ; // B
            4'b1100: cathode  =  8'b10110001 ; // C
            4'b1101: cathode  =  8'b11000010 ; // D
            4'b1110: cathode  =  8'b10110000 ; // E
            4'b1111: cathode  =  8'b10111000 ; // F
            default: cathode  =  8'b11111110 ; // -
         endcase
      end

endmodule 