//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------
`define NAND nand #20
`define NOT not #10

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles

    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;
/*
    always @(posedge clk ) begin
        if(conditioned == synchronizer1)
            counter <= 0;
        else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;
                if(conditioned > synchronizer0)
                    positiveedge <= 1
                else if(conditioned < synchronizer0)
                    negativeedge <= 1
                else begin
                positiveedge <= 0
                negativeedge <= 0
                end

            end
            else
                counter <= counter+1;
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
    end
*/
endmodule

module gated_d_latch(
   input data,
   input clk,
   output q
   );

   wire notQ;
   wire wire0;
   wire wire1;
//
   `NAND nand1(wire0, data, clk);
   `NAND nand2(wire1, wire0, clk);
   `NAND nand3(q,wire0, notQ);
   `NAND nand4(notQ, wire1, q);
 endmodule
