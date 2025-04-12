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


module avg(
input [7:0] ad0,ad1,ad2,ad3,ad4,ad5, output  [7:0] out
    );
   
  wire [15:0] f;
  assign f = ad0+ad1+ad2+ad3+ad4+ad5;
  assign out = f/6;
    
endmodule
