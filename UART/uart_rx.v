
module uart_rx(
    input clk_3125,
    input rx,//rx of fpga getting value from tx of hc05 which is giving binary after giving 'START' from phone app
    output reg [7:0] rx_msg,
    output reg rx_parity,
    output reg rx_complete
    );


parameter S0=4'b1110,S1=4'b0111,S2=4'b0110,S3=4'b0101,S4=4'b0100,S5=4'b0011,S6=4'b0010,S7=4'b0001,S8=4'b0000,S9=4'b1001,S10=4'b1010,idle=4'b1111;
reg[3:0] state;
reg[4:0] counter;
reg[7:0] msg=0;
reg parity=0;
initial begin
    rx_msg      = 0;
	 rx_parity   = 0;
    rx_complete = 0;
	 counter     = 4'b1111;
	 state       = 4'b1111;
end

// Add your code here....
always@(posedge clk_3125) begin
	case(state)
	idle  : begin rx_complete =0; if(!rx) state =S0; end
	S0    : begin rx_complete =0; if(counter!=27) counter = counter+1; else begin counter =0; state =S1;   end end
	S1    : begin if(counter!=27) counter = counter+1;  else  begin counter =0; state =S2;   end end
	S2    : begin if(counter!=27) counter = counter+1;  else  begin counter =0; state =S3;   end end
	S3    : begin if(counter!=27) counter = counter+1;  else  begin counter =0; state =S4;   end end
	S4    : begin if(counter!=27) counter = counter+1;  else  begin counter =0; state =S5;   end end
	S5    : begin if(counter!=27) counter = counter+1;  else  begin counter =0; state =S6;   end end
	S6    : begin if(counter!=27) counter = counter+1;  else  begin counter =0; state =S7;   end end
	S7    : begin if(counter!=27) counter = counter+1;  else  begin counter =0; state =S8;   end end
	S8    : begin if(counter!=27) counter = counter+1;  else  begin counter =0; state =S9;   end end
	S9    : begin if(counter!=27) counter = counter+1;  else  begin counter =0; state =S10;   end end
	S10   : begin if(counter!=26) counter = counter+1;  else  begin counter =0;rx_complete =1;rx_parity = parity;if(parity!=(^msg)) rx_msg=8'b00111111;else rx_msg=msg; if(rx) state =idle; else state =S0; end  end
	
	endcase
end
always@(state) begin
	case(state)
	idle     : msg    = 0 ;
	S0       : msg    = 0 ;
	S9       : parity = rx;
	default  : msg[state] = rx;
	endcase
end



endmodule

