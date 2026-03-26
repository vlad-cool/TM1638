module tm1638_interface (
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
    input wire [7:0] disp_8,
    input wire [7:0] disp_9,
    input wire [7:0] disp_A,
    input wire [7:0] disp_B,
    input wire [7:0] disp_C,
    input wire [7:0] disp_D,
    input wire [7:0] disp_E,
    input wire [7:0] disp_F,

    output reg [31:0] btns,


    input  wire tm_data_in,
    output wire tm_data_out,
    output wire tm_data_dir,
    output wire tm_clk_out,
    output wire tm_stb_out
);

    wire data_in_ready;

    localparam INIT_LENGTH = 27;

    wire [9:0] initial_sequence[INIT_LENGTH-1:0];

    wire [31:0] data_out_wire;
    wire data_out_valid;

    reg [4:0] counter;

    assign initial_sequence[0] = {1'b0, 1'b0, 8'b01000000};
    assign initial_sequence[1] = {1'b1, 1'b0, 8'b00000000};
    assign initial_sequence[2] = {1'b0, 1'b0, 8'b10001111};
    assign initial_sequence[3] = {1'b1, 1'b0, 8'b00000000};
    assign initial_sequence[4] = {1'b0, 1'b0, 8'b11000000};
    assign initial_sequence[5] = {1'b0, 1'b0, disp_0};
    assign initial_sequence[6] = {1'b0, 1'b0, disp_1};
    assign initial_sequence[7] = {1'b0, 1'b0, disp_2};
    assign initial_sequence[8] = {1'b0, 1'b0, disp_3};
    assign initial_sequence[9] = {1'b0, 1'b0, disp_4};
    assign initial_sequence[10] = {1'b0, 1'b0, disp_5};
    assign initial_sequence[11] = {1'b0, 1'b0, disp_6};
    assign initial_sequence[12] = {1'b0, 1'b0, disp_7};
    assign initial_sequence[13] = {1'b0, 1'b0, disp_8};
    assign initial_sequence[14] = {1'b0, 1'b0, disp_9};
    assign initial_sequence[15] = {1'b0, 1'b0, disp_A};
    assign initial_sequence[16] = {1'b0, 1'b0, disp_B};
    assign initial_sequence[17] = {1'b0, 1'b0, disp_C};
    assign initial_sequence[18] = {1'b0, 1'b0, disp_D};
    assign initial_sequence[19] = {1'b0, 1'b0, disp_E};
    assign initial_sequence[20] = {1'b0, 1'b0, disp_F};
    assign initial_sequence[21] = {1'b1, 1'b0, 8'b00000000};
    assign initial_sequence[22] = {1'b0, 1'b0, 8'b01000010};
    assign initial_sequence[23] = {1'b0, 1'b1, 8'b00000000};
    assign initial_sequence[24] = {1'b1, 1'b0, 8'b00000000};
    assign initial_sequence[25] = {1'b0, 1'b0, 8'b01000000};
    assign initial_sequence[26] = {1'b1, 1'b0, 8'b00000000};

    always @(posedge clk) begin
        if (!rst_n) begin
            counter <= 0;
        end else if (data_in_ready & counter < INIT_LENGTH - 1) begin
            counter <= counter + 1'b1;
        end else if (data_in_ready) begin
            counter <= 2;
        end
    end

    always @(posedge clk) begin
        if (!rst_n) begin
            btns <= 0;
        end else if (data_out_valid) begin
            btns <= data_out_wire;
        end
    end

    tm1638 TM1638 (
        .clk(clk),
        .rst(~rst_n),

        .tm_data_out(tm_data_out),
        .tm_data_in (tm_data_in),
        .tm_data_dir(tm_data_dir),
        .tm_clk_out (tm_clk_out),
        .tm_stb_out (tm_stb_out),

        .data_in(initial_sequence[counter][7:0]),
        .data_in_wait(initial_sequence[counter][9]),
        .data_in_read(initial_sequence[counter][8]),
        .data_in_valid(1'b1),
        .data_in_ready(data_in_ready),

        .data_out(data_out_wire),
        .data_out_valid(data_out_valid)
    );

endmodule
