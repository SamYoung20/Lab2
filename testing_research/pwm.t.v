`include "pwm.v"
module pwm_tb ();
 
  reg clk, rst;
  reg [7:0] compare;
  wire pwm;
 
  pwm #(.CTR_LEN(8)) DUT (
    .clk(clk),
    .rst(rst),
    .compare(compare),
    .pwm(pwm)
  );
 
  initial begin
    clk = 1'b0;
    rst = 1'b1;
    repeat(4) #10 clk = ~clk;
    rst = 1'b0;
    forever #10 clk = ~clk; // generate a clock
  end
 
  initial begin
    	$dumpfile("pwm.vcd");
    	$dumpvars(0,DUT);
    compare = 8'd0; // initial value
    @(negedge rst); // wait for reset
    compare = 8'd128;
    repeat(256) @(posedge clk);
    compare = 8'd30;
    repeat(256) @(posedge clk);
    $finish;
  end
 
endmodule
