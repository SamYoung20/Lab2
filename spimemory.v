//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`timescale 1 ns / 1 ps
`include "inputconditioner.v"
`include "fsm.v"
`include "shiftregister.v"
`include "datamemory.v"
`include "latches.v"
module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);

wire mosi_conditioned, mosi_rising, mosi_falling;
wire sclk_conditioned, sclk_rising, sclk_falling;
wire cs_conditioned, cs_rising, cs_falling;
wire MISO_BUF, ADDR_WE, DM_WE, SR_WE;
wire[7:0] dataMemOut, shiftRegOutP;
wire serialDataOut;
wire[6:0] address;
wire dff_out;

inputconditioner mosi_inputcond(.clk(clk),
   .noisysignal(mosi_pin),
  .conditioned(mosi_conditioned),
   .positiveedge(mosi_rising),
   .negativeedge(mosi_falling));

inputconditioner sclk_inputcond(.clk(clk),
  .noisysignal(sclk_pin),
 .conditioned(sclk_conditioned),
  .positiveedge(sclk_rising),
  .negativeedge(sclk_falling));

inputconditioner cs_inputcond(.clk(clk),
   .noisysignal(cs_pin),
  .conditioned(cs_conditioned),
   .positiveedge(cs_rising),
   .negativeedge(cs_falling));

 fsm finitestate(.clk(clk),
   .negativeedge_sclk(sclk_falling),
   .positiveedge_sclk(sclk_rising),
   .cs(cs_conditioned),
   .mosi(mosi_conditioned),
   .MISO_BUF(MISO_BUF),
   .ADDR_WE(ADDR_WE),
   .DM_WE(DM_WE),
   .SR_WE(SR_WE));

  shiftregister shiftreg(.clk(clk),
    .peripheralClkEdge(sclk_rising),
    .parallelLoad(SR_WE),
    .parallelDataIn(dataMemOut),
    .serialDataIn(mosi_conditioned),
    .parallelDataOut(shiftRegOutP),
    .serialDataOut(serialDataOut));

  datamemory dm (.clk(clk),
    .dataOut(dataMemOut),
    .address(address),
    .writeEnable(DM_WE),
    .dataIn(shiftRegOutP));

  addressLatch addrLtch (.address(address),
  .data(dataMemOut),
  .wrenable(ADDR_WE),
  .clk(clk));

  dff dflipf(.q(dff_out),
    .d(serialDataOut),
    .wrenable(sclk_falling),
    .clk(clk));

  triStateBuf tsb(.a(dff_out),
    .enable(MISO_BUF),
    .b(miso_pin));

endmodule
