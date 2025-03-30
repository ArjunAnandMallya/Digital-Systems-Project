    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 19.03.2025 00:27:00
    // Design Name: 
    // Module Name: kernalpooling
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
    
    
    module kernalpooling(
    input[71:0] b, output [7:0] out
        );
        parameter DWIDTH=8, XWIDTH=3, YWIDTH=3;
        integer i , j;
        wire [7:0] ad0,ad1,ad2,ad3,ad4,ad5;

        reg [DWIDTH-1:0] matrix_rebuild [0:XWIDTH-1][0:YWIDTH-1];
        integer xr,yr;
        always @* begin
           for (xr=0; xr<XWIDTH; xr=xr+1)
             for (yr=0; yr<YWIDTH; yr=yr+1)
               matrix_rebuild[xr][yr] = b[(xr*XWIDTH+yr)*DWIDTH +: DWIDTH];
        end
        AbsoluteDeviation uut0(.ad(ad0),.x1(matrix_rebuild[0][0]) , .x2(matrix_rebuild[0][1]));
         AbsoluteDeviation uut1(.ad(ad1),.x1(matrix_rebuild[0][1]) , .x2(matrix_rebuild[0][2]));
         AbsoluteDeviation uut2(.ad(ad2),.x1(matrix_rebuild[1][0]) , .x2(matrix_rebuild[1][1]));
         AbsoluteDeviation uut3(.ad(ad3),.x1(matrix_rebuild[1][1]) , .x2(matrix_rebuild[1][2]));
         AbsoluteDeviation uut4(.ad(ad4),.x1(matrix_rebuild[2][0]) , .x2(matrix_rebuild[2][1]));
         AbsoluteDeviation uut5(.ad(ad5),.x1(matrix_rebuild[2][1]) , .x2(matrix_rebuild[2][2]));
         ALSU uut7(.ad0(ad0),.ad1(ad1),.ad2(ad2),.ad3(ad3), .ad4(ad4),.ad5(ad5), .out(out));
            
    endmodule
