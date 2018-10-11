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
    initial peripheralClkEdge = 0;
    always #10 clk=!clk;    // 50MHz Clock

    always
      begin
      peripheralClkEdge <= 1'b0;
      #9;
      peripheralClkEdge <= 1'b1;
      #2;
      peripheralClkEdge <= 1'b0;
      #9;
      end

    initial begin
    $dumpfile("shifter.vcd");
    $dumpvars(0, dut);

    //Hey Emma! I think the reason that serial stuff doesnt work is because we arent setting peripheral clock edge to anything. I think this clock edge comes from the
    //input conditioner "rising" variable. But I am not entirely sure what input we need to condition? I think its a button press on the FPGA but for this test, just a  random
    // on off signal ?  I think so. Lets chat

    //Case 1: PIPO
    //Parallel load is always asserted, 8 bits are loaded into place. After these 8 bits are loaded, parallel data in goes to zero, and we observe a full shift in the output.
    parallelDataIn = 8'b11001100;
    parallelLoad= 1;
    serialDataIn = 0;
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
    #5
    parallelDataIn = 8'b0110000;
    #15;
    // not working as expected // GTKWAVE does not register serial dataout as getting anything written to it. we should look at shift register.v
    $display("current register LSB   %b", parallelDataOut);
    serialDataIn = 0;
    //parallelDataIn = 8'b0010100;
    #20;
    $display("current register LSB   %b", serialDataOut);
    serialDataIn = 1;
    //parallelDataIn = 8'b1000101;
    #20;
    $display("current register LSB   %b", serialDataOut);

    //Case 3:
    //Peripheral clock edge is non-periodic, so we observe non-periodic shifting. Parallel load is always asserted.

    //Case 4:
    //Parallel load is toggled.

    parallelDataIn = 8'b11001100; #20
    parallelLoad= 1;
    serialDataIn = 1;
    #5;
    $display("current register   %b", parallelDataOut);
    parallelDataIn = 8'b0000000;
    serialDataIn = 1;
    #27;
    $display("current register   %b", parallelDataOut);
    parallelDataIn = 8'b1010101;
    serialDataIn = 1;
    #20;
    $display("current register   %b", parallelDataOut);

    parallelLoad= 0;
    #35;
    $display("current register   %b", parallelDataOut);
    serialDataIn = 1;
    parallelDataIn = 8'b0000000;
    #27;
    $display("current register   %b", parallelDataOut);
    parallelDataIn = 8'b1010101;
    serialDataIn = 0;
    #20;
    $display("current register   %b", parallelDataOut);
    $dumpflush;
    $finish;
    end

endmodule
