`timescale 1ns / 100ps

module testbench;

    reg clk, rst;

    initial begin
        $dumpfile("tm1638.vcd");
        $dumpvars(0, testbench);
    end

    initial begin
        clk = 1'b1;
        rst = 1'b1;
    end

    always #0.5 clk = ~clk;

    initial begin
        #10;
        rst = 0;
        #200000;
        $finish;
    end

    top Top (
        .clk(clk),
        .rst_n(!rst)
    );

endmodule
