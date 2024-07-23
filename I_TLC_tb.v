`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.06.2024 10:29:02
// Design Name: 
// Module Name: I_TLC_tb
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
module I_TLC_tb;
reg c,rst,clk;
wire [2:0] main,side;
I_TLC DUT(.sensor(c),.clock(clk),.reset(rst),.M(main),.S(side));
initial
  begin
  clk=1'b0;
    forever #5  clk=~clk;
  end
initial
   begin
   rst=1; 
   #15;// 1ns=10^-9 sec ; now it is 1sec
   rst=0; c=0;
   #15;
   c=1;
     #15;
   c=1;
   #15;
   rst=0;
   #15;
     c=1;
     #185;
     c=0;
     #30;
     rst=1;
   end
 initial
   begin
   $dumpfile("TLC.vcd");
   $dumpvars(0,I_TLC_tb);
   $monitor("time=%b,sensor=%b,rst=%b,M=%b,S=%b",$time,c,rst,main,side);
   #400 $finish;
   end
endmodule

