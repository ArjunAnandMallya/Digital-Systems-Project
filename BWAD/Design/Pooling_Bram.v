
`timescale 1ns / 1ps

module Pooling_Bram(input clk,start,input [1:0] mode, input [15:0] infer_addr, output [7:0] infer_dout, output reg done, output reg [3:0] curr_state);

//parametrisation

parameter inpsize = 7*7;
parameter x = 7;
parameter outsize = 3*3;

parameter k = 3;
parameter stride = 2;
reg [3:0] state = 4'b0000; //start state
reg [15:0] counter;
reg [15:0] i;
reg[15:0] j;
reg [8:0] movex, movey;
reg [15:0] writecounter;
reg ren;
reg wen;
reg [15:0] addr;
reg [7:0] din;

wire [7:0] dout;
reg [(8*k*k)-1:0] flattened;
reg [7:0] pooled_results;
wire [7:0] pooling_module_out,pooling_module_out_max,pooling_module_out_amd;


kernalpooling uut(
    .b(flattened), .out(pooling_module_out)

        );
Maxpooling uut34 (.Input(flattened), .Output(pooling_module_out_max));
kernalpoolingmax uut14( .b(flattened), .out(pooling_module_out_amd));


//STATES:
// 0000 -> start
// 0001 -> read
// 0010 -> idle1
// 0011 -> idle2
// 0100 -> store in flattened
// 0101 -> Pooling
// 0110 -> Write
// 0111 -> idle 3
// 1000 -> idle 4
// 1001 -> Stop
reg [15:0] counter1;
reg [15:0] writecounter1;
reg ren1;
reg wen1;
reg [15:0] addr1;
reg [7:0] din1;

wire [7:0] dout1;
assign infer_dout = dout1;
BRAM inst1(.clk(clk), .en(ren || wen), .ren(ren), .wen(wen), .addr(addr), .din(din), .dout(dout));
BRAMout inst2(.clk(clk), .en(ren1 || wen1), .ren(ren1), .wen(wen1), .addr(addr1), .din(din1), .dout(dout1));



always @ (posedge clk)
begin
    case(state)
    
        4'b0000: //start state
        begin //initializing all the wires and regs
                addr <= 0;
                din <= 0;
                ren <= 0;
                wen <= 0;
                counter <= 0;
                i <=0;
                j<=0;
                movex<= 0;
                movey <= 0;
                writecounter <= 0;
                addr1 <= 0;
                din1 <= 0;
                ren1 <= 0;
                wen1 <= 0;
                counter1 <= 0;
                
                
                done <= 0;
                curr_state <= 4'b0000; 
            if(start) state <= 4'b0001; // if start is 1, move to read state
            else begin state <= 4'b0000; // if start is 0, stay in the same state
        
            curr_state <= 4'b0000; end 
        end
        
        4'b0001: // read state
        begin
            ren <= 1; // set readenable to 1
            wen <= 0;
            addr <= ((j+movey)*x + i+movex); // movex,movey represents leftmost corner of kernel, i,j represnets the indexs of each element in the kernel
            state <= 4'b0010; // go to idle 1
            curr_state <= 4'b0001;
        end
        
        4'b0010: // idle1 state
        begin
            state <= 4'b0011; //go to idle 2
            curr_state <= 4'b0010;
        end
        
        4'b0011: // idle2 state
        begin
            ren <= 0;
            wen <= 0;
            state <= 4'b0100; 
            curr_state <= 4'b0011;
        end
        4'b0100: // store in flattened 
        begin
        curr_state <= 4'b0100;
        flattened[ (counter * 8) +: 8 ] = dout; //store it in the respective index of flattened
        if (counter == (k*k) -1 ) begin //if all elements in the kernel have been traversed, then move to pooling state
        counter<=0; //reset counter, i , j for the next kernel
        i<=0;
        j<=0;
        state <= 4'b1001;
       

        end
        else begin
        counter <= counter + 1; // update counter
        // if i has not reached k-1, update i, else reset i and increment j
        if (i == k-1) begin
            i <= 0;
            j <= j + 1; // Increment j when i wraps
        end else begin
            i <= i + 1;
        end
        state <= 4'b0001; // Go back to read next kernel element
        end
        end
        
        4'b1001: // stote pooled results
        begin
        if (mode == 0)pooled_results <= pooling_module_out; // storepooled results for BWAD if mode is 0 
        else if (mode == 1) pooled_results <= pooling_module_out_amd;  // store pooled results for AMD if mode is 1
        else if (mode ==2) pooled_results <= pooling_module_out_max; // store pooled results for MAX pooling if mode is 2;
        state<= 4'b0101;
        end
        
        4'b0101: // write state
        begin
            din1 <= pooled_results; //use din1 which is the data in of bram1
            addr1 <= counter1; 
            wen1 <= 1; // set write enable to 1
            ren1 <= 0;
            
            state <= 4'b0110;
            curr_state <= 4'b0101;
        end
    
        4'b0110: begin // idle3 state
        counter1 <= counter1+ 1;
         state <= 4'b0111;
            curr_state <= 4'b0110;
            end
        
        4'b0111: // idle4 state 
        begin
            ren1 <= 0;
            wen1 <= 0;
            // if movex has not reached the end of image, then increment movex by stride
            //else reset movex and check if movey has reached end of image
            if (movex + stride <= (x-k)) begin
                movex <= movex + stride;
                i <= 0;
                j <= 0;
                counter<= 0;
                state <= 4'b0001;
            end
            else begin
                movex <= 0;
                if (movey +stride <= (x- k))begin
                    movey <= movey +stride;
                    i <= 0;
                    j <= 0;
                    counter <= 0;
                    state <= 4'b0001;
                end 
                else begin
            state <= 4'b1000;
                end

            end
            

            curr_state <= 4'b0111;
     
        end
        
        4'b1000: //stop state
        begin
            done <= 1; // set done flag to 1 to indicate that output image has been computed
            state <= 4'b1000;
            ren1 <= 1;
            wen1 <= 0;
            addr1 <= infer_addr;//set bram1 read address
            curr_state <= 4'b1000;
        end
        
        default: state <= 4'b0000;
    endcase
end
endmodule
