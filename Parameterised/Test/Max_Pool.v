`timescale 1ns / 1ps

module Kernel_tester();
    parameter DEPTH = 8;
    parameter KX = 3;
    parameter KY = 3;
    parameter AX = 8;
    parameter AY = 8;
    
    reg [DEPTH*AX*AY-1:0] A;
    wire [DEPTH*(AX-KX+1)*(AY-KY+1)-1:0] B;
    wire [DEPTH-1:0] C [0:(AX-KX)][0:(AY-KY)];
    wire [DEPTH-1:0] Matrixes [0:AX-1][0:AY-1];
    
    Kernel_Pooler #(
        .DEPTH(DEPTH),
        .KX(KX),
        .KY(KY),
        .AX(AX),
        .AY(AY)
    ) uut (
        .A(A),
        .B(B)
    );
    
    genvar i, j;
    generate  
        for (i = 0; i < AX-KX+1; i = i+1) begin: x
            for (j = 0; j < AY-KY+1; j = j+1) begin: y
                assign C[i][j] = B[(i * (AY-KY+1) + j) * DEPTH +: DEPTH];
            end
        end
    endgenerate 
    
    generate
        for (i = 0; i < AX; i = i + 1) begin: z
            for (j = 0; j < AY; j = j + 1) begin: w
                assign Matrixes[i][j] = A[(j * AX + i) * DEPTH +: DEPTH];
            end
        end
    endgenerate
    
    initial begin

        A = {
            8'd10, 8'd20, 8'd30, 8'd40, 8'd50, 8'd60, 8'd70, 8'd80,
            8'd90, 8'd100, 8'd110, 8'd120, 8'd130, 8'd140, 8'd150, 8'd160,
            8'd170, 8'd180, 8'd190, 8'd200, 8'd210, 8'd220, 8'd230, 8'd240,
            8'd250, 8'd1, 8'd2, 8'd3, 8'd4, 8'd5, 8'd6, 8'd7,
            8'd8, 8'd9, 8'd10, 8'd11, 8'd12, 8'd13, 8'd14, 8'd15,
            8'd16, 8'd17, 8'd18, 8'd19, 8'd20, 8'd21, 8'd22, 8'd23,
            8'd24, 8'd25, 8'd26, 8'd27, 8'd28, 8'd29, 8'd30, 8'd31,
            8'd32, 8'd33, 8'd34, 8'd35, 8'd36, 8'd37, 8'd38, 8'd39
        };
        
        #3000;  
        $finish;
    end
endmodule
