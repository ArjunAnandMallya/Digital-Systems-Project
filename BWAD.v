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


module BWAD #( parameter WIDTH = 8, ROWSIZE = 5, COLSIZE = 5
        
    )(input [(WIDTH*ROWSIZE*COLSIZE)-1:0]inp , output [(WIDTH*2*2)-1:0] out );
    

    wire [71:0]temp1, temp2, temp3 , temp4;
    genvar i, j;
    generate
      for (i = 0; i < 3; i = i + 1) begin : row_loop
        for (j = 0; j < 3; j = j + 1) begin : col_loop
 
          assign temp1[ ((3*i+j)*8):((3*i+j)*8 + 7) ] = inp[((5*i+j)*8 ) : ((5*i+j)*8)+7];
          assign temp2[((3*i+j)*8):((3*i+j)*8 + 7)] = inp[((5*(i+1)+j)*8 ) : ((5*(i+1)+j)*8)+7];
          assign temp3[((3*i+j)*8):((3*i+j)*8 + 7)] = inp[((5*i+(j+1))*8 ) : ((5*i+j+1)*8)+7];
          assign temp4[((3*i+j)*8):((3*i+j)*8 + 7)] = inp[((5*(i+1)+j+1)*8) : ((5*(i+1)+j)*8)+7];
        end
      end
    endgenerate
    kernalpooling uut1 (.b(temp1), .out( out[0:7]));
    kernalpooling uut2 (.b(temp2), .out( out[8:15]));
    kernalpooling uut3 (.b(temp3), .out( out[16:23]));
    kernalpooling uut4 (.b(temp4), .out( out[24:31]));    
    
    
endmodule
