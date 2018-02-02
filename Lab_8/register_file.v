`timescale 1ns / 1ps
/*==================================================================================
 File Name:    register_file.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    March 22, 2017

 Purpose:      This is the register file module. Its purpose is to instantiate the
               reg16 module eight times. These eight instantiations are wired to
               three instantiations of the 3 to 8 decoder module.
==================================================================================*/
module register_file(clk, reset, we, W, w_adr, r_adr, s_adr, R, S);
   input             clk, reset, we ;
   input    [15:0]   W ;
   input    [2:0]    w_adr, r_adr, s_adr ;
   
   output   [15:0]   R, S ;
   wire     [7:0]    ld_wire, oeA_wire, oeB_wire;
   
   /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         decoder_3to8 - connected to the reg16 instantiations. Decoder_1 and
                        decoder_2 enable is mapped to logic level "1" and
                        decoder_0 enable is mappted to input we. Input we is
                        mappted to button dwn on the Nexsys 4.             
     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
      decoder_3to8
         decoder_0(
            .in      (w_adr), 
            .en      (we), 
            .y       (ld_wire)
         ),
         decoder_1(
            .in      (r_adr), 
            .en      (1'b1), 
            .y       (oeA_wire)
         ),
         decoder_2(
            .in      (s_adr), 
            .en      (1'b1), 
            .y       (oeB_wire)
         );
         
   /*~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         reg16 - this module is instantiated eight times. It is conntected to
                  the decoders by wires.             
     ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~*/
   reg16
      reg0(
         .clk     (clk), 
         .reset   (reset), 
         .ld      (ld_wire[0]), 
         .Din     (W), 
         .DA      (R), 
         .DB      (S), 
         .oeA     (oeA_wire[0]), 
         .oeB     (oeB_wire[0]) ) ,
         
      reg1(
         .clk     (clk), 
         .reset   (reset), 
         .ld      (ld_wire[1]), 
         .Din     (W), 
         .DA      (R), 
         .DB      (S), 
         .oeA     (oeA_wire[1]), 
         .oeB     (oeB_wire[1])
      ) ,
         
      reg2(
         .clk     (clk), 
         .reset   (reset), 
         .ld      (ld_wire[2]), 
         .Din     (W), 
         .DA      (R), 
         .DB      (S), 
         .oeA     (oeA_wire[2]), 
         .oeB     (oeB_wire[2])
      ) ,
         
      reg3(
         .clk     (clk), 
         .reset   (reset), 
         .ld      (ld_wire[3]), 
         .Din     (W), 
         .DA      (R), 
         .DB      (S), 
         .oeA     (oeA_wire[3]), 
         .oeB     (oeB_wire[3])
      ) ,
         
      reg4(
         .clk     (clk), 
         .reset   (reset), 
         .ld      (ld_wire[4]), 
         .Din     (W), 
         .DA      (R), 
         .DB      (S), 
         .oeA     (oeA_wire[4]), 
         .oeB     (oeB_wire[4])
      ) ,
         
      reg5(
         .clk     (clk), 
         .reset   (reset), 
         .ld      (ld_wire[5]), 
         .Din     (W), 
         .DA      (R), 
         .DB      (S), 
         .oeA     (oeA_wire[5]), 
         .oeB     (oeB_wire[5])
      ) ,
      
      
      
      reg6(
         .clk     (clk), 
         .reset   (reset), 
         .ld      (ld_wire[6]), 
         .Din     (W), 
         .DA      (R), 
         .DB      (S), 
         .oeA     (oeA_wire[6]), 
         .oeB     (oeB_wire[6])
      ) ,
         
      reg7(
         .clk     (clk), 
         .reset   (reset), 
         .ld      (ld_wire[7]), 
         .Din     (W), 
         .DA      (R), 
         .DB      (S), 
         .oeA     (oeA_wire[7]), 
         .oeB     (oeB_wire[7])
      ) ;
            
endmodule
