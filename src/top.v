module top (
    input wire clk,
    input wire rst_n,

    output wire tm_stb,
    output wire tm_clk,
    inout wire tm_dio
);

wire tm_data_in;
wire tm_data_out;
wire tm_data_dir;

assign tm_data_out = tm_dio;
assign tm_dio = tm_data_dir ? tm_data_in : 1'b1;

tm1638 TM1638 (
    .clk(clk),
    .rst(~rst_n),

    .data_out(tm_data_in),
    .data_in(tm_data_out),
    .data_dir(tm_data_dir),
    .clk_out(tm_clk),
    .stb_out(tm_stb)
);

endmodule
