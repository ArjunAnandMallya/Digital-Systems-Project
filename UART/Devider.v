module Devider(
    input clk,
    input enable,
    output current_clock);
    
    reg slow_clock = 0;
    reg [19:0] counter = 0;
    
    assign current_clock = enable ? slow_clock : clk;
    
    // Generate UART clock at 115200 baud
    always @(posedge clk) begin
        counter <= counter + 1;
        if(counter == 5'd27) begin
            counter <= 0;
            slow_clock <= ~slow_clock;
        end
    end
    
endmodule