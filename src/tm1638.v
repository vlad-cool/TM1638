module tm1638 #(
    parameter CLK_DIV_FACTOR = 14
) (
    input wire clk,
    input wire rst,

    input wire [7:0] data_in,
    input wire data_in_wait,
    input wire data_in_read,
    input wire data_in_valid,
    output wire data_in_ready,

    output reg [31:0] data_out,
    output wire data_out_valid,

    input  wire tm_miso,
    output wire tm_mosi,
    output wire tm_data_dir,
    output wire tm_clk_out,
    output wire tm_stb_out
);

    localparam IDLE_STATE = 0;
    localparam WRITE_STATE = 1;
    localparam READ_STATE = 2;
    localparam WAIT_STATE = 3;

    wire clk_posedge, clk_negedge;

    wire read_clk_active;

    reg [1:0] state;
    reg [$clog2(CLK_DIV_FACTOR)-1:0] clk_div_counter;
    reg divided_clock;

    reg [7:0] data;
    reg [4:0] data_write_count;

    reg [5:0] data_read_count;

    assign data_in_ready = ((state == READ_STATE & data_read_count <= 1) | (state == WRITE_STATE & data_write_count <= 1) | state == IDLE_STATE | state == WAIT_STATE) & clk_negedge;

    assign clk_negedge = ~divided_clock & clk_div_counter == 0;
    assign clk_posedge = divided_clock & clk_div_counter == 0;

    assign tm_mosi = data[0];
    assign tm_data_dir = data_read_count == 0;
    assign tm_clk_out = (tm_stb_out | ~divided_clock) | ((state != WRITE_STATE | data_write_count <= 1) & (state != READ_STATE | !read_clk_active));
    assign tm_stb_out = ~(state == READ_STATE | state == WRITE_STATE);

    assign read_clk_active = data_read_count != 'h26 & data_read_count != 'h25 & data_read_count != 'h1C & data_read_count != 'h13 & data_read_count != 'h0A & data_read_count != 'h01;

    assign data_out_valid = data_read_count == 1;

    always @(posedge clk) begin
        if (rst) begin
            clk_div_counter <= 0;
        end else begin
            clk_div_counter <= clk_div_counter == CLK_DIV_FACTOR - 1 ? 4'b0 : clk_div_counter + 1'b1;
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
            state <= IDLE_STATE;
        end else if (!clk_negedge) begin
            // Start only on divided clock posedge
        end else if (data_in_ready & data_in_valid) begin
            if (data_in_wait) begin
                state <= WAIT_STATE;
            end else if (data_in_read) begin
                state <= READ_STATE;
            end else begin
                state <= WRITE_STATE;
            end
        end else if (data_in_ready & ~data_in_valid) begin
            state <= IDLE_STATE;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            data <= 0;
            data_write_count <= 0;
        end else if (!clk_negedge) begin
            // Start only on divided clock posedge
        end else if (data_in_ready & data_in_valid & !data_in_wait & !data_in_read) begin
            data <= data_in;
            data_write_count <= 9;
        end else if (state == WRITE_STATE) begin
            data <= {1'b0, data[7:1]};
            data_write_count <= data_write_count - 1'b1;
        end
    end

    always @(posedge clk) begin
        if (rst) begin
            data_read_count <= 0;
        end else if (!clk_negedge) begin
            // Start only on divided clock posedge
        end else if (data_in_ready & data_in_valid & !data_in_wait & data_in_read) begin
            data_read_count <= 38;
        end else if (state == READ_STATE) begin
            data_read_count <= data_read_count - 1'b1;
        end
    end

    always @(posedge clk) begin
        if (clk_posedge & read_clk_active) begin
            data_out <= {data_out[30:0], tm_miso};
        end
    end

endmodule
