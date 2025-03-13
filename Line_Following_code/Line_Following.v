
/*
# Team ID:          < 3987>
# Theme:     	     Ecomender bot
# Author List:      Tejas choudary,Guru prasath,Naman goyal,Himesh Jha
# Filename:     	  Line Following.v
# File Description: Line following code which consist of motor signal and motor speed according to the lfa sensor inputs
*/


module Line_Following(start,clk,ld1,ld2,ld3,in1,in2,in3,in4,enR,enL,node_counter,node_detected,finish);
input [11:0] ld1,ld2,ld3;//To get left,center,right value from line following sensor 
input start;//start signal 
input clk;
output in1,in2,in3,in4; //Provides both motor directions 
output reg [7:0] enR,enL ; //Provides pwn signal to control speed of the motor 
output reg [3:0] node_counter;// Counts node
output reg node_detected;
output reg finish;//Finish flag 


reg [11:0] th=12'h3FF; //Threshold value that we got manually with the help of signal tap .
wire ld1_v,ld2_v,ld3_v;
wire[2:0] ld;
reg [3:0] move;
assign ld1_v=ld1<th?0:1; //Comparing with threshold value to differentiate between black and white (1->black , 0->white)
assign ld2_v=ld2<th?0:1;
assign ld3_v=ld3<th?0:1;
assign ld={ld1_v,ld2_v,ld3_v};
reg [31:0] delay_counter;//A delay between 2.5-4 s is created using this counter.
reg counter_start;//Flag for delay counter 
reg [1:0] lap_counter;//Counts number of lap completed .
parameter [31:0] sec1=32'h00773594;//Parameter used for detecting 2.5s in this 3125khz clock
parameter [31:0] twosec=32'h00D693A4;//Parameter used for detecting 4s in this 3125khz clock
reg [7:0] f_L=8'd105,s_L=8'd95,f_R=8'd105,s_R=8'd95;//common speed value ssed for assigning speed to the motors
//f and s represents fast ans slow speed .
parameter [2:0] left=3'b100,right=3'b001,center=3'b010,node=3'b111,p_right=3'b011,p_left=3'b110,stop=3'b000,partial=3'b101;
// this parameters are used for giving state cases depends on the line following array sensor outputs 
reg [2:0] state, prev_state;//Stores the state of the bot from the ld input .
reg t_counter;//counter used to pass the broken line 
reg t_en ; //Flag for t_counter 


initial begin
// Initiallizing block for counters and other registers 
 node_counter<=0 ; 
 lap_counter<=0;
delay_counter<=0;
counter_start<=0;
t_counter<=1; 
t_en<=0;
node_detected<=0;
finish<=0;
//turn_counter<=0;
end


reg temp_start=0;
always @(posedge start)begin
/*
Purpose:
---
	To start the bot after rising edge of start signal 
*/

temp_start<=1;
end



always @(posedge clk)begin
/*
Purpose:
---
All clock based assignments are assigned here 
like time counter etc..

*/
if(temp_start==1)begin//THis block of code works after posedge of start 
  state<=ld;
  if(node_counter==4'b1000) node_counter<=0;//node_counter resets after 8 nodes,
  //because we made the bot slower so that it takes to node count in node six for crossing the broken line properly . 
  if(ld==node)counter_start<=1;//counter_start flag enables.
  //so that for 2.5s it wont count any new node to avoid multiple node count in single node .
  
  // 2.5 s delay is applied for new node count except node 0 
  if(delay_counter==sec1 && node_counter!=0 ) begin 
   counter_start<=0 ;
	delay_counter<=0 ;
  end
  else if(delay_counter==twosec && node_counter==0)  begin//4s delay is applied for next node count 
  counter_start<=0 ;
	delay_counter<=0 ;
  end
  else if(counter_start) delay_counter<=delay_counter+1;//delay increment 
  
  
if(delay_counter==1 && counter_start==1) begin//condition used for incrementing node_counter one time in one node .
		node_counter<=node_counter+1; 
		if(node_counter ==0)begin 
			lap_counter<=lap_counter+1;//lap_counter increment after completion of one cycle .
		end
	end
	
	if(lap_counter==3)begin//Stop signal after 2 laps
		state<=left;
		finish<=1;
	end	
end
else begin state<=left ;finish<=0;end
end


always @(negedge t_en) begin
/*
Purpose:
---
Used for making correct turns in broken path in the arena.
*/
	t_counter=t_counter+1; 
end


always @(state)begin
/*
Purpose:
---
	Each unique state node,motor movements are given in this block
*/
    case(state)
	 
        left:begin//Movement signal for motors on left sensor detection(move left)
				node_detected<=0;
				if(lap_counter==3 | temp_start==0)begin//Movement signal for motors on stop signal 
					move<=4'b1001;
					enR<=1;
					enL<=1;
				end
				else begin
					move<=4'b1001;
					enR<=f_R-10;
					enL<=s_L;
				end
				
        end
		  
        right:begin//Movement signal for motors on right sensor detection(move right)
				node_detected<=0;
				move<=4'b0110;
            enR<=s_R;
            enL<=f_L-10;
			
        end
		  
        center:begin//Movement signal for motors on center sensor detection(move straight)
					node_detected<=0;
					t_en=0;
					move<=4'b0101;
					enR<=f_R-15;
					enL<=f_L-15;
					
        end
		  
        node:begin//Movement signal for motors when all sensors detection(depends on the node_counter it turns right or straight).
				if(node_counter%2==0)begin
					node_detected<=1;
					if(node_counter != 6)begin
						
						move<=4'b0110;
						enR<=254;
						enL<=254;
					end
					else begin
						move<=4'b0110;
						enR<=254;
						enL<=254;
					end
				 end
            else begin
                if(node_counter !=7 )begin
					 node_detected<=1;
						move<=4'b0101;
						enR<=120;
						enL<=120;
					 end
					 else begin
					 node_detected<=0;
						move<=4'b0110;
						enR<=254;
						enL<=254;
					 end
            end 
          
        end
		  
        p_right:begin//Movement signal for motors when right and center sensors are detected
				node_detected<=0;
				t_en<=0;
            move<=4'b0110;
            enR<=s_R-5;
            enL<=f_L-20;
		  end
		  
        p_left:begin//Movement signal for motors when left and center sensors are detected
				node_detected<=0;
				t_en<=0;
            move<=4'b1001;
            enR<=f_R-20;
            enL<=s_L-5;
		  end
		  
		  partial:begin//Movement signal for motors when right and left sensors are detected
				node_detected<=0;
				move<=4'b0101;
            enR<=s_R;
            enL<=s_R;
        end  
		  
		  stop: begin//Movement signal for motors when NO sensors are detected
		  /*
		   Our both is facing 000 signal in this task expect the broken path so we made turn counter which is one bit 
			and intialized with one so that in first stop in broken path it takes right turn and in the next it takes left
			this happen by creating a negedge turn_enable signal which enables and stop and disables on center or partial state 
			till then the bot moves in a particular direction.*/
				t_en <=1; 
				prev_state <= stop ; 
				node_detected<=0;
				if(t_counter ==1)begin
					move<=4'b0110;
					enR<=s_R;
					enL<=f_L-10;
				end
				else begin
					move<=4'b1001;
					enR<=f_R-10;
					enL<=s_L;
				end
			end
			
    endcase
	 
end

assign in4 = move[3] ;
assign in3 = move[2] ;
assign in2 = move[1] ;
assign in1 = move[0] ; 

endmodule
