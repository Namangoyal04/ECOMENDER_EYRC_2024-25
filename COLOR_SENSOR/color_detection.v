
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

module t1b_cd_fd(clk_1MHz,cs_out ,filter,color );
input clk_1MHz,cs_out ;
output reg [1:0] filter;
output reg [2:0] color ;
	initial begin
		filter =3;color= 0; 
	end
	
	localparam IDLE=2'd0,FILTER_SWAP=2'd1,READ_WAIT =2'd2 ,DETECT_COLOR =2'd3 ; 
	parameter blue_check=2'b01,green_check=2'b11,red_check=2'b00,clear=2'b10;
	reg [15:0] red_counter=0,blue_counter=0,green_counter=0;
	reg [12:0] counter=0;
	reg [15:0] frequency=0;
	reg [1:0] state =FILTER_SWAP;
	always @(posedge clk_1MHz)begin
		case(state)
			IDLE :state =FILTER_SWAP;
			FILTER_SWAP: begin
				case(filter)
					green_check:begin
						if(counter!=12'b000111110100)begin
							counter=counter+1;
						end
						else begin
							green_counter=frequency;
							counter =0 ; 
							filter = red_check;
						end
					end
					red_check:begin
					if(counter!=12'b000111110100)begin
							counter=counter+1;
						end
						else begin
							red_counter=frequency;
							counter =0 ; 
							filter = blue_check;
						end
					end
					blue_check:begin
					if(counter!=12'b000111110100)begin
							counter=counter+1;
						end
						else begin
							blue_counter= frequency;
							counter =0 ; 
							state= DETECT_COLOR;
						end
					end
					clear:begin
						
						red_counter=0;
						green_counter=0;
						blue_counter=0 ; 
						state=FILTER_SWAP;
						filter=green_check;
						counter= 0 ;
						end
					endcase
			end
			READ_WAIT:begin
				red_counter=0;
				green_counter=0;
				blue_counter=0 ; 
				counter=0;
				state=FILTER_SWAP;
			end
			DETECT_COLOR:begin
				if(red_counter && blue_counter &&green_counter) begin
					if(red_counter >=blue_counter && red_counter>=green_counter)color =2'd1;
					else if(green_counter>blue_counter) color =2'd2;
					else color=2'd3;
				end
				filter=2;state=FILTER_SWAP;
			end
			endcase
	end
	always @(posedge cs_out)begin
		if(counter) frequency=frequency+1;
		else frequency =0 ;
	end
	endmodule
