module top (
    input wire clk,
    input wire rst_n,

    output wire tm_stb,
    output wire tm_clk,
    inout  wire tm_dio,

    input  wire uart_rx,
    output wire uart_tx,

    input wire btn,

    output wire [5:0] leds,

    input wire [3:0] switches
);

    wire [7:0] btns;

    assign leds = 6'b111111;

//    assign leds[0] = ^btns[31:24];
//    assign leds[1] = ^btns[23:16];
//    assign leds[2] = ^btns[15:8];
//    assign leds[3] = ^btns[7:0];
    //     assign leds[4] = uart_rx;
    //     assign leds[5] = uart_tx;

    wire tm_data_in;
    wire tm_data_out;
    wire tm_data_dir;

    assign tm_data_in = tm_dio;
    assign tm_dio = tm_data_dir ? tm_data_out : 1'bz;

    //    reg d_0

    `include "display_decoder.v"

    reg [7:0] disp[15:0];

    led_and_key ledAndKey (
        .clk  (clk),
        .rst_n(rst_n),

        .disp_0({disp[0][4], display_decode(disp[0][3:0])}),
        .disp_1({disp[1][4], display_decode(disp[1][3:0])}),
        .disp_2({disp[2][4], display_decode(disp[2][3:0])}),
        .disp_3({disp[3][4], display_decode(disp[3][3:0])}),
        .disp_4({disp[4][4], display_decode(disp[4][3:0])}),
        .disp_5({disp[5][4], display_decode(disp[5][3:0])}),
        .disp_6({disp[6][4], display_decode(disp[6][3:0])}),
        .disp_7({disp[7][4], display_decode(disp[7][3:0])}),
        .disp_8({disp[8][4], display_decode(disp[8][3:0])}),

        .btns(btns),
        .leds(btns),

        .tm_data_in (tm_data_in),
        .tm_data_out(tm_data_out),
        .tm_data_dir(tm_data_dir),
        .tm_clk_out (tm_clk),
        .tm_stb_out (tm_stb)
    );

    wire local0_wren_o;
    wire [7:0] local0_addr_o;
    wire [31:0] local0_wdat_o;

    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin: displays
            always @(posedge clk) begin
                if (!rst_n) begin
                    disp[i] <= 8'h00;
                end else if (local0_wren_o & local0_addr_o == i) begin
                    disp[i] <= local0_wdat_o[7:0];
                end
            end
        end
    endgenerate

    wire rd_en;
    reg  rd_valid;

    always @(posedge clk) begin
        rd_valid <= rd_en;
    end

    Uart_to_Bus_Top your_instance_name (
        .rst_n_i(rst_n),
        .clk_i(clk),
        .local0_wren_o(local0_wren_o),
        .local0_addr_o(local0_addr_o),
        .local0_rden_o(rd_en),
        .local0_wdat_o(local0_wdat_o),
        .local0_rdat_i({24'd0, btns}),
        .local0_rdat_vld_i(rd_valid),
        .local0_wdat_rdy_i(1'b1),
        .uart_rx_led_o(leds[4]),
        .uart_tx_led_o(leds[5]),
        .uart_rx_i(uart_rx),
        .uart_tx_o(uart_tx)
    );

endmodule
