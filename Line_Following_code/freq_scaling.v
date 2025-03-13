/*
# Team ID:          < 3987 >
# Theme:            < ECOMENDER >
# Author List:      < Naman,Himesh,Guru >
# Filename:         < freq_scaling >
# File Description: < used for generating 3125 KHz clock from 50MHz clock >

*/
module freq_scaling (
    input clk_50MHz,
    output reg clk_3125KHz
);

initial begin
    clk_3125KHz = 1;
end


reg[4:0] counter=4'd0;

always @ (posedge clk_50MHz) begin
    if  (counter== 5'd8)
    begin
    clk_3125KHz = ~clk_3125KHz; 
    counter = 1'd0;
    end
    
    counter = counter + 1'b1; 
end
endmodule
