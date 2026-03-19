`timescale 1ns / 100ps

module testbench;

    reg clk, rst;

    reg ce, up, l;

    reg [3:0] di;

    initial begin
        $dumpfile("tm1638.vcd");
        $dumpvars(0, testbench);
    end

    initial begin
        clk = 1'b1;
        rst = 1'b1;
        ce = 0;
        up = 0;
        di = 0;
        l = 0;
        #80;
        up = 1;
        #30;
        up = 0;
        #30;
        up = 1;
    end

    always #0.5 clk = ~clk;

    initial begin
        #10;
        rst = 0;
        #20000;
        $finish;
    end

    tm1638 TM1638 (
        .clk(clk),
        .rst(rst)
    );

endmodule
