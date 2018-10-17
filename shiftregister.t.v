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

    //Case 1: PIPO
    //Parallel load is always asserted, 8 bits are loaded into place. After these 8 bits are loaded, parallel data in goes to zero, and we observe a full shift in the output.

    parallelLoad = 1; parallelDataIn = 8'b11001100; #50
   if(parallelDataIn != parallelDataOut) begin
     $display("error in test #1" );
     $display("Parallel Out | Expected: %d Got: %d", parallelDataIn, parallelDataOut);
   end
   else begin
     $display("Passed Test 1 : PIPO with %d", parallelDataIn);
     end

     parallelLoad = 1; parallelDataIn = 8'b0000000; #50
    if(parallelDataIn != parallelDataOut) begin
      $display("error in test #1" );
      $display("Parallel Out | Expected: %d Got: %d", parallelDataIn, parallelDataOut);
    end
    else begin
      $display("Passed Test 1 : PIPO with %d", parallelDataIn);
      end


      parallelLoad = 1; parallelDataIn = 8'b1010101; #50
      if(parallelDataIn != parallelDataOut) begin
       $display("error in test #1" );
       $display("Parallel Out | Expected: %d Got: %d", parallelDataIn, parallelDataOut);
      end
      else begin
       $display("Passed Test 1 : PIPO with %d", parallelDataIn);
       end




    //Case 2: SIS0
    //Parallel load is never asserted, we observe a reading of serial data into the LSB

    parallelLoad = 1; parallelDataIn = 8'b00000000; #50
    if(parallelDataIn != parallelDataOut) begin
     $display("error in test #2" );
     $display("ParallelOut | Expected: %d Got: %d", parallelDataIn, parallelDataOut);
    end
    else begin
     $display("Passed Test 2 : Load zeros through parallelIn");
     end

    parallelLoad = 0; parallelDataIn = 8'b1010101; serialDataIn = 1; #50
    if(serialDataOut != 0) begin
     $display("error in test #2" );
     $display("Serial Out | Expected: %d Got: %d", serialDataIn, serialDataOut);
    end
    else begin
     $display("Passed Test 2 : Reads Correct Bit");
     end

     serialDataIn = 1; #50
     serialDataIn = 1; #50
     serialDataIn = 1; #50
     serialDataIn = 1; #50
     serialDataIn = 1; #50
     serialDataIn = 1; #50
     serialDataIn = 1; #50
     serialDataIn = 1; #50

     if(serialDataOut != 1) begin
      $display("error in test #2" );
      $display("Serial Out | Expected: 1 Got: %d", serialDataOut);
     end
     else begin
      $display("Passed Test 2 : SISO with %d", serialDataIn);
      end

    //Case 3: SIPO
    //Parallel load is never asserted, we observe a reading of serial data into the LSB
    parallelLoad = 0; serialDataIn = 0; #100

    serialDataIn = 1; #60
    serialDataIn = 0; #80
    serialDataIn = 1; #25

    if(parallelDataOut != 225) begin
     $display("error in test #3" );
     $display("Parallel Out | Expected: 10010110 Got: %d", parallelDataOut);
    end
    else begin
     $display("Passed Test 3 : SIPO with %d", parallelDataOut);
     end
     
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
