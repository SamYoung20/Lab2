//------------------------------------------------------------------------
// Input Conditioner test bench
//------------------------------------------------------------------------
`timescale 1 ns / 1 ps
`include "inputconditioner.v"
module testConditioner();
    reg clk;
    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    inputconditioner dut(.clk(clk),
			 .noisysignal(pin),
		 	.conditioned(conditioned),
			 .positiveedge(rising),
			 .negativeedge(falling));


    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
        $dumpfile("inputconditioner.vcd");
    	$dumpvars(0, dut);

	pin = 0; #100
	pin = 1; #50
	pin = 1; #50
	pin = 1; #50
	pin = 1; #50
	pin = 1; #50
	pin = 1; #50 // clean high
	pin = 0; #50
	pin = 0; #50
	pin = 0; #50
	pin = 0; #50
	pin = 0; #50 //clean low
	pin = 1; #10 // bounceing high
	pin = 0; #10
	pin = 1; #10
	pin = 1; #50
	pin = 1; #50
	pin = 1; #50
	pin = 1; #50 // bounceing low
	pin = 0; #50
	pin = 0; #50
	pin = 0; #50
	pin = 1; #10
	pin = 0; #50
	pin = 0; #50
	$dumpflush;
	$finish;
	end
endmodule


//sychronization

//debouncing


//edge detection




//	#200 data_in = 1'b1;
//	//reset = 1'b1;
//	#200 data_in = 1'b1;
//	//reset = 1'b1;

//	#300 data_in = 1'b1;
//	//reset=1'b0;
//	#600 data_in = 1'b0;
//	#500 data_in = 1'b1;
//	#200 data_in = 1'b0;
//	#400 $stop;

    // Your Test Code
    // Be sure to test each of the three conditioner functions:
    // Synchronization, Debouncing, Edge Detection
