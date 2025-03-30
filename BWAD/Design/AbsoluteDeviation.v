`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 00:07:32
// Design Name: 
// Module Name: AbsoluteDeviation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AbsoluteDeviation(input [7:0]x1, x2, output reg [7:0]ad

    );
 always @(*) begin
        if (x1 >= x2) begin 
            ad = x1 - x2;   
        end else begin
            ad = x2 - x1;   
        end
    end
    
    
endmodule
