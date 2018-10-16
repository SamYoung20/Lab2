// Single-bit D Flip-Flop with enable
//   Positive edge triggered
`timescale 1 ns / 1 ps
module dff
(
output reg	q,
input		d,
input		wrenable,
input		clk
);

    always @(posedge clk) begin
        if(wrenable) begin
            q <= d;
        end
    end
endmodule

module addressLatch
(
output reg[6:0] address,
input[7:0]		data,
input		wrenable,
input		clk
);
  initial  address = 0;

    always @(posedge clk) begin
        if(wrenable) begin
            address[6:0] <= data[6:0];
        end
    end

endmodule

module triStateBuf
(
input a, enable,
output b
);
  assign b = (enable) ? a: 1'bz;
endmodule
