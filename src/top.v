module top (
    input wire clk,
    input wire rst_n,

    output wire tm_stb,
    output wire tm_clk,
    inout  wire tm_dio,

    input  wire uart_rx,
    output wire uart_tx,

    output wire [5:0] leds
);

    assign leds[0] = uart_rx;
    assign leds[1] = uart_tx;
    assign leds[5:4] = 2'b11;

    wire tm_data_in;
    wire tm_data_out;
    wire tm_data_dir;

    assign tm_data_out = tm_dio;
    assign tm_dio = tm_data_dir ? tm_data_in : 1'b1;

    wire [7:0] data_in;
    wire data_in_wait;
    wire data_in_read;
    wire data_in_valid;
    wire data_in_ready;

    wire [8:0] initial_sequence[29:0];

    reg [7:0] counter;

    assign data_in_valid = counter < 30;
    // assign data_in_valid = counter < 5;

    // assign initial_sequence[0] = {1'b0, 8'b01000000};
    assign initial_sequence[0] = {1'b0, 8'b01000000};
    assign initial_sequence[1] = {1'b1, 8'b00000000};
    assign initial_sequence[2] = {1'b0, 8'b10001111};
    assign initial_sequence[3] = {1'b1, 8'b00000000};
    // assign initial_sequence[4] = {1'b0, 8'b11001100};
    assign initial_sequence[4] = {1'b0, 8'b11000000};
    assign initial_sequence[5] = {1'b0, 8'h00};
    assign initial_sequence[6] = {1'b0, 8'h00};
    assign initial_sequence[7] = {1'b0, 8'hff};
    assign initial_sequence[8] = {1'b0, 8'hff};
    assign initial_sequence[9] = {1'b0, 8'hff};
    assign initial_sequence[10] = {1'b0, 8'hff};
    assign initial_sequence[11] = {1'b0, 8'hff};
    assign initial_sequence[12] = {1'b0, 8'hff};
    assign initial_sequence[13] = {1'b0, 8'hff};
    assign initial_sequence[14] = {1'b0, 8'hff};
    assign initial_sequence[15] = {1'b0, 8'hff};
    assign initial_sequence[16] = {1'b0, 8'hff};
    assign initial_sequence[17] = {1'b0, 8'hff};
    assign initial_sequence[18] = {1'b0, 8'hff};
    assign initial_sequence[19] = {1'b0, 8'hff};
    assign initial_sequence[20] = {1'b0, 8'hff};

    assign initial_sequence[21] = {1'b1, 8'b00000000};
    assign initial_sequence[22] = {1'b1, 8'b00000000};
    assign initial_sequence[23] = {1'b1, 8'b00000000};
    
    assign initial_sequence[24] = {1'b0, 8'b11001100};
    assign initial_sequence[25] = {1'b0, 8'hff};
    assign initial_sequence[26] = {1'b1, 8'b00000000};
    
    assign initial_sequence[27] = {1'b0, 8'b11000000};
    assign initial_sequence[28] = {1'b0, 8'hff};
    assign initial_sequence[29] = {1'b1, 8'b00000000};

    
    // assign initial_sequence[6] = {1'b1, 8'b00000000};
    // assign initial_sequence[7] = {1'b0, 8'b11000001};
    // assign initial_sequence[8] = {1'b0, 2};
    // assign initial_sequence[9] = {1'b1, 8'b00000000};
    // assign initial_sequence[10] = {1'b0, 8'b11000010};
    // assign initial_sequence[11] = {1'b0, 3};
    // assign initial_sequence[12] = {1'b1, 8'b00000000};
    // assign initial_sequence[13] = {1'b0, 8'b11000011};
    // assign initial_sequence[14] = {1'b0, 4};
    // assign initial_sequence[15] = {1'b1, 8'b00000000};
    // assign initial_sequence[16] = {1'b0, 8'b11000100};
    // assign initial_sequence[17] = {1'b0, 5};
    // assign initial_sequence[18] = {1'b1, 8'b00000000};
    // assign initial_sequence[19] = {1'b0, 8'b11000101};
    // assign initial_sequence[20] = {1'b0, 6};
    // assign initial_sequence[21] = {1'b1, 8'b00000000};
    // assign initial_sequence[22] = {1'b0, 8'b11000110};
    // assign initial_sequence[23] = {1'b0, 7};
    // assign initial_sequence[24] = {1'b1, 8'b00000000};
    // assign initial_sequence[25] = {1'b0, 8'b11000111};
    // assign initial_sequence[26] = {1'b0, 8};
    // assign initial_sequence[27] = {1'b1, 8'b00000000};
    // assign initial_sequence[28] = {1'b0, 8'b11001000};
    // assign initial_sequence[29] = {1'b0, 9};
    // assign initial_sequence[30] = {1'b1, 8'b00000000};
    // assign initial_sequence[31] = {1'b0, 8'b11001001};
    // assign initial_sequence[32] = {1'b0, 10};

    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 0;
        end else if (data_in_ready & counter < 15) begin
            counter <= counter + 1;
        end
    end


    tm1638 TM1638 (
        .clk(clk),
        .rst(~rst_n),

        .tm_data_out(tm_data_in),
        .tm_data_in (tm_data_out),
        .tm_data_dir(tm_data_dir),
        .tm_clk_out (tm_clk),
        .tm_stb_out (tm_stb),

        .data_in(initial_sequence[counter][7:0]),
        .data_in_wait(initial_sequence[counter][8]),
        .data_in_read(1'b0),
        .data_in_valid(data_in_valid),
        .data_in_ready(data_in_ready)
    );


    //  Uart_to_Bus_Top UartToBus (
    //      .rst_n_i(rst_n),  //input rst_n_i
    //      .clk_i(clk),  //input clk_i
    //      // .local0_wren_o(local0_wren_o), //output local0_wren_o
    //      // .local0_addr_o(local0_addr_o), //output [7:0] local0_addr_o
    //      // .local0_rden_o(local0_rden_o), //output local0_rden_o
    //      // .local0_wdat_o(local0_wdat_o), //output [31:0] local0_wdat_o
    //      .local0_rdat_i(32'haabbccdd),  //input [31:0] local0_rdat_i
    //      .local0_rdat_vld_i(1'b1),  //input local0_rdat_vld_i
    //      .local0_wdat_rdy_i(1'b1),  //input local0_wdat_rdy_i
    //      .uart_rx_led_o(leds[2]),  //output uart_rx_led_o
    //      .uart_tx_led_o(leds[3]),  //output uart_tx_led_o
    //      .uart_rx_i(uart_rx),  //input uart_rx_i
    //      .uart_tx_o(uart_tx)  //output uart_tx_o
    //  );

endmodule
