
// branching_unit.v - logic for branching in execute stage

module branching_unit (
    input [2:0] funct3,
    input       Zero, ALUR31,
    output reg  Branch
);

initial begin
    Branch = 1'b0;
end

always @(*) begin
    casez (funct3)
        3'b0?0: Branch =    Zero; 
        3'b0?1: Branch =   !Zero; 
        3'b1?1: Branch = !ALUR31;
		  3'b1?0: Branch =  ALUR31; 
		  
        default: Branch = 1'b0;
    endcase
end

endmodule