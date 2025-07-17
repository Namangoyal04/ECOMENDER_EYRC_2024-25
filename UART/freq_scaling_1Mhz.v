/*
# Team ID:          < 3987 >
# Theme:            < ECOMENDER >
# Author List:      < Naman,Himesh,Guru >
# Filename:         < freq_scaling_1Mhz >
# File Description: < uses frequency scaling to generate 1MHz clock from 50 MHz clock >
*/

module freq_scaling_1Mhz (
    input clk_50MHz,
    output reg clk_1MHz
);

initial begin
    clk_1MHz = 1;
end

reg[4:0] counter=5'd0;

always @ (posedge clk_50MHz) begin
    if  (counter== 5'd25)
    begin
    clk_1MHz = ~clk_1MHz; 
    counter = 1'd0;
    end
    
    counter = counter + 1'b1; 
end


endmodule
