`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 11:10:37
// Design Name: 
// Module Name: BWADPooling
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


module BWADPooling(

    );
    reg [(16*8) -1: 0] inp ;
    wire [31:0] out;
    
    BWAD uut (.inp(inp), .out(out));
    
    initial begin
    
    inp = {8'd1, 8'd4, 8'd3, 8'd5, 8'd2,8'd1,8'd1,8'd3,8'd6,8'd0,8'd2,8'd0, 8'd2,8'd5,8'd6,8'd7};
    
    #10
    
    $finish();
    
    end
    
endmodule
