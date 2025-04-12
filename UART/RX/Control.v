module RX_Controller (
    input clk,
    input rx,
    output reg done,
    output reg enable,
    output reg [13:0] addr,
    output reg [7:0] data,
    output rx_busy
);

    // UART RX
    wire [7:0] rx_data;
    wire rx_converted;
    wire rx_data_valid;
    reg flush = 0;
    reg [13:0] counter = 0;

    // FSM states
    parameter [2:0] IDLE = 0;
    parameter [2:0] RECEIVE = 1;
    parameter [2:0] DONE = 2;
    reg [2:0] state = IDLE;

    // UART RX instance
    uart_rx uart (
        .rx(rx),
        .i_clk(actual_clock),
        .flush(flush),
        .data(rx_data),
        .converted(rx_converted),
        .data_valid(rx_data_valid),
        .busy(rx_busy)
    );

    always @(posedge actual_clock) begin
        case (state)
            IDLE: begin
                flush <= 0;
                done <= 0;
                enable <= 0;
                counter <= 0;
                state <= RECEIVE;
            end

            RECEIVE: begin
                if (rx_converted && rx_data_valid) begin
                    enable <= 1;
                    addr <= counter;
                    data <= rx_data;
                    counter <= counter + 1;
                    flush <= 1;
                end else begin
                    enable <= 0;
                    flush <= 0;
                end

                if (counter == 16384) begin
                    state <= DONE;
                end
            end

            DONE: begin
                done <= 1;
                enable <= 0;
                flush <= 0;
            end
        endcase
    end
endmodule
