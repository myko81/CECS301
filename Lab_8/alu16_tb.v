`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// 
////////////////////////////////////////////////////////////////////////////////

module alu16_tb;

	// Inputs
	reg [15:0] R;
	reg [15:0] S;
	reg [3:0] Alu_Op;

	// Outputs
	wire [15:0] Y;
	wire N;
	wire Z;
	wire C;
   
   integer i = 0;

	// Instantiate the Unit Under Test (UUT)
	alu16 uut (
		.R(R), 
		.S(S), 
		.Alu_Op(Alu_Op), 
		.Y(Y), 
		.N(N),
		.Z(Z), 
		.C(C)
	);

	initial begin
		// Initialize Inputs
		R = 0;
		S = 0;
		Alu_Op = 0;
      
          R = 16'h1111 ;
          S = 16'h1110 ;
      
      begin
         for (i = 0; i < 17; i = i + 1)   begin
               #5
                  Alu_Op = Alu_Op + i ;   end
      end

	end
      
endmodule

