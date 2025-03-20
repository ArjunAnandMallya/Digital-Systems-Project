`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT Gandhinagar
// Engineer: Vivek Raj
// 
// Create Date: 21.03.2025 01:33:38
// Design Name: Max Selector Tester
// Module Name: Kernel Pooler Tester
// Project Name: S204
// Target Devices: FPGA
// Tool Versions: NA
// Description: NA
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Test_Max();

    parameter DEPTH = 8;
    parameter X = 3;
    parameter Y = 3;
    
    reg [DEPTH*X*Y-1:0] Test;
    wire [DEPTH-1:0] Output;
    
    Max #(
        .DEPTH(DEPTH),
        .X(X),
        .Y(Y)
    ) uut (
        .Input(Test),
        .Output(Output)
    );
   
     initial begin
       Test = {  8'd10, 8'd20, 8'd5, 8'd40, 8'd15, 8'd60, 8'd25, 8'd30, 8'd50 }; #100;
     end
    
endmodule
