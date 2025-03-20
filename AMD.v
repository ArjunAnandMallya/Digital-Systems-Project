`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.03.2025 11:11:36
// Design Name: 
// Module Name: BWAD
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


module AMD (input [(8*4*4)-1:0]inp , output [(8*2*2)-1:0] out );
    

    wire [71:0]temp1, temp2, temp3 , temp4;
    genvar i, j;
    generate
      for (i = 0; i < 3; i = i + 1) begin : row_loop
        for (j = 0; j < 3; j = j + 1) begin : col_loop
 
          assign temp1[ ((3*i+j)*8)+7 : ((3*i+j)*8) ] = inp[ ((4*i+j)*8)+7 : ((4*i+j)*8 ) ];
          assign temp2[((3*i+j)*8)+7 : ((3*i+j)*8)] = inp[  ((4*(i+1)+j)*8)+7 :((4*(i+1)+j)*8 )];
          assign temp3[((3*i+j)*8)+7 : ((3*i+j)*8)] = inp[ ((4*i+j+1)*8)+7 : ((4*i+(j+1))*8 ) ];
          assign temp4[((3*i+j)*8)+7 : ((3*i+j)*8)] = inp[((4*(i+1)+j+1)*8)+7: ((4*(i+1)+j+1)*8)];
        end
      end
    endgenerate 
    kernalpoolingmax uut1 (.b(temp1), .out( out[7:0]));
    kernalpoolingmax uut2 (.b(temp2), .out( out[15:8]));
    kernalpoolingmax uut3 (.b(temp3), .out( out[23:16]));
    kernalpoolingmax uut4 (.b(temp4), .out( out[31:24]));    
    // 
    
endmodule
