//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------
`timescale 1 ns / 1 ps
`include "shiftregister.v"
module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn;

    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk),
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad),
    		           .parallelDataIn(parallelDataIn),
    		           .serialDataIn(serialDataIn),
    		           .parallelDataOut(parallelDataOut),
    		           .serialDataOut(serialDataOut));
    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
    $dumpfile("shifter.vcd");
    $dumpvars(0, dut);


    //Case 1: PIPO
    //Parallel load is always asserted, 8 bits are loaded into place. After these 8 bits are loaded, parallel data in goes to zero, and we observe a full shift in the output.
    parallelDataIn = 8'b11001100;
    parallelLoad= 1;
    #20;
    $display("current register   %b", parallelDataOut);
    parallelDataIn = 8'b0000000;
    #20;
    $display("current register   %b", parallelDataOut);
    parallelDataIn = 8'b1010101;
    #20;
    $display("current register   %b", parallelDataOut);



    //Case 2: SIS0
    //Parallel load is never asserted, we observe a reading of serial data into the LSB
    parallelLoad = 0;
    serialDataIn = 1;
    #20;
    // not working as expected // GTKWAVE does not register serial dataout as getting anything written to it. we should look at shift register.v
    $display("current register LSB   %b", parallelDataOut);
    serialDataIn = 0;
    #20;
    $display("current register LSB   %b", serialDataOut);
    serialDataIn = 1;
    #20;
    $display("current register LSB   %b", serialDataOut);

    //Case 3:
    //Peripheral clock edge is non-periodic, so we observe non-periodic shifting. Parallel load is always asserted.

    //Case 4:
    //Parallel load is toggled.

    $dumpflush;
    $finish;
    end

endmodule
