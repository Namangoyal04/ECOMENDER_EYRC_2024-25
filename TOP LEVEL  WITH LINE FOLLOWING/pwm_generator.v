/*
# Team ID:          < 3987 >
# Theme:            < ECOMENDER >
# Author List:      < Naman >
# Filename:         < pwm_generator >
# File Description: < used for generating pwm signal for controlling speed of motors >
*/


module pwm_generator(
    input clk_3125KHz,
    input [7:0] pulse_width,
	 output reg  pwm_signal
);

initial begin

	 pwm_signal = 0;
end


reg[6:0] counter = 7'd0;           // <counter>: <used for generating pwm based on input pulse width>
                                        

always@(posedge clk_3125KHz)
/*
Purpose:Generates pwm signal
*/

begin 			
	  if(counter == (pulse_width))begin
		pwm_signal = 0;
		end
		else if(counter==0)begin
		pwm_signal=1;
		end		
		counter=counter+7'd1;
end


endmodule
