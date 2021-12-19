//`timescale 1ns

module mult_tb ();

   wire CLK_i;
   wire [31:0] FP_in;
   wire [31:0] FP_out;


   clk_gen CG( .CLK(CLK_i)
	      );

   data_maker SM(.CLK(CLK_i),
		 .DATA(FP_in));

   FPmul_pipeline UUT(.FP_A(FP_in),
	     .FP_B(FP_in),
	     .clk(CLK_i),
         .FP_Z(FP_out)
	     );

   data_sink DS(.CLK(CLK_i),
		.DIN(FP_out));   

endmodule

		   
