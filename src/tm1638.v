module tm1638 #(
    parameter CLK_DIV_FACTOR = 27
) (
    input wire clk,
    input wire rst,

    input wire [7:0] disp_1,

    input wire [7:0] data_in,
    input wire data_in_wait,
    input wire data_in_read,
    input wire data_in_valid,
    output wire data_in_ready,

    input  wire tm_data_in,
    output wire tm_data_out,
    output wire tm_data_dir,
    output wire tm_clk_out,
    output wire tm_stb_out
);

    localparam IDLE_STATE = 0;
    localparam WRITE_STATE = 1;
    localparam READ_STATE = 2;
    localparam WAIT_STATE = 3;

    wire clk_posedge;
    wire transmitter_idle;

    reg [1:0] state;
    reg [$clog2(CLK_DIV_FACTOR)-1:0] clk_div_counter;
    reg divided_clock;

    reg [7:0] data;
    reg [4:0] data_count;

    assign data_in_ready = (((state == READ_STATE | state == WRITE_STATE) & data_count <= 1) | state == IDLE_STATE | state == WAIT_STATE) & clk_posedge;

    assign clk_posedge = ~divided_clock & clk_div_counter == 0;

    assign tm_data_out = data[0];
    assign tm_data_dir = 1;
    assign tm_clk_out = (tm_stb_out | ~divided_clock) | !(data_count > 1);
    assign tm_stb_out = ~(state == READ_STATE | state == WRITE_STATE);

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
            state <= IDLE_STATE;
        end else if (!clk_posedge) begin
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
            data_count <= 0;
        end else if (!clk_posedge) begin
            // Start only on divided clock posedge
        end else if (data_in_ready & data_in_valid & !data_in_wait) begin
            data <= data_in;
            data_count <= 9;
        end else begin
            data <= {1'b0, data[7:1]};
            data_count <= data_count - 1;
        end
    end




    // assign transmitter_idle = data_count == 0 & (init_clear_counter == 0 | state != INIT_STATE_0);


    // always @(posedge clk) begin
    //     if (rst) begin
    //         state <= RESET_STATE;
    //     end else if (!clk_posedge) begin
    //         // Start only on divided clock posedge
    //     end else if (state == RESET_STATE) begin
    //         state <= INIT_STATE_0;
    //     end else if (state == INIT_STATE_0 && transmitter_idle) begin
    //         state <= INIT_STATE_1;
    //     end else if (state == INIT_STATE_1 && transmitter_idle) begin
    //         state <= INIT_STATE_2;
    //     end else if (state == INIT_STATE_2 && transmitter_idle) begin
    //         state <= IDLE_STATE;
    //     end
    // end

    // always @(posedge clk) begin
    //     if (rst) begin
    //         data <= 0;
    //         data_count <= 0;
    //     end else if (!clk_posedge) begin
    //         // Start only on divided clock posedge
    //     end else if (data_count != 0) begin
    //         data <= {1'b0, data[15:1]};
    //         data_count <= data_count - 1;
    //     end else if (state == INIT_STATE_0) begin
    //         data <= init_clear_counter == 11 ? 8'b01000000 : 8'h00;
    //         // data <= init_clear_counter == 11 ? 8'b01000000 : {init_clear_counter, init_clear_counter};
    //         data_count <= 8;
    //     end else if (state == INIT_STATE_1) begin
    //         data <= control_command;
    //         data_count <= 8;
    //     end else if (state == INIT_STATE_2) begin
    //         data <= {8'b11101011, address_command};
    //         data_count <= 16;
    //     end
    // end

    // always @(posedge clk) begin
    //     if (rst | state != INIT_STATE_0) begin
    //         init_clear_counter <= 12;
    //     end else if (!clk_posedge) begin
    //         // Start only on divided clock posedge
    //     end else begin
    //         if (data_count == 1 & init_clear_counter != 0) begin
    //             init_clear_counter <= init_clear_counter - 1;
    //         end
    //     end
    // end

endmodule
