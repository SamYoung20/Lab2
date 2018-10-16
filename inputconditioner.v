//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------
`define NAND nand #20
`define NOT not #10
`timescale 1 ns / 1 ps

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
    reg posedgecounter = 0;
    reg negedgecounter = 0;

    always @(posedge clk ) begin
        if(posedgecounter > 0) begin
          positiveedge <= 0;
          posedgecounter <= 0;
        end

        if(negedgecounter > 0) begin
          negativeedge <= 0;
          negedgecounter <= 0;
        end

        if(conditioned == synchronizer1)
            counter <= 0;
        else begin
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;

            if( conditioned < synchronizer0) begin
                positiveedge <= 1;
                posedgecounter <= posedgecounter + 1; end

            if( conditioned > synchronizer0) begin
                negativeedge <= 1;
                negedgecounter <= negedgecounter + 1; end end

                counter <= counter+1;
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;
    end

endmodule
