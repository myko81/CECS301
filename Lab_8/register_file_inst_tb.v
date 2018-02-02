`timescale 1ns / 1ps

/*==================================================================================
 File Name:    register_file_inst_tb.v
 Project:      Lab 5 - Register Files
 Designer:     Michael Marin
 Email:        michaelmarin81@gmail.com
 Rev. Date:    March 22, 2017

 Purpose:      This is the testbench for the register_file.
==================================================================================*/

module register_file_inst_tb;
	// Inputs
	reg clk;
	reg reset;
	reg we;
	reg [15:0] W;
	reg [2:0] w_adr;
	reg [2:0] r_adr;
	reg [2:0] s_adr;

	// Outputs
	wire [15:0] R;
	wire [15:0] S;

	// Instantiate the Unit Under Test (UUT)
	register_file uut 
      (.clk(clk),     .reset(reset), .we(we), .W(W), .w_adr(w_adr), .r_adr(r_adr), 
		 .s_adr(s_adr), .R(R), .S(S));
   
   always
      #5 clk = ~clk;  // creates a clock signal
      
   integer i;
   
  //******************************************************************************/
  //  task memDump - this task takes in the input from the initial begin and
  //                 uses a for loop to increment. The write address goes through
  //                 all eigth of the possible 3bit binary combinations. This 
  //******************************************************************************/
   task memDump;
      input [15:0] address ;
      begin
         for (i = 0; i < 8; i = i + 1)   begin
            @(negedge clk)
               we = 1;               // sets enable to 1
               w_adr = w_adr + 1;    //increments the w_address
               r_adr = i;            //increments the r_address
               s_adr = r_adr + 1;    //increments the s_address 1 more that r_adr   

               address = address + 1; //increments the address
               W = address;               end
       end
   endtask 


 //********************************************************************************/
	initial begin 

		clk = 0; reset = 1;  
      we = 0;  
      W = 0;   
      w_adr = 0;  
      r_adr = 0;  
      s_adr = 0;  
      i = 0 ;
      
      @(negedge clk)
      reset = 0;
      
      memDump({12'hfff, 4'h0}); //first four digits are fff followed by an a

      $finish;
      end
      
endmodule

