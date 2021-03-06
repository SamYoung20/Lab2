//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

`timescale 1 ns / 1 ps

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output reg[width-1:0]  parallelDataOut,    // Shift reg data contents
output reg           serialDataOut       // Positive edge synchronized
);

    reg [width-1:0]      shiftregistermem;

    initial shiftregistermem = 0;

    always @(posedge clk) begin
        if( parallelLoad == 1)
          // When parallelLoad is asserted, the shift register will take the value of parallelDataIn.
            shiftregistermem <= parallelDataIn;

        else if (peripheralClkEdge == 1) begin
          // When the peripheral clock peripheralClkEdge has an edge, the shift register advances one position:
          // serialDataIn is loaded into the LSB (Least Significant Bit), and the rest of the bits shift up by one.
          shiftregistermem <= {shiftregistermem[width-2:0], serialDataIn};

        end
        serialDataOut <= shiftregistermem[width-1];
        parallelDataOut <= shiftregistermem;

    end


endmodule
