`timescale 1ns / 1ps
/*==================================================================================
 File Name:    cu.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    May 10, 2017

 Purpose:      The Control Unit is a "Moore" Finite State Machine that implements
               the major cycles for fetching and executing instructions for the 301
               16-bit RISC Processor.
==================================================================================*/
 module cu   (clk, reset, IR, ALU_Status,                       //control unit inputs
             W_Adr, R_Adr, S_Adr, adr_sel, s_sel, pc_ld,     //these are the control
             pc_inc, pc_sel, ir_ld, mw_en, rw_en, alu_op,       //word output fields
             status);                                                 // LED outputs
             
//INPUTS & OUTPUTS =================================================================
   input        clk, reset ;                                       //clock and reset
   input [15:0] IR;                                     //instruction register input
   input [2:0]  ALU_Status;                                        //datapath status
   
   output       adr_sel, s_sel ;                                //mux select outputs
   output       pc_ld, pc_inc, pc_sel, ir_ld;   //pc load, pcinc, pc select, ir load
   output       mw_en, rw_en ;                   //memory_write, register_file write
   output [2:0] W_Adr, R_Adr, S_Adr ;                 //register file address ouputs
   output [3:0] alu_op ;                                         //ALU opcode output
   output [7:0] status ;                    //8 LED outputs to display current state
   
//DATA STRUCTURES ==================================================================
   reg   [2:0] W_Adr, R_Adr, S_Adr; 
   reg         adr_sel, s_sel ;
   reg         pc_ld, pc_inc ;
   reg         pc_sel, ir_ld ;
   reg         mw_en, rw_en ;
   reg   [3:0] alu_op ;
   
   reg   [4:0] state ;
   reg   [4:0] nextstate ;
   reg   [7:0] status ;
   reg         ps_N, ps_Z, ps_C ,
               ns_N, ns_Z, ns_C ;
   
   parameter   RESET = 0,  FETCH = 1,  DECODE = 2,
               ADD = 3,    SUB = 4,    CMP = 5,    MOV = 6,
               INC = 7,    DEC = 8,    SHL = 9,    SHR = 10,
               LOAD = 11,  STO = 12,   LDI = 13,   
               JE = 14,    JNE = 15,   JC = 16,    JMP = 17,
               HALT = 18,
               ILLEGAL_OP = 31 ;
   
//CONTROL UNIT SEQUENCER ===========================================================
   //synchronous state register assignment
   always @(posedge clk or posedge reset)
      if (reset)
         state = RESET ;
      else
         state = nextstate;
   //synchronous flags register assignment
   always @(posedge clk or posedge reset)
      if (reset)
         {ps_N, ps_Z, ps_C} = 3'b0 ;
      else
         {ps_N, ps_Z, ps_C} = {ns_N, ns_Z, ns_C} ;
   
   //combinational logic section for both next state logic 
   //and control word outputs for cpu_execution_unit and memory
   always @ (state)
      case (state)
      RESET :  begin // PC = 00h; {nf, zf cf} = 3'b0 -- LED patern = 1111_1111
               W_Adr   = 3'b000;     R_Adr  = 3'b000;     S_Adr  = 3'b000 ;
               adr_sel = 1'b0  ;     s_sel  = 1'b0  ;     pc_sel = 1'b0   ;
               pc_ld   = 1'b0  ;     pc_inc = 1'b0  ;     ir_ld  = 1'b0   ;
               mw_en   = 1'b0  ;     rw_en  = 1'b0  ;     alu_op = 4'h0   ;
               
               {ns_N, ns_Z, ns_C} = 3'b0;
               status = 8'hFF;
               nextstate = FETCH;
               end
              
      FETCH :  begin // IR <-- M[PC], PC <-- PC + 1 -- LED patern = 1000_0000
               W_Adr   = 3'b000;     R_Adr  = 3'b000;     S_Adr  = 3'b000 ;
               adr_sel = 1'b0  ;     s_sel  = 1'b0  ;     pc_sel = 1'b0   ;
               pc_ld   = 1'b0  ;     pc_inc = 1'b1  ;     ir_ld  = 1'b1   ;
               mw_en   = 1'b0  ;     rw_en  = 1'b0  ;     alu_op = 4'h0   ;
               
               {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
               status = 8'h80;
               nextstate = DECODE;
               end
              
      DECODE : begin // NS <-- case(IR[15:9]) -- LED patern = 1100_0000
               W_Adr   = 3'b000;     R_Adr  = 3'b000;     S_Adr  = 3'b000 ;
               adr_sel = 1'b0  ;     s_sel  = 1'b0  ;     pc_sel = 1'b0   ;
               pc_ld   = 1'b0  ;     pc_inc = 1'b0  ;     ir_ld  = 1'b0   ;
               mw_en   = 1'b0  ;     rw_en  = 1'b0  ;     alu_op = 4'b0   ;
               
               {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
               status = 8'hC0;
                  case (IR[15:9])
                     7'h70  :   nextstate = ADD  ;
                     7'h71  :   nextstate = SUB  ;
                     7'h72  :   nextstate = CMP  ;
                     7'h73  :   nextstate = MOV  ;
                     7'h74  :   nextstate = SHL  ;
                     7'h75  :   nextstate = SHR  ;
                     7'h76  :   nextstate = INC  ;
                     7'h77  :   nextstate = DEC  ;
                     7'h78  :   nextstate = LOAD ;
                     7'h79  :   nextstate = STO  ;
                     7'h7a  :   nextstate = LDI  ;
                     7'h7b  :   nextstate = HALT ;
                     7'h7c  :   nextstate = JE   ;
                     7'h7d  :   nextstate = JNE  ;
                     7'h7e  :   nextstate = JC   ;
                     7'h7f  :   nextstate = JMP  ;
                     default:   nextstate = ILLEGAL_OP ;
                  endcase
               end
               
               //R[ir(8:6)] <-- R[ir(5:3)] + R[ir(2:0)]
               //LED patern = {ps_N,ps_Z,ps_C,5'b00000}
               ADD : begin
                     W_Adr   = IR[8:6];    R_Adr  = IR[5:3];    S_Adr  = IR[2:0] ;
                     adr_sel = 1'b0  ;     s_sel  = 1'b0   ;    pc_sel = 1'b0    ;
                     pc_ld   = 1'b0  ;     pc_inc = 1'b0   ;    ir_ld  = 1'b0    ;
                     mw_en   = 1'b0  ;     rw_en  = 1'b1   ;    alu_op = 4'b0100 ;
                     
                     {ns_N, ns_Z, ns_C} = ALU_Status;
                     status = {ps_N, ps_Z, ps_C, 5'b00000};
                     nextstate = FETCH;
                     end
                     
               //R[ir(8:6)] <-- R[ir(5:3)] - R[ir(2:0)]
               //LED patern = {ps_N,ps_Z,ps_C,5'b00001}
               SUB : begin
                     W_Adr   = IR[8:6];    R_Adr  = IR[5:3];    S_Adr  = IR[2:0] ;
                     adr_sel = 1'b0   ;     s_sel  = 1'b0  ;    pc_sel = 1'b0    ;
                     pc_ld   = 1'b0   ;     pc_inc = 1'b0  ;    ir_ld  = 1'b0    ;
                     mw_en   = 1'b0   ;     rw_en  = 1'b1  ;    alu_op = 4'b0101 ;
                     
                     {ns_N, ns_Z, ns_C} = ALU_Status;
                     status = {ps_N, ps_Z, ps_C, 5'b00001};
                     nextstate = FETCH;
                     end
                     
               //R[ir(5:3)] - R[ir(2:0)]
               //LED patern = {ps_N,ps_Z,ps_C,5'b00010}
               CMP : begin
                     W_Adr   = 3'b000;     R_Adr  = IR[5:3];     S_Adr  = IR[2:0] ;
                     adr_sel = 1'b0  ;     s_sel  = 1'b0   ;     pc_sel = 1'b0    ;
                     pc_ld   = 1'b0  ;     pc_inc = 1'b0   ;     ir_ld  = 1'b0    ;
                     mw_en   = 1'b0  ;     rw_en  = 1'b0   ;     alu_op = 4'b0101 ;
                     
                     {ns_N, ns_Z, ns_C} = ALU_Status;
                     status = {ps_N, ps_Z, ps_C, 5'b00010};
                     nextstate = FETCH;
                     end
                     
               //R[ir(8:6)] <-- R[ir(2:0)] >> 1
               //LED patern = {ps_N,ps_Z,ps_C,5'b00111}
               MOV : begin
                     W_Adr   = IR[8:6];    R_Adr  = 3'b000;     S_Adr  = IR[2:0] ;
                     adr_sel = 1'b0   ;    s_sel  = 1'b0  ;     pc_sel = 1'b0    ;
                     pc_ld   = 1'b0   ;    pc_inc = 1'b0  ;     ir_ld  = 1'b0    ;
                     mw_en   = 1'b0   ;    rw_en  = 1'b1  ;     alu_op = 4'b0    ;
                     {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
                     
                     status = {ps_N,ps_Z,ps_C,5'b00111};
                     nextstate = FETCH;
                     end
                     
               //R[ir(8:6)] <-- R[ir(2:0)] << 1
               //LED patern = {ps_N,ps_Z,ps_C,5'b00100}
               SHL : begin
                     W_Adr   = IR[8:6];    R_Adr  = 3'b000;     S_Adr  = IR[2:0] ;
                     adr_sel = 1'b0   ;    s_sel  = 1'b0  ;     pc_sel = 1'b0    ;
                     pc_ld   = 1'b0   ;    pc_inc = 1'b0  ;     ir_ld  = 1'b0    ;
                     mw_en   = 1'b0   ;    rw_en  = 1'b1  ;     alu_op = 4'b0111 ;
                     
                     {ns_N, ns_Z, ns_C} = ALU_Status;
                     status = {ps_N,ps_Z,ps_C,5'b00100};
                     nextstate = FETCH;
                     end
                     
               //R[ir(8:6)] <-- R[ir(2:0)] >> 1
               //LED patern = {ps_N,ps_Z,ps_C,5'b00101}
               SHR : begin
                     W_Adr   = IR[8:6];    R_Adr  = 3'b000;     S_Adr  = IR[2:0] ;
                     adr_sel = 1'b0   ;    s_sel  = 1'b0  ;     pc_sel = 1'b0    ;
                     pc_ld   = 1'b0   ;    pc_inc = 1'b0  ;     ir_ld  = 1'b0    ;
                     mw_en   = 1'b0   ;    rw_en  = 1'b1  ;     alu_op = 4'b0110 ;
                     
                     {ns_N, ns_Z, ns_C} = ALU_Status;
                     status = {ps_N,ps_Z,ps_C,5'b00101};
                     nextstate = FETCH;
                     end
                     
               //R[ir(8:6)] <-- R[ir(2:0) + 1
               //LED patern = {ps_N,ps_Z,ps_C,5'b00110}
               INC : begin
                     W_Adr   = IR[8:6];    R_Adr  = 3'b000;     S_Adr  = IR[2:0] ;
                     adr_sel = 1'b0   ;    s_sel  = 1'b0  ;     pc_sel = 1'b0    ;
                     pc_ld   = 1'b0   ;    pc_inc = 1'b0  ;     ir_ld  = 1'b0    ;
                     mw_en   = 1'b0   ;    rw_en  = 1'b1  ;     alu_op = 4'b0010 ;
                     
                     {ns_N, ns_Z, ns_C} = ALU_Status;
                     status = {ps_N,ps_Z,ps_C,5'b00110};
                     nextstate = FETCH;
                     end
                     
               //R[ir(8:6)] <-- R[ir(2:0)] - 1
               //LED patern = {ps_N,ps_Z,ps_C,5'b0111}
               DEC : begin
                     W_Adr   = IR[8:6];    R_Adr  = 3'b000;     S_Adr  = IR[2:0] ;
                     adr_sel = 1'b0   ;    s_sel  = 1'b0  ;     pc_sel = 1'b0    ;
                     pc_ld   = 1'b0   ;    pc_inc = 1'b0  ;     ir_ld  = 1'b0    ;
                     mw_en   = 1'b0   ;    rw_en  = 1'b1  ;     alu_op = 4'b0011 ;
                     
                     {ns_N, ns_Z, ns_C} = ALU_Status;
                     status = {ps_N,ps_Z,ps_C,5'b0111};
                     nextstate = FETCH;
                     end





                     
              //R[ir(8:6)] <-- M[ R[ir(2:0)] ]
              //LED patern = {ps_N,ps_Z,ps_C,5'b01000}  
              LOAD : begin
                     W_Adr   = IR[8:6];    R_Adr  = IR[2:0];    S_Adr  = 3'b000 ;
                     adr_sel = 1'b1   ;    s_sel  = 1'b1   ;    pc_sel = 1'b0   ;
                     pc_ld   = 1'b0   ;    pc_inc = 1'b0   ;    ir_ld  = 1'b0   ;
                     mw_en   = 1'b0   ;    rw_en  = 1'b1   ;    alu_op = 4'b0   ;
                     
                     {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
                     status = {ps_N,ps_Z,ps_C,5'b01000};
                     nextstate = FETCH;
                     end
                     
               //M[ R[ir(8:6)] ] <-- R[ir(2:0)]
               //LED patern = {ps_N,ps_Z,ps_C,5'b01001}
               STO : begin
                     W_Adr   = 3'b000;     R_Adr  = IR[8:6];    S_Adr  = IR[2:0];
                     adr_sel = 1'b1  ;     s_sel  = 1'b0   ;    pc_sel = 1'b0   ;
                     pc_ld   = 1'b0  ;     pc_inc = 1'b0   ;    ir_ld  = 1'b0   ;
                     mw_en   = 1'b1  ;     rw_en  = 1'b0   ;    alu_op = 4'b0   ;
                     
                     {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
                     status = {ps_N,ps_Z,ps_C,5'b01001};
                     nextstate = FETCH;
                     end
                     
               //R[ir(8:6)] <-- M[PC],    PC <-- PC + 1
               //LED patern = {ps_N,ps_Z,ps_C,5'b01010}
               LDI : begin
                     //sets W_adr to the proper register location, pc +1
                     W_Adr   = IR[8:6];    R_Adr  = 3'b000;     S_Adr  = 3'b000 ;
                     adr_sel = 1'b0   ;    s_sel  = 1'b1  ;     pc_sel = 1'b0   ;
                     pc_ld   = 1'b0   ;    pc_inc = 1'b1  ;     ir_ld  = 1'b0   ;
                     mw_en   = 1'b0   ;    rw_en  = 1'b1  ;     alu_op = 4'b0   ;
                     
                     {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
                     status = {ps_N,ps_Z,ps_C,5'b01010};
                     nextstate = FETCH;
                     end
                     
               //if (pc_z=1) PC <-- PC + se_IR[7:0]      else PC <-- PC
               //LED patern = {ps_N,ps_Z,ps_C,5'b01100}
                JE : begin
                     W_Adr   = 3'b000;     R_Adr  = 3'b000;     S_Adr  = 3'b000 ;
                     adr_sel = 1'b0  ;     s_sel  = 1'b0  ;     pc_sel = 1'b0   ;
                     pc_ld   = ps_Z  ;     pc_inc = 1'b0  ;     ir_ld  = 1'b0   ;
                     mw_en   = 1'b0  ;     rw_en  = 1'b0  ;     alu_op = 4'b0   ;
                     
                     {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
                     status = {ps_N,ps_Z,ps_C,5'b01100};
                     nextstate = FETCH;
                     end





               //if (pc_z=0) PC <-- PC + se_IR[7:0]      else PC <-- PC
               //LED patern = {ps_N, ps_Z, ps_C, 5'b01101}
               JNE : begin
                     W_Adr   = 3'b000;     R_Adr  = 3'b000;     S_Adr  = 3'b000 ;
                     adr_sel = 1'b0  ;     s_sel  = 1'b0  ;     pc_sel = 1'b0   ;
                     pc_ld   = !ps_Z ;     pc_inc = 1'b0  ;     ir_ld  = 1'b0   ;
                     mw_en   = 1'b0  ;     rw_en  = 1'b0  ;     alu_op = 4'b0   ;
                     
                     {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
                     status = {ps_N, ps_Z, ps_C, 5'b01101};
                     nextstate = FETCH;
                     end
                
                //if (ps_C = 1) PC <-- PC + se_IR[7:0]   else PC <-- PC  
                //LED patern = {ps_N,ps_Z,ps_C,5'b01110}
                JC : begin
                     W_Adr   = 3'b000;     R_Adr  = 3'b000;     S_Adr  = 3'b000 ;
                     adr_sel = 1'b0  ;     s_sel  = 1'b0  ;     pc_sel = 1'b0   ;
                     pc_ld   = ps_C  ;     pc_inc = 1'b0  ;     ir_ld  = 1'b0   ;
                     mw_en   = 1'b0  ;     rw_en  = 1'b0  ;     alu_op = 4'b0   ;
                     
                     {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
                     status = {ps_N,ps_Z,ps_C,5'b01110};
                     nextstate = FETCH;
                     end
                     
               //PC <-- R[ir(2:0)]
               //LED pattern = {ps_N,ps_Z,ps_C, 5'b01111}
               JMP : begin
                     W_Adr   = 3'b000;     R_Adr  = 3'b000;     S_Adr  = IR[2:0];
                     adr_sel = 1'b0  ;     s_sel  = 1'b0  ;     pc_sel = 1'b1   ;
                     pc_ld   = 1'b1  ;     pc_inc = 1'b0  ;     ir_ld  = 1'b0   ;
                     mw_en   = 1'b0  ;     rw_en  = 1'b0  ;     alu_op = 4'b0   ;
                     
                     {ns_N, ns_Z, ns_C} = {ps_N, ps_Z, ps_C};
                     status = {ps_N,ps_Z,ps_C, 5'b01111};
                     nextstate = FETCH;
                     end

              //Default Control Word 
              //LED pattern = {ps_N,ps_Z,ps_C, 5'b01011}
              HALT : begin
                     W_Adr   = 3'b000;     R_Adr  = 3'b000;     S_Adr  = 3'b000 ;
                     adr_sel = 1'b0  ;     s_sel  = 1'b0  ;     pc_sel = 1'b0   ;
                     pc_ld   = 1'b0  ;     pc_inc = 1'b0  ;     ir_ld  = 1'b0   ;
                     mw_en   = 1'b0  ;     rw_en  = 1'b0  ;     alu_op = 4'h0   ;
                     
                     {ns_N, ns_Z, ns_C} = 3'b0;
                     status = {ps_N,ps_Z,ps_C, 5'b01011};
                     nextstate = HALT;
                     end

       




       //Default Control Word -- LED pattern = 1111_0000
        ILLEGAL_OP : begin
                     W_Adr   = 3'b000;     R_Adr  = 3'b000;     S_Adr  = 3'b000 ;
                     adr_sel = 1'b0  ;     s_sel  = 1'b0  ;     pc_sel = 1'b0   ;
                     pc_ld   = 1'b0  ;     pc_inc = 1'b0  ;     ir_ld  = 1'b0   ;
                     mw_en   = 1'b0  ;     rw_en  = 1'b0  ;     alu_op = 4'h0   ;
                     
                     {ns_N, ns_Z, ns_C} = 3'b0;
                     status = 8'hF0;
                     nextstate = ILLEGAL_OP;
                     end
               endcase

endmodule
