`timescale 1ns / 1ps
/*==================================================================================
 File Name:    processor.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    5/3/17

 Purpose:      The processor module instantiates the CPU EU and the CU FSM and
               interconnects them using wires and three input and four output ports.
==================================================================================*/
module processor (clk, reset, d_in, address, d_out, mw_en, status);
   input           clk, reset ;
   input    [15:0] d_in ;
   output   [15:0] d_out, address ;
   output    [7:0] status ;
   output          mw_en ;
   
   wire            s_sel, adr_sel, ir_ld, pc_ld, pc_inc, pc_sel, rw_en ;
   wire     [2:0]  W_Adr, R_Adr, S_Adr, ALU_Status ;
   wire     [3:0]  Alu_Op ;
   wire    [15:0]  IR_out ;

    /******************************    CPU EU    **********************************/
      cpu_eu CPU (.clk           (clk), 
                  .reset         (reset), 
                  .rw_en         (rw_en), 
                  .s_sel         (s_sel), 
                  .adr_sel       (adr_sel), 
                  .ir_ld         (ir_ld),
                  .pc_ld         (pc_ld), 
                  .pc_inc        (pc_inc), 
                  .pc_sel        (pc_sel),
                  .W_Adr         (W_Adr), 
                  .R_Adr         (R_Adr), 
                  .S_Adr         (S_Adr), 
                  .Alu_Op        (Alu_Op), 
                  .D_in          (d_in),     
                  .IR_out        (IR_out), 
                  .ALU_Status    (ALU_Status), // N, Z, C (in this order)
                  .Address       (address), 
                  .D_out         (d_out)
                 );  
            
      cu FSM     (.clk          (clk),
                  .reset        (reset), 
                  .IR           (IR_out), 
                  .ALU_Status   (ALU_Status),     
                  .W_Adr        (W_Adr), 
                  .R_Adr        (R_Adr), 
                  .S_Adr        (S_Adr), 
                  .adr_sel      (adr_sel), 
                  .s_sel        (s_sel), 
                  .pc_ld        (pc_ld),    
                  .pc_inc       (pc_inc), 
                  .pc_sel       (pc_sel), 
                  .ir_ld        (ir_ld), 
                  .mw_en        (mw_en), 
                  .rw_en        (rw_en), 
                  .alu_op       (Alu_Op),    
                  .status       (status)
                 );             

endmodule
