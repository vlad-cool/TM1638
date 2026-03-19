module tm1638 #(
    parameter CLK_DIV_FACTOR = 27
) (
    input wire clk,
    input wire rst,

    input wire [7:0] disp_1,

    input  wire data_in,
    output wire data_out,
    output wire data_dir,
    output wire clk_out,
    output wire stb_out
);

    localparam RESET_STATE = 0;
    localparam INIT_STATE_0 = 1;
    localparam INIT_STATE_1 = 2;
    localparam INIT_STATE_2 = 3;
    localparam IDLE_STATE = 4;

    localparam [7:0] data_command = 8'b01000000;  // Fixed address, write
    localparam [7:0] control_command = 8'b10001111;  // On, max brightness
    localparam [7:0] address_command = 8'b11000000;

    wire clk_posedge;
    wire transmitter_idle;

    reg [3:0] state;
    reg [$clog2(CLK_DIV_FACTOR)-1:0] clk_div_counter;
    reg divided_clock;

    reg [15:0] data;
    reg [5:0] data_count;

    assign data_dir = 1;

    assign clk_posedge = ~divided_clock & clk_div_counter == 0;
    assign stb_out = data_count == 0;
    assign data_out = data[0];
    assign clk_out = stb_out | ~divided_clock;
    assign transmitter_idle = data_count == 0;

    always @(posedge clk) begin
        if (rst) begin
            clk_div_counter <= 0;
        end else begin
            clk_div_counter <= clk_div_counter == CLK_DIV_FACTOR - 1 ? 0 : clk_div_counter + 1;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            divided_clock <= 0;
        end else if (clk_div_counter == 0) begin
            divided_clock <= ~divided_clock;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            state <= RESET_STATE;
        end else if (!clk_posedge) begin
            // Start only on divided clock posedge
        end else if (state == RESET_STATE) begin
            state <= INIT_STATE_0;
        end else if (state == INIT_STATE_0 && transmitter_idle) begin
            state <= INIT_STATE_1;
        end else if (state == INIT_STATE_1 && transmitter_idle) begin
            state <= INIT_STATE_2;
        end else if (state == INIT_STATE_2 && transmitter_idle) begin
            state <= IDLE_STATE;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            data <= 0;
            data_count <= 0;
        end else if (!clk_posedge) begin
            // Start only on divided clock posedge
        end else if (data_count != 0) begin
            data <= {1'b0, data[15:1]};
            data_count <= data_count - 1;
        end else if (state == INIT_STATE_0) begin
            data <= data_command;
            data_count <= 8;
        end else if (state == INIT_STATE_1) begin
            data <= control_command;
            data_count <= 8;
        end else if (state == INIT_STATE_2) begin
            data <= {8'b11101011, address_command};
            data_count <= 16;
        end
    end

endmodule
