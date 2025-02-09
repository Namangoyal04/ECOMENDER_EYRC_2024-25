
/*
# Team ID:          < 3987 >
# Theme:            < ECOMENDER >
# Author List:      < Himesh,Tejas,Naman,Guru >
# Filename:         <color_detection.v>
# File Description: < Short description about the code file >
# Global variables: < List of global variables defined in this file, None if no global variables >
*/


//Color Detection
//Inputs : clk_1MHz, cs_out
//Output : filter, color

// Module Declaration
module color_detection (
    input  clk_1MHz, cs_out,
    output [1:0] filter,output reg[2:0] color
);

// red   -> color = 4;
// green -> color = 2;
// blue  -> color = 1;

reg[1:0] state; 						// < state >: < state variable of color detection fsm >
parameter[1:0] blue_check=2'b01;        // < blue_check >: < state for checking blue frequency >
parameter[1:0] green_check=2'b11;       // < green_check >: < state for checking green frequency >
parameter[1:0] red_check=2'b00;         // < red_check >: < state for checking red frequency >
parameter[1:0] clear=2'b10;             // < clear>: < state for reseting counters >

reg[31:0] counter=0;				    // < counter >: < counter for adjusting sampling time for each color frequency >
reg[31:0] frequency_counter_red=0;      // < frequency_counter_red >: < register for storing red frequency >
reg[31:0] frequency_counter_blue=0;     // < frequency_counter_blue >: < register for storing blue frequency >
reg[31:0] frequency_counter_green=0;    // < frequency_counter_green >: < register for storing green frequency >
wire [31:0] diff_red_green;             // < diff_red_green>:  < wire for absolute difference between red and green frequency,to be used for white arena detection >
wire[31:0] diff_blue_green;				// < diff_blue_green>: < wire for absolute difference between blue and green frequency,to be used for white arena detection >
wire[31:0] diff_blue_red;               // < diff_blue_red>:   < wire for absolute difference between blue and red frequency,to be used for white arena detection >

initial begin // editing this initial block is allowed
   state=green_check;  color = 0;
end

wire[31:0] diff_added;     // < diff_added >: < wire for addition of absolute differences of frequencies >
assign diff_red_green=frequency_counter_red>frequency_counter_green?frequency_counter_red-frequency_counter_green:frequency_counter_green-frequency_counter_red;
assign diff_blue_green=frequency_counter_blue>frequency_counter_green?frequency_counter_blue-frequency_counter_green:frequency_counter_green-frequency_counter_blue;
assign diff_blue_red=frequency_counter_red>frequency_counter_blue?frequency_counter_red-frequency_counter_blue:frequency_counter_blue-frequency_counter_red;
assign diff_added=diff_red_green+diff_blue_green+diff_blue_red;
parameter[31:0] th=1599;              // // < th >: < threshold for diff_added,if th>diff_added => white color >
assign filter=(state!=clear)?state:green_check; // assigning filter value according to state
always@(posedge clk_1MHz) 
/*
Purpose:fsm for color detection
---
< this block is used for describing the fsm of color detection,the value of counter was decided by testing  >
*/
begin
	case(state)
	green_check: begin
					 
					 if(counter!=3999) begin counter=counter+1; end
					 else begin counter=0;state=red_check; end	
					 end
	red_check:	 begin					 
					 if(counter!=3999) begin counter=counter+1; end
					 else begin 
						counter=0;state=blue_check; 
						end	
					 end
	blue_check:	 begin					 
					 if(counter!=3999) begin counter=counter+1; end
					 else begin 
					 
					 if(frequency_counter_green >= frequency_counter_red && frequency_counter_green>=frequency_counter_blue) color=2;
					 else if( diff_added<=th) color=color;
					 else if( frequency_counter_red>=frequency_counter_blue) color=4;
					 else color=1;
					 state=clear;
					 
					 end
					 end
	clear:       begin					
					 state=green_check;
					 counter=0;
					 //green_freq=0;
					 
				 
					 end	
		endcase
	end	
	always@(posedge cs_out) 
	/*
	Purpose:for frequency determination by counting positive edges of cs_out signal coming form color sensor
	
*/
	begin
	if(state==green_check) frequency_counter_green=frequency_counter_green+1;
	else if(state==red_check) frequency_counter_red=frequency_counter_red+1;
	else if(state== blue_check) frequency_counter_blue=frequency_counter_blue +1;
	else begin frequency_counter_green=0;frequency_counter_blue=0;frequency_counter_red=0;end
	end

//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule
