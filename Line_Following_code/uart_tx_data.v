/*
# Team ID:          < 3987 >
# Theme:            < ECOMENDER >
# Author List:      < Naman >
# Filename:         < uart_tx_data >
# File Description: < this file provides data to uart tx module character by character for trasmission based on appropriate cases >
*/


module uart_tx_data(input [2:0]detected_color,
                     input [3:0] node,
                   input node_detected,
                  input clk_3125KHz,
                  input tx_done,
                   output reg tx_start,
                 output reg[7:0] msg);
					  
					  
   reg [7:0] data [13:0];
	reg [1:0]state;
	reg [3:0] index;
	 reg [2:0] temp_detected_color;
	 reg [2:0] temp_node;
  
	always @(detected_color or node)
	begin 
	if(detected_color==3'b100 & node_detected==0)
	begin                     //DATA = SLM-FSU2-IM-# red
	   data[0] =8'b01010011;
      data[1] =8'b01001100;
      data[2] =8'b01001101;
      data[3] =8'b00101101;
      data[4] =8'b01000110;
		data[5] =8'b01010011;
      data[6] =8'b01010101;
      data[7] =8'b00110010;
      data[8] =8'b00101101;
      data[9] =8'b01001001;
		data[10]=8'b01001101;
      data[11]=8'b00101101;
      data[12]=8'b00100011;
		data[13]=8'b00001010;
		  end
		  
		  
		  	else if(detected_color==3'b001 & node_detected==0)
	   begin                            //DATA = SLM-FSU3-IS-#blue
     data[0]=8'b01010011;  
      data[1]=8'b01001100;
      data[2]=8'b01001101;
      data[3]=8'b00101101;
      data[4]=8'b01000110;
		data[5]=8'b01010011;
      data[6]=8'b01010101;
      data[7]=8'b00110011;
      data[8]=8'b00101101;
      data[9]=8'b01001001;
		data[10]=8'b01010011;
      data[11]=8'b00101101;
      data[12]=8'b00100011;
		data[13]=8'b00001010;
          end
			 
	    else if(detected_color==3'b010 & node_detected==0) //DATA = SLM-FSU1-AS-# green
	   begin  
       data[0]=8'b01010011;  
      data[1]=8'b01001100;
      data[2]=8'b01001101;
      data[3]=8'b00101101;
      data[4]=8'b01000110;
		data[5]=8'b01010011;
      data[6]=8'b01010101;
      data[7]=8'b00110001;
      data[8]=8'b00101101;
      data[9]=8'b01000001;
		data[10]=8'b01010011;
      data[11]=8'b00101101;
      data[12]=8'b00100011;
		data[13]=8'b00001010;
          end
			 
			 
		else if(node==4'b0000 & node_detected==1)
	begin                     //DATA = NODE 0
	   data[0]=8'b01001110;
      data[1]=8'b01001111;
      data[2]=8'b01000100;
      data[3]=8'b01000101;
      data[4]=8'b00111101;
		data[5]=8'b00110000;
		data[6]=8'b00100000;
	   data[7]=8'b00100000;
      data[8]=8'b00100000;
      data[9]=8'b00100000;
		data[10]=8'b00100000;
      data[11]=8'b00100000;
      data[12]=8'b00100000;
		data[13]=8'b00001010;
		  end
		  
		  
		  	else if(node==4'b0001 & node_detected==1)
	begin                     //DATA = NODE 1
	   data[0]=8'b01001110;
      data[1]=8'b01001111;
      data[2]=8'b01000100;
      data[3]=8'b01000101;
      data[4]=8'b00111101;
		data[5]=8'b00110001;
		data[6]=8'b00100000;
	   data[7]=8'b00100000;
      data[8]=8'b00100000;
      data[9]=8'b00100000;
		data[10]=8'b00100000;
      data[11]=8'b00100000;
      data[12]=8'b00100000;
		data[13]=8'b00001010;
		  end
			 
	    else if(node==4'b0010 & node_detected==1)
	begin                     //DATA = NODE 2
	   data[0]=8'b01001110;
      data[1]=8'b01001111;
      data[2]=8'b01000100;
      data[3]=8'b01000101;
      data[4]=8'b00111101;
		data[5]=8'b00110010;
		data[6]=8'b00100000;
	   data[7]=8'b00100000;
      data[8]=8'b00100000;
      data[9]=8'b00100000;
		data[10]=8'b00100000;
      data[11]=8'b00100000;
      data[12]=8'b00100000;
		data[13]=8'b00001010;
		  end
		  
		 else if(node==4'b0011 & node_detected==1)
	begin                     //DATA = NODE 3
	   data[0]=8'b01001110;
      data[1]=8'b01001111;
      data[2]=8'b01000100;
      data[3]=8'b01000101;
      data[4]=8'b00111101;
		data[5]=8'b00110011;
	  data[6]=8'b00100000;
	   data[7]=8'b00100000;
      data[8]=8'b00100000;
      data[9]=8'b00100000;
		data[10]=8'b00100000;
      data[11]=8'b00100000;
      data[12]=8'b00100000;
		data[13]=8'b00001010;
		  end
		  
		   else if(node==4'b0100 & node_detected==1)
	begin                     //DATA = NODE 4
	   data[0]=8'b01001110;
      data[1]=8'b01001111;
      data[2]=8'b01000100;
      data[3]=8'b01000101;
      data[4]=8'b00111101;
		data[5]=8'b00110100;		
	   data[6]=8'b00100000;
	   data[7]=8'b00100000;
      data[8]=8'b00100000;
      data[9]=8'b00100000;
		data[10]=8'b00100000;
      data[11]=8'b00100000;
      data[12]=8'b00100000;
		data[13]=8'b00001010;
		  end
		  
		   else if(node==4'b0101 & node_detected==1)
	begin                     //DATA = NODE 5
	   data[0]=8'b01001110;
      data[1]=8'b01001111;
      data[2]=8'b01000100;
      data[3]=8'b01000101;
      data[4]=8'b00111101;
		data[5]=8'b00110101;
		data[6]=8'b00100000;
	   data[7]=8'b00100000;
      data[8]=8'b00100000;
      data[9]=8'b00100000;
		data[10]=8'b00100000;
      data[11]=8'b00100000;
      data[12]=8'b00100000;
		data[13]=8'b00001010;
		
		  end
		  
		   else if(node==4'b0110 & node_detected==1)
	begin                     //DATA = NODE 6
	   data[0]=8'b01001110;
      data[1]=8'b01001111;
      data[2]=8'b01000100;
      data[3]=8'b01000101;
      data[4]=8'b00111101;
		data[5]=8'b00110110;
		data[6]=8'b00100000;
	   data[7]=8'b00100000;
      data[8]=8'b00100000;
      data[9]=8'b00100000;
		data[10]=8'b00100000;
      data[11]=8'b00100000;
      data[12]=8'b00100000;
		data[13]=8'b00001010;
		  end
		  
		  end 
		  
		  always @(posedge clk_3125KHz)
		  
		  begin
		  temp_detected_color<=detected_color;
		  temp_node<=node;
		  end
		  
		  
		  
		  always @(posedge clk_3125KHz)
		  begin
		  case(state)
		  0:begin
		    if(index<14) begin
			 tx_start <=1;
			 msg <=data[index];
			 state<=1;end
			 
			 else  begin
			 tx_start <=0;
			    if((temp_detected_color != detected_color)|(temp_node != node))			 
			 state<=3;
			 end
			 end
		1: begin 
		tx_start <=0;
		state<=2;
		end
		
		2:begin
		if(tx_done) begin
		state<=0;
		index<=index+1;
		end
		end
		
		3:begin state<=0;
		              index <=0;
						  tx_start<=1;
						  end
		default: begin state<=3;
		              
						  end
		
		
		endcase 
		end 
		 


	


endmodule
