module top (
    input wire clk,
    input wire rst_n,

    output wire tm_stb,
    output wire tm_clk,
    inout  wire tm_dio,

    input  wire uart_rx,
    output wire uart_tx,

    input wire invert_switch,
    output wire [5:0] leds
);
    `include "display_decoder.vh"

    wire [7:0] btns;
    wire tm_miso, tm_mosi;
    wire tm_data_dir;
    reg [7:0] disp[7:0];

    wire rx_led, tx_led;

    wire wr_en;
    wire [7:0] addr;
    /* verilator lint_off UNUSEDSIGNAL */
    wire [31:0] wr_data;
    /* verilator lint_on UNUSEDSIGNAL */
    wire rd_en;
    reg rd_valid;

    assign tm_miso = tm_dio;
    assign tm_dio = tm_data_dir ? tm_mosi : 1'bz;

    assign leds[5:2] = 4'hf;
    assign leds[0] = ~rx_led;
    assign leds[1] = ~tx_led;


    always @(posedge clk) begin
        rd_valid <= rd_en;
    end

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

        .btns(btns),
        .leds({8{invert_switch}} ^ btns),

        .tm_miso(tm_miso),
        .tm_mosi(tm_mosi),
        .tm_data_dir(tm_data_dir),
        .tm_clk_out(tm_clk),
        .tm_stb_out(tm_stb)
    );

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : displays
            always @(posedge clk) begin
                if (!rst_n) begin
                    disp[i] <= 8'h00;
                end else if (wr_en & addr == i) begin
                    disp[i] <= wr_data[7:0];
                end
            end
        end
    endgenerate

`ifndef VERILATOR
    Uart_to_Bus_Top your_instance_name (
        .rst_n_i(rst_n),
        .clk_i(clk),
        .local0_wren_o(wr_en),
        .local0_addr_o(addr),
        .local0_rden_o(rd_en),
        .local0_wdat_o(wr_data),
        .local0_rdat_i({24'd0, btns}),
        .local0_rdat_vld_i(rd_valid),
        .local0_wdat_rdy_i(1'b1),
        .uart_rx_led_o(rx_led),
        .uart_tx_led_o(tx_led),
        .uart_rx_i(uart_rx),
        .uart_tx_o(uart_tx)
    );
`else
    assign uart_tx = uart_rx;
    assign rx_led = uart_rx;
    assign tx_led = uart_tx;
    assign wr_en = 1'b0;
    assign rd_en = 1'b0;
    assign addr = 8'h00;
    assign wr_data = 32'h00000000;

    /* verilator lint_off UNUSEDSIGNAL */
    wire rd_valid_wire;
    /* verilator lint_on UNUSEDSIGNAL */
    assign rd_valid_wire = rd_valid;
`endif

endmodule
