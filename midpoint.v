//-----------------------------------------------------------------------------
//  Wrapper for Lab 0: Full Adder
//
//  Rationale:
//     The ZYBO board has 4 buttons, 4 switches, and 4 LEDs. But if we want to
//     show the results of a 4-bit add operation, we will need at least 6 LEDs!
//
//     This wrapper module allows for 4-bit operands to be loaded in one at a
//     time, and multiplexes the LEDs to show the SUM and carryout/overflow at
//     different times.
//
//  Your job:
//     Write FullAdder4bit with the proper port signature. It will be instantiated
//     by the lab0_wrapper module in this file, which interfaces with the buttons,
//     switches, and LEDs for you.
//
//  Usage:
//     btn0 - load operand A from the current switch configuration
//     btn1 - load operand B from the current switch configuration
//     btn2 - show SUM on LEDs
//     btn3 - show carryout on led0, overflow on led1
//
//     Note: Buttons, switches, and LEDs have the least-significant (0) position
//     on the right.
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

`include "shiftregister.v"
`include "inputconditioner.v"
//-----------------------------------------------------------------------------
// Basic building block modules
//-----------------------------------------------------------------------------

// D flip-flop with parameterized bit width (default: 1-bit)
// Parameters in Verilog: http://www.asic-world.com/verilog/para_modules1.html
module dff #( parameter W = 1 )
(
    input trigger,
    input enable,
    input      [W-1:0] d,
    output reg [W-1:0] q
);
    always @(posedge trigger) begin
        if(enable) begin
            q <= d;
        end
    end
endmodule

// JK flip-flop
module jkff1
(
    input trigger,
    input j,
    input k,
    output reg q
);
    always @(posedge trigger) begin
        if(j && ~k) begin
            q <= 1'b1;
        end
        else if(k && ~j) begin
            q <= 1'b0;
        end
        else if(k && j) begin
            q <= ~q;
        end
    end
endmodule

// Two-input MUX with parameterized bit width (default: 1-bit)
module mux2 #( parameter W = 1 )
(
    input[W-1:0]    in0,
    input[W-1:0]    in1,
    input           sel,
    output[W-1:0]   out
);
    // Conditional operator - http://www.verilog.renerta.com/source/vrg00010.htm
    assign out = (sel) ? in1 : in0;
endmodule


//-----------------------------------------------------------------------------
// Main Lab 0 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board. Allows for two
//   4-bit operands to be stored, and two results to be alternately displayed
//   to the LEDs.
//
//   You must write the FullAdder4bit (in your adder.v) to complete this module.
//   Challenge: write your own interface module instead of using this one.
//-----------------------------------------------------------------------------

module lab0_wrapper
(
    input        clk,
    input  [3:0] sw,
    input  [3:0] btn,
    output [3:0] led
);
// not technically needed
    wire[3:0] opA, opB;       // Stored inputs to adder
    wire[3:0] res0, res1;     // Output display options
    wire res_sel;             // Select between display options
    wire cout;                // Carry out from adder
    wire ovf;                 // Overflow from adder
//needed
    //reg clk;
    wire conditioned0;
    wire rising0;
    wire falling0;

    wire conditioned1;
    wire rising1;
    wire falling1;

    wire conditioned2;
    wire rising2;
    wire falling2;
    wire[7:0] parallelDataOut;
    wire serialDataOut;


    // Capture button input to switch which MUX input to LEDs
    jkff1 src_sel(.trigger(clk), .j(btn[3]), .k(btn[2]), .q(res_sel)); // click last two buttons to view register 4 bits at a time
    mux2 #(4) output_select(.in0(parallelDataOut[3:0]), .in1(parallelDataOut[7:4]), .sel(res_sel), .out(led)); // show first 4 bits then second 4 bits

    // TODO:

    inputconditioner but0(.clk(clk),
			 .noisysignal(btn[0]),
		 	.conditioned(conditioned0),
			 .positiveedge(rising0),
			 .negativeedge(falling0));
    inputconditioner sw0(.clk(clk),
   			 .noisysignal(sw[0]),
   		 	.conditioned(conditioned1),
   			 .positiveedge(rising1),
   			 .negativeedge(falling1));
    inputconditioner sw1(.clk(clk),
     			 .noisysignal(sw[1]),
     		 	.conditioned(conditioned2),
     			 .positiveedge(rising2),
     			 .negativeedge(falling2));
    shiftregister #(8) register8(.clk(clk),
           		           .peripheralClkEdge(rising2),
           		           .parallelLoad(falling0),
           		           .parallelDataIn(8'b01010101),
           		           .serialDataIn(conditioned1),
           		           .parallelDataOut(parallelDataOut),
           		           .serialDataOut(serialDataOut));

endmodule
