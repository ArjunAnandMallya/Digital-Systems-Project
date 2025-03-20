`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: IIT Gandhinagar
// Engineer: Vivek Raj
// 
// Create Date: 21.03.2025 01:33:38
// Design Name: Max Selector
// Module Name: Kernel Pooler
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

module Kernel_Pooler #(
    parameter DEPTH = 8, 
    parameter KX = 3, 
    parameter KY = 3,     
    parameter AX = 8,      
    parameter AY = 8       
)(
    input [DEPTH*AX*AY-1:0] A, 
    output [DEPTH*(AX-KX+1)*(AY-KY+1)-1:0] B 
);


    wire [DEPTH-1:0] Matrixes [0:AX-1][0:AY-1];
    wire [DEPTH-1:0] Outputs [0:AX-KX][0:AY-KY];

    genvar i, j, l, m;
    generate
        for (i = 0; i < AX; i = i + 1) begin: x
            for (j = 0; j < AY; j = j + 1) begin: y
                assign Matrixes[i][j] = A[(j * AX + i) * DEPTH +: DEPTH];
            end
        end
    endgenerate

    generate
        for (i = 0; i <= AX-KX; i = i + 1) begin: pool_x
            for (j = 0; j <= AY-KY; j = j + 1) begin: pool_y
                

                wire [DEPTH*KX*KY-1:0] PoolBinary;         
                for (l = 0; l < KX; l = l + 1) begin: kernel_x
                    for (m = 0; m < KY; m = m + 1) begin: kernel_y
                        assign PoolBinary[(l * KY + m) * DEPTH +: DEPTH] = Matrixes[i + l][j + m];
                    end
                end

                Max max_unit(
                    .Input(PoolBinary), 
                    .Output(Outputs[i][j])
                );

                assign B[(i * (AY-KY+1) + j) * DEPTH +: DEPTH] = Outputs[i][j];

            end
        end
    endgenerate
endmodule
