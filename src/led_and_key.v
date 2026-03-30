module led_and_key #(
    parameter CLK_DIV_FACTOR = 14
) (
    input wire clk,
    input wire rst_n,

    input wire [7:0] disp_0,
    input wire [7:0] disp_1,
    input wire [7:0] disp_2,
    input wire [7:0] disp_3,
    input wire [7:0] disp_4,
    input wire [7:0] disp_5,
    input wire [7:0] disp_6,
    input wire [7:0] disp_7,
    input wire [7:0] leds,

    output wire [7:0] btns,

    input  wire tm_miso,
    output wire tm_mosi,
    output wire tm_data_dir,
    output wire tm_clk_out,
    output wire tm_stb_out
);

    /* verilator lint_off UNUSEDSIGNAL */
    wire [31:0] all_btns;
    /* verilator lint_on UNUSEDSIGNAL */

    assign btns[0] = all_btns[3];
    assign btns[1] = all_btns[11];
    assign btns[2] = all_btns[19];
    assign btns[3] = all_btns[27];
    assign btns[4] = all_btns[7];
    assign btns[5] = all_btns[15];
    assign btns[6] = all_btns[23];
    assign btns[7] = all_btns[31];

    tm1638_interface #(
        .CLK_DIV_FACTOR(CLK_DIV_FACTOR)
    ) TmInterface (
        .clk  (clk),
        .rst_n(rst_n),

        .disp_0(disp_0),
        .disp_1({7'd0, leds[7]}),
        .disp_2(disp_1),
        .disp_3({7'd0, leds[6]}),
        .disp_4(disp_2),
        .disp_5({7'd0, leds[5]}),
        .disp_6(disp_3),
        .disp_7({7'd0, leds[4]}),
        .disp_8(disp_4),
        .disp_9({7'd0, leds[3]}),
        .disp_A(disp_5),
        .disp_B({7'd0, leds[2]}),
        .disp_C(disp_6),
        .disp_D({7'd0, leds[1]}),
        .disp_E(disp_7),
        .disp_F({7'd0, leds[0]}),

        .btns(all_btns),

        .tm_miso(tm_miso),
        .tm_mosi(tm_mosi),
        .tm_data_dir(tm_data_dir),
        .tm_clk_out(tm_clk_out),
        .tm_stb_out(tm_stb_out)
    );

endmodule
