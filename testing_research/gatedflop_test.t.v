`timescale 1ns / 100ps
/************************************************************************
* Date: Aug. 16, 2006
* File: Test_Reg1.v (440 Examples)
*
* Testbench to generate some stimulus and display the results for the
* Reg1 module -- a 32 bit register with asynch reset.
************************************************************************/
//*********************************************************
module Test_Reg1;
//*********************************************************
wire [31:0] OutReg;
reg [31:0] Din;
reg clk, reset_;
// Instantiate Reg32 (named DUT {device under test})
Reg32 DUT(OutReg, Din, clk, reset_);
initial begin
 $timeformat(-9, 1, " ns", 6);
clk = 1’b0;
reset_ = 1’b1; // deassert reset t=0
 #3 reset_ = 1’b0; // assert reset t=3
 #4 reset_ = 1’b1; // deassert reset t=7
@(negedge clk) //will wait for next negative edge of the clock (t=20)
 Din = 32'hAAAA5555;
@(negedge clk) //will wait for next negative edge of the clock (t=40)
 Din = 32'h5F5F0A0A;
@(negedge clk) //will wait for next negative edge of the clock (t=60)
 Din = 32'hFEDCBA98;
@(negedge clk) //will wait for next negative edge of the clock (t=80)
 reset_ = 1’b0;
@(negedge clk) //will wait for next negative edge of the clock (t=100)
 reset_ = 1’b1;
@(negedge clk) //will wait for next negative edge of the clock (t=120)
 Din = 32'h76543210;
@(negedge clk) //will wait for next negative edge of the clock (t=140)
 $finish; // to kill the simulation
end
// This block generates a clock pulse with a 20 ns period.
// Rising edges at 10, 30, 50, 70 .... Falling edges at 20, 40, 60, 80 ....
always
 #10 clk = ~ clk;
// this block is sensitive to changes on clk or reset and will
// then display both the inputs and corresponding output
always @(posedge clk or reset_)
 #1 $display("At t=%t / Din=%h OutReg=%h" ,
 $time, Din, OutReg);
endmodule 
