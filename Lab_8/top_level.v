`timescale 1ns / 1ps
/*==================================================================================
 File Name:    top_level.v
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    5/3/17

 Purpose:      This is the top level module of the project. Its purpose to 
               instantiate all of the modules that enable functionality.
==================================================================================*/
module top_level(clk_100mhz, reset, clk_step, step_mem, dump_mem,
                     status, cathode, anode) ;

   input             clk_100mhz, reset, clk_step, dump_mem, step_mem ;
   
   output   [7:0]    cathode , anode, status ;
   
   wire    [15:0]    d_in_wire, d_out_wire, address_wire, dump_counter, dump_mux ;
   wire              clk_out_wire, mem_we_wire, eu_we_wire, mw_en_wire ;
   
   assign dump_mux = (dump_mem == 1'b1) ? dump_counter : address_wire ; // SWITCH 0

    /*************************** 301 16-bit RISC Processor ************************/
      processor RISC(
                     .clk     (clk_step_wire), 
                     .reset   (reset), 
                     .d_in    (d_in_wire), 
                     .address (address_wire),
                     .d_out   (d_out_wire),
                     .mw_en   (mw_en_wire),
                     .status  (status)
                  );
                 
    /************************** DISPLAY CONTROLLER *******************************/
      display_controller disp_ctrl(
                  .clk     (clk_100mhz), 
                  .reset   (reset), 
                  .seg     ({dump_mux, d_in_wire}), 
                  .anode   (anode), 
                  .cathode (cathode)
               );
               
    /**************************   MEM DUMP COUNTER  *******************************/
      mem_dump counter(.clk         (clk_out_wire),
                       .reset       (reset), 
                       .q           (dump_counter),
                       .step_mem    (mem_dump_wire)                   
                      );
                      
    /*************************** SUPPORTING MODULES *******************************/
         clk_div                                //divides the 100MHz clock to a more
            slow_clk(.clk_in  (clk_100mhz),     //manageable 500Hz that is sent sent
                     .reset   (reset),          //            to the one_shot module
                     .clk_out (clk_out_wire)
                    );
                    
    /******************************************************************************/
         one_shot                               //debounces the signal when the step
            step_clk(.clk     (clk_out_wire),   //   button is pressed. This ensures
                     .reset   (reset),          //    that only one single signal is
                     .d_in    (clk_step),       //               sent to the module.
                     .d_out   (clk_step_wire)
                    ),
                      
            mem_step(.clk     (clk_out_wire), 
                     .reset   (reset), 
                     .d_in    (step_mem), 
                     .d_out   (mem_dump_wire)
                    );
    /***************************  256 x 16  MEMORY  *******************************/
      mem_256x16  RAM(.clk    (clk_100mhz), 
                      .we     (mw_en_wire),
                      .adr    (dump_mux),
                      .d_in   (d_out_wire), 
                      .d_out  (d_in_wire)
                    );


      
endmodule 