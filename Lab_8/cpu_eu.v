`timescale 1ns / 1ps
/*==================================================================================
 File Name:    cpu_eu.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    5/3/17
 
 Purpose:      This is the cpu_eu module. Its purpose to instantiate all of the
               modules that enable functionality.
               
==================================================================================*/
module cpu_eu(       clk, reset, rw_en, s_sel, adr_sel, ir_ld,
                     pc_ld, pc_inc, pc_sel,
                     W_Adr, R_Adr, S_Adr, Alu_Op, D_in,     
                     IR_out, ALU_Status, Address, D_out);   
               
   input             clk,   reset, rw_en,  s_sel, adr_sel,
                     ir_ld, pc_ld, pc_inc, pc_sel ;
                     
   input     [2:0]   W_Adr, R_Adr, S_Adr ;
   input     [3:0]   Alu_Op ;                  
   input    [15:0]   D_in ;
   
   output   [15:0]   Address, D_out, IR_out ;
   output    [2:0]   ALU_Status ;
   
   wire              C, N, Z ;
   wire     [15:0]   reg_out_wire, alu_out_wire, pc_out_wire,
                     pc_mux, add_bit16, sign_ext;
   
    /****************************   ASSIGNMENTS   *******************************/
      assign ALU_Status =   {N,Z,C};
      assign D_out      =   alu_out_wire ;
      assign Address    =   (adr_sel == 1'b1) ? reg_out_wire : pc_out_wire ;  
      assign pc_mux     =   (pc_sel == 1'b1) ? alu_out_wire : add_bit16 ; 
      assign sign_ext   =   {{8{IR_out[7]}}, IR_out[7:0]} ;
      assign add_bit16  =   pc_out_wire + sign_ext ;
      
    /****************************  INTEGER DATAPATH  ****************************/
      integer_datapath 
                  datapath(.clk     (clk),  
                           .reset   (reset),
                           .DS      (D_in),
                           .W_en    (rw_en),    
                           .S_adr   (S_Adr),    
                           .R_adr   (R_Adr),   
                           .W_adr   (W_Adr),  
                           .ALU_OP  (Alu_Op),   
                           .S_sel   (s_sel),  
                           .C       (C),  
                           .N       (N),   
                           .Z       (Z),  
                           .Reg_out (reg_out_wire), 
                           .Alu_out (alu_out_wire) 
                          );
                          
    /****************************   PROGRAM COUNTER   ****************************/
         PC program_counter(.clk(clk), 
                            .reset(reset), 
                            .pc_ld(pc_ld),
                            .pc_inc(pc_inc),
                            .pc_in(pc_mux),
                            .pc_out(pc_out_wire)
                           );
                           
    /**************************  INSTRUCTION REGISTER  ****************************/
         IR instruction_reg(.clk(clk), 
                            .reset(reset), 
                            .ir_ld(ir_ld), 
                            .ir_in(D_in), 
                            .ir_out(IR_out) 
                           );
endmodule
