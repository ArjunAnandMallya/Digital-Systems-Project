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
    wire signed [8:0] f ;
    assign f = x1-x2;
    always @(*) begin
    if (f >0)begin
    ad = f;
    end
    else begin
    ad = -1 * f;
    end
    
    
    end
    
    
endmodule
