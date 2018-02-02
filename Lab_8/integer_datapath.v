`timescale 1ns / 1ps
/*==================================================================================
 File Name:    integer_datapath.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    April 24, 2017

 Purpose:      The integer datapath consists of a register file, an ALU and a mux.
               This is the integer datapath module. Its purpose is to instantiate
               all of the modules that enable functionality.
==================================================================================*/
module integer_datapath(clk,  reset,   W_en,    W_adr,   R_adr,  S_adr, 
                        ALU_OP,  DS,   S_sel,   C,  N,   Z,  Reg_out, Alu_out) ;
                        
   input             clk, reset, W_en, S_sel ;
   input     [2:0]   W_adr, S_adr, R_adr ;
   input     [3:0]   ALU_OP ;
   input    [15:0]   DS ;
   
   output            C, N, Z ;
   output   [15:0]   Reg_out, Alu_out ;
   
    
   wire [15:0] r_wire, s_wire, y ;
   
   assign  y = S_sel ? DS : s_wire ; // mux when sel = 1, y = DS ; sel=0, y = S
   assign Reg_out = r_wire ;
   
   /******************** INSTANTIAION OF THE REGISTER FILE **********************/
   register_file
      reg_file(.clk(clk), 
               .reset(reset), 
               .we(W_en), 
               .W(Alu_out), 
               .w_adr(W_adr), 
               .r_adr(R_adr), 
               .s_adr(S_adr), 
               .R(r_wire), 
               .S(s_wire)) ;

   /************************* INSTANTIAION OF THE ALU ***************************/
   alu16
      alu_16(.R(r_wire), 
             .S(y), 
             .Alu_Op(ALU_OP), 
             .Y(Alu_out), 
             .N(N), 
             .Z(Z), 
             .C(C)) ;

endmodule 