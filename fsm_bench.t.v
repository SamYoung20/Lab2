// Testbench for thermostat FSM example

`timescale 1ns / 1ps

`include "fsm.v"

module fsm_test ();
    reg clk, negativeedge_sclk, positiveedge_sclk, cs, mosi;	// FSM inputs
    wire MISO_BUF, ADDR_WE, DM_WE, SR_WE;	// FSM output

    // Instantiate DUT
    fsm dut(.clk(clk), .negativeedge_sclk(negativeedge_sclk),
                   .positiveedge_sclk(positiveedge_sclk), .cs(cs),
                   .mosi(mosi), .MISO_BUF(MISO_BUF), .ADDR_WE(ADDR_WE), .DM_WE(DM_WE), .SR_WE(SR_WE));
    // Create clock signal
    initial clk=0;
    always #10 clk =! clk;


   // Test sequence
   initial begin
       $dumpfile("fsm.vcd");
       $dumpvars(0, dut);

        //testing idle state
       negativeedge_sclk = 0; positiveedge_sclk = 0; cs = 1; mosi = 0; #35
      if(MISO_BUF != 0 || DM_WE != 0 || ADDR_WE != 0 || SR_WE != 0) begin
        $display("error in test #1" );
        $display("MISO_BUF | Expected: 0 Got: %d", MISO_BUF);
        $display("DM_WE | Expected: 0 Got: %d", DM_WE);
        $display("ADDR_WE | Expected: 0 Got: %d", ADDR_WE);
        $display("ADDR_WE | Expected: 0 Got: %d", SR_WE);
      end
      else begin
        $display("Passed Test 1 : Idle");
        end
      //testing active state
      negativeedge_sclk = 0; positiveedge_sclk = 0; cs = 0; mosi = 0; #35

     if(MISO_BUF != 1 || DM_WE != 0 || ADDR_WE != 0 || SR_WE != 0) begin
       $display("error in test #2" );
       $display("MISO_BUF | Expected: 1 Got: %d", MISO_BUF);
       $display("DM_WE | Expected: 0 Got: %d", DM_WE);
       $display("ADDR_WE | Expected: 0 Got: %d", ADDR_WE);
       $display("SR_WE | Expected: 0 Got: %d", SR_WE);
     end
     else begin
       $display("Passed Test 2 : Active");
       end

       //testing Finding address
       negativeedge_sclk = 0; positiveedge_sclk = 1; cs = 0; mosi = 1; #11
    if(MISO_BUF != 1 || DM_WE != 0 || ADDR_WE != 0 || SR_WE != 0) begin
         $display("error in test #3" );
         $display("MISO_BUF | Expected: 1 Got: %d", MISO_BUF);
         $display("DM_WE | Expected: 0 Got: %d", DM_WE);
         $display("ADDR_WE | Expected: 0 Got: %d", ADDR_WE);
         $display("SR_WE | Expected: 0 Got: %d", SR_WE);
       end
       else begin
         $display("Passed Test 3 : Address[0] Found");
         end
      #100
      //Determining Write o
      mosi = 0; #4
      positiveedge_sclk = 1; cs = 0; #6
      negativeedge_sclk = 1;positiveedge_sclk = 0; #1

      if(MISO_BUF != 1 || DM_WE != 0 || ADDR_WE != 1 || SR_WE != 0) begin
           $display("error in test #4" );
           $display("MISO_BUF | Expected: 1 Got: %d", MISO_BUF);
           $display("DM_WE | Expected: 0 Got: %d", DM_WE);
           $display("ADDR_WE | Expected: 1 Got: %d", ADDR_WE);
           $display("SR_WE | Expected: 0 Got: %d", SR_WE);
         end
         else begin
           $display("Passed Test 4 : Determining Write State");
           end
        #30
       positiveedge_sclk = 1; cs = 0; negativeedge_sclk = 0; #180


       if(MISO_BUF != 1 || DM_WE != 1 || ADDR_WE != 0 || SR_WE != 0) begin
            $display("error in test #5" );
            $display("MISO_BUF | Expected: 1 Got: %d", MISO_BUF);
            $display("DM_WE | Expected: 1 Got: %d", DM_WE);
            $display("ADDR_WE | Expected: 0 Got: %d", ADDR_WE);
            $display("SR_WE | Expected: 0 Got: %d", SR_WE);
          end
          else begin
            $display("Passed Test 5 : Sending to Data Memory");
            end



            //Determining read o
            mosi = 1; #4
            positiveedge_sclk = 1; cs = 0; #6
            positiveedge_sclk = 0;  #1

        if(MISO_BUF != 1 || DM_WE != 0 || ADDR_WE != 1 || SR_WE != 0) begin
             $display("error in test #6" );
             $display("MISO_BUF | Expected: 1 Got: %d", MISO_BUF);
             $display("DM_WE | Expected: 0 Got: %d", DM_WE);
             $display("ADDR_WE | Expected: 1 Got: %d", ADDR_WE);
             $display("SR_WE | Expected: 0 Got: %d", SR_WE);
           end
           else begin
             $display("Passed Test 6 : Determining read State");
             end


     #1000
     $dumpflush;
     $finish;		// End simulation (otherwise clk is infinite)
   end


endmodule
