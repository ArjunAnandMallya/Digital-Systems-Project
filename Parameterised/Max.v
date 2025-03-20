`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: IIT Gandhinagar
// Engineer: Vivek Raj
// 
// Create Date: 20.03.2025 19:33:38
// Design Name: Max Selector
// Module Name: Max Pooler
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

module Max #(
    parameter DEPTH = 8,
    parameter X = 3,
    parameter Y = 3
)(
    input [DEPTH*X*Y-1:0] Input,
    output reg [DEPTH-1: 0] Output
    );
    wire [DEPTH-1: 0] Matrixes [0:X-1][0:Y-1];
    genvar i, j, counter;
    
    generate
        for (i = 0; i<X; i = i+1) begin: x
            for (j = 0; j<Y; j=j+1) begin: y
                 assign Matrixes[i][j] = Input[(j*X + i + 1) * DEPTH - 1 -: DEPTH];
              end
          end
     endgenerate
     
    reg [DEPTH-1: 0] rtn_val;
    integer l, m;
    always @* begin
        rtn_val = Matrixes[0][0];
        
         for (l = 0; l<X; l = l+1) begin: a
            for (m = 0; m<Y; m=m+1) begin: b
                if(Matrixes[l][m] > rtn_val)
                    rtn_val = Matrixes[l][m];
            end
         end
        
        Output = rtn_val;
    end 
    
endmodule
