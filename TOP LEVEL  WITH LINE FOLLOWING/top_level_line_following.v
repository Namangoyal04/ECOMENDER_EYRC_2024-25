/*
# Team ID:          < 3987>
# Theme:            < ECOMENDER >
# Author List:      < Guru,Naman,Himesh>
# Filename:         < top_level_line_following >
# File Description: < this is a integrating file created for integrating pwm generator,line follower data processing and line following,to make the bot follow the line >
*/
module top_level_line_following(
      input       start,
      input       dig_out, 
	  input       clk_50MHz,
	  input       clk_3125KHz,
	  output      in1, in2, in3, in4, 
	  output      pwm_A,pwm_B,
	  output      adc_cs_n,din,	
	  output[3:0] node_counter,
	  output      node_detected,
	  output      finish
	);
		
		
	wire [7:0]enA,enB;
	wire [11:0] ld1,ld2,ld3;	
	ADC_Controller adc_control(dig_out,clk_3125KHz,adc_cs_n,din,ld1,ld2,ld3);
	Line_Following lfa_sensor(start,clk_3125KHz,ld1,ld2,ld3,in1,in2,in3,in4,enA,enB,node_counter,node_detected,finish);	
	pwm_generator pwm_1(clk_3125KHz,enA,pwm_A);
	pwm_generator pwm_2(clk_3125KHz,enB, pwm_B);

endmodule

