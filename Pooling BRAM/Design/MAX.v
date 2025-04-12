`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2025 10:14:16
// Design Name: 
// Module Name: MAX
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


module MAX(
input [7:0] ad0,ad1,ad2,ad3,ad4,ad5, output reg [7:0] out
    );
   
    always @ (*)begin
    out =ad0;
    if (ad1>out) out = ad1;
    if (ad2>out) out= ad2;
    if (ad3>out) out = ad3;
    if (ad4 >out) out = ad4;
    if (ad5> out) out = ad5;


    end
    
endmodule
