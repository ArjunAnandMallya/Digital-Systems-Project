module Controller(
    input clk,
    input reset,
    input start_pooling,
    input rx,
    input RXEnable,
    output rx_done,
    output tx,
    output tx_busy,
    output done_uart,
    output pooling_done,
    output disabled,
    input [1:0] mode
);

    // Pooling Utils
    wire [7:0] infer_dout;
    wire done_pooling;
    wire [3:0] pool_state;
    wire actual_clock;
    reg [11:0] read_addr = 0;
    
    Devider clk_devider(clk, done_pooling, actual_clock);
    
    wire WBRAM;
    wire [7:0] WBRAMDATA;
    wire [13:0] WBRAMaddress;
    wire RXDone;
    
    assign rx_done = RXDone;
    
    
    imrx rxControl(
        .clk(clk),
        .reset(reset),
        .ena(RXEnable),
        .RxD(rx),
        .addr(0),
        .dout(),
        .ImRxComplete(RXDone),
        .ena_imrx(),
        .wea_imrx(WBRAM),
        .din_imrx(WBRAMDATA),
        .addr_imrx(WBRAMaddress)
          
    );
    

    // UART
    reg tx_enable = 0;
    reg [7:0] tx_data;
    reg [19:0] counter;
    reg completed = 0;
   
    // FSM states
    parameter [4:0] IDLE = 0;
    parameter [4:0] INIT = 1;
    parameter [4:0] READ_WAIT = 2;
    parameter [4:0] LOAD_TX = 3;
    parameter [4:0] TX_PULSE = 4;
    parameter [4:0] TX_WAIT = 5;
    parameter [4:0] IDLE1 = 6, IDLE2 = 7;
    parameter [4:0] RX = 8, RXDONE = 9;
    reg [4:0] state = IDLE;

    // UART TX
    reg [15:0] transmit_counter = 0;

    // Pooling instance
    Pooling_Bram pooling (
        .clk(actual_clock),
        .start(start_pooling),
        .infer_addr(read_addr),
        .infer_dout(infer_dout),
        .done(done_pooling),
        .mode(mode),
        .WBRAM(WBRAM),
        .WBRAMDATA(WBRAMDATA),
        .WBRAMaddress(WBRAMaddress)
        
    );

    // UART TX instance
    uart_tx uart (
        .clk(actual_clock),
        .tx_enable(tx_enable),
        .data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );
    
    // Debug Lights
    assign disabled = completed;
    assign pooling_done = done_pooling;
    assign done_uart = (transmit_counter == 63*63 - 1);

    always @(posedge actual_clock, posedge reset) begin
        if (reset) begin
            // Reset all the important signals
            state <= IDLE;
            tx_enable <= 0;
            tx_data <= 0;
            transmit_counter <= 0;
            read_addr <= 0;
            completed <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (RXEnable) state <= RX;
                end
                
                RX: begin
                    if (rx_done) state <= RXDONE;
                end
                
                RXDONE: begin
                    tx_enable <= 0;
                    if (done_pooling) begin
                        transmit_counter <= 0;
                        read_addr <= 0;
                        state <= INIT;
                    end
                end

                INIT: begin
                    tx_enable <= 0;
                    state <= READ_WAIT;
                end

                READ_WAIT: begin
                    tx_enable <= 0;
                    state <= IDLE1;
                end
                
                IDLE1: begin
                    state <= IDLE2;
                end
                
                IDLE2: begin
                    state <= LOAD_TX;
                end

                LOAD_TX: begin
                    if (!tx_busy) begin
                        tx_data <= infer_dout;
                        tx_enable <= 1;
                        state <= TX_PULSE;
                    end
                end

                TX_PULSE: begin
                    tx_enable <= 0;
                    state <= TX_WAIT;
                end

                TX_WAIT: begin    
                        transmit_counter <= transmit_counter + 1;
                        read_addr <= transmit_counter + 1;

                        if (transmit_counter == (63*63 - 1)) begin
                            state <= IDLE;
                        end else begin
                            state <= READ_WAIT;
                        end
                end
            endcase
        end
    end
endmodule
