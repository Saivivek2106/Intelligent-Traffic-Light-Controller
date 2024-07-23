`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Medipally Saivivek
// 
// Create Date: 25.06.2024 10:45:15
// Design Name: 
// Module Name: I_TLC
// Project Name: Intelligent traffic light controller using FSM
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
module I_TLC(
    input sensor,   //sensor detect the vehicles or pedestrains on side road
    input clock,
    input reset,
  output reg [2:0] M,  //main road light
  output reg [2:0] S   //side road light
    );
    reg [3:0] count;
    parameter TL=10,TS=6;  //in sec
                           //TL-> time larger, TS-> time smaller
    reg [1:0] ps; //ps-->present state
    parameter s0=2'b00,s1=2'b01,s2=2'b10,s3=2'b11;
    always@(posedge clock )
    if(reset)
    begin 
    ps<=s0;
    count<=0;
    end
    else
    case(ps)
    s0:                             //  green light on main road and red light on side road
                                   // if sensor is low, irrespective of timer, it should stay in s0
      if(~sensor || count<TL)
      begin
      ps<=s0;
      count<=count+1;
      end
      else if(sensor && count==TL)
      begin
      ps<=s1;
      count<=0;
      end
    s1:                                // if TS expires, then irrespective of sensor, it must go to s2 because we allowed traffic on main road for
                                      // TL+TS duration. It remains in same state until TS expires
      if(count<TS && sensor)
          begin
          ps<=s1;
          count<=count+1;
          end
        else if(count==TS)
          begin
          ps<=s2;
          count<=0;
          end
        else
          begin
          ps<=s1;
          end
     s2:
       if(sensor && count<TL)
          begin
          count<=count+1;
          ps<=s2;
          end
      else if(count==TL && ~sensor)
          begin
          ps<=s3;
          count<=0;
          end
      else if(~sensor && count<TL)
          begin
          ps<=s1;
          count<=count+1;
          end
      else if(sensor && count==TL)
           begin
           ps<=s3;
             count<=0;
           end
      s3:
        if (count<TS)             //(count<TS & sensor)
        begin
        ps<=s3;
        count<=count+1;
        end
      else if(count==TS)                 //(~sensor & count==TS)
        begin
        ps<=s0;
        count<=0;
        end
      default:
      ps<=s0;
    endcase
    always@(ps)
    case(ps)
    s0: begin
      M<=001;
      S<=100;
      end
    s1:
      begin
      M<=010;
      S<=100;
      end
    s2:
      begin
      M<=100;
      S<=001;
      end
    s3:
      begin
      M<=100;
      S<=010;
      end
   default: begin
      M<=001;
      S<=100;
      end
   
    endcase
endmodule



