
/*
# Team ID:          3987
# Theme:     	     Ecomender bot
# Author List:      Tejas choudary,Guru prasath,Naman goyal,Himesh Jha
# Filename:     	  Top_Level.v
# File Description: Top level module consists of all modules in integrated way
*/


module Top_Level(
input clk_50MHz,//50Mhz clock signal
input cs_out,//colour sensor out values 
input start,//To get start signal from push button 
output [2:0] rgb1,rgb2,rgb3,rgb4,//To provide color values to rgb led
output S2,S3,S0,S1,OE,//Scaling variable in colour sensor 
output tx,// tx output for bluetooth 
input dig_out, //AT pin A9 DIG O/P OF ANALOG PINS 1,4,3 COMES FROM LFA
output clk_3125KHz,//3125KHz clock signal
output  in1, in2, in3, in4, // motor direction output for motor driver
output  pwm_A,pwm_B,//pwn signals for motor driver to control speed of the motor 
output adc_cs_n,din//A10,B10
);
		wire tx_done;
		wire[1:0] filter;
		wire tx_start;
		wire [7:0] msg;
		wire clk_1MHz;
		wire[2:0] color;
      wire finish;
		wire node_detected;
reg[2:0] blink=3'b010;		
assign rgb1=finish?blink:color;
assign rgb2=finish?blink:color;
assign rgb3=finish?blink:color;
assign rgb4=finish?blink:color;
assign S0=1;
assign S1=0;
assign OE=0;
assign {S2,S3}=filter;	
wire[3:0] node_counter;
		
freq_scaling scaling_1(clk_50MHz,clk_3125KHz);//module used to get 3125KHz clock from 50MHz
freq_scaling_1Mhz scaling_2(clk_50MHz,clk_1MHz);//module used to get 1MHz from 50MHz

color_detection color_sensor(clk_1MHz, cs_out,filter,color);//module used to get csout signal by providing filter and scaling to colour sensor 
reg[19:0] counter=0;
always@(posedge clk_1MHz) begin
/*
Purpose:
---
	Used for blinking led after finish flag 
*/
	if(counter<1000000)counter<=counter+1;
	else begin counter<=0;blink[1]<=~blink[1]; end

end


uart_tx  uart(clk_3125KHz,1'b0,tx_start,msg,tx,tx_done);//Module used to provide tx for bluetooth module 
uart_tx_data color_uart_node(color,node_counter,node_detected,clk_3125KHz,tx_done,tx_start,msg);//Module provides messages in binary form to uart_tx module for bluetooth transmition



top_level_line_following lf(//top which consists of code for line following 
		~start,
      dig_out, //AT pin A9 DIG O/P OF ANALOG PINS 1,4,3 COMES FROM LFA
	   clk_50MHz,
		clk_3125KHz,
		in1, in2, in3, in4,pwm_A,pwm_B,
	   adc_cs_n,din,
		node_counter,node_detected,//A10,B10	
		finish
		);
endmodule




