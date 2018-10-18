// Testbench for finite state machine

`timescale 1ns / 1ps

`include "spimemory.v"


module spi_test ();
    reg clk, sclk_pin, cs_pin, cs, mosi_pin;	// FSM inputs

    wire miso_pin;	// FSM output
    wire[3:0] leds;

    // Instantiate DUT
    spiMemory dut(.clk(clk), .sclk_pin(sclk_pin),
                   .cs_pin(cs_pin), .miso_pin(miso_pin),
                   .mosi_pin(mosi_pin), .leds(leds));

   // Create clock signal
   initial clk=0;
   always #10 clk =! clk;
   initial sclk_pin=0;
   always #100 sclk_pin =! sclk_pin;


   // Test sequence
   initial begin
       $dumpfile("spi.vcd");
       $dumpvars(0, dut);
       //start with chip select enabled
       cs_pin = 1;
       #50
       //disable chip select
       cs_pin = 0;
       #150
       //write to address 1000100
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200;
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200
       ///////
       //write this data , 10111011 to aforementioned address, 1000100
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200;
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200

       //wait wait a fill cycle
       ////
       #1600
       #1600

       //write to address 1000101
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200;
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       ///////
       //write this data , 1010101 to aforementioned address, 1000101
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200;
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       /////


       //read from 1000100, the expected miso pin should be  10111010
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200;
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 1;
       #200

      #1600
      #1600
      #1600
       ///////
       //read from 1000101, the expected miso pin should be  10101010
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;
       #200;
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
      #1600
      #1600
      #1600
       //
/*
       //TEST CASE TWO TRY TO WRITE AND READ FROM A NEW ADRESS
        //write to address 1111111

       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200;
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       ///////
       //write this data , 11001111 to aforementioned address, 1110101
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 1;
       #200;
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 0;
       #200
       mosi_pin = 0;

       #1600
       #1600
       //read from 1110101, the expected miso pin should be  11001111
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200;
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 1;
       #200
       mosi_pin = 1;

        #1600


       #200
*/




       //testing read
       /*
       miso_pin!=
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
            positiveedge_sclk = 1;  mosi = 0;#120

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
*/
     #10000
     $dumpflush;
     $finish;		// End simulation (otherwise clk is infinite)
   end


endmodule
