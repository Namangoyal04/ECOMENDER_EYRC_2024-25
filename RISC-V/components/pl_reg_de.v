
// pipeline registers -> decode | execute stage

module pl_reg_de (
    input             clk,  clr,
	 input 				 RegWriteD,
	 input      [1:0]  ResultSrcD,
	 input             MemWriteD,JumpD,BranchD,JalrD,
	 input      [3:0]  ALUControlD,
	 input             ALUSrcD,
    input      [31:0] RD1D,RD2D,PCD, 
	input[4:0]        Rs1D,Rs2D,RdD,
	input[31:0]      ImmExtD,
	input[31:0]      PCPlus4D,
   input [2:0] funct3D,	
	input[19:0] forauipcD,
	input       selectauipcD,
	 output reg        RegWriteE,
	 output reg [1:0]  ResultSrcE,
	 output reg        MemWriteE,JumpE,BranchE,JalrE,
	 output reg [3:0]  ALUControlE,
	 output reg        ALUSrcE,
    output reg [31:0] RD1E,RD2E,PCE,
	output reg [4:0]  Rs1E,
	output reg[4:0]   Rs2E,
	output reg[4:0]   RdE,
	output reg [31:0] ImmExtE,PCPlus4E,
	output reg[2:0] funct3E,
	output reg[19:0] forauipcE,
	output reg       selectauipcE
	 );

initial begin
    {RegWriteE,ResultSrcE,MemWriteE,JumpE,BranchE,JalrE,ALUControlE,ALUSrcE,RD1E,RD2E,PCE,Rs1E,Rs2E,RdE,ImmExtE,PCPlus4E,funct3E,forauipcE,selectauipcE}<=0;
end

always @(posedge clk) begin
    if (clr) begin
        {RegWriteE,ResultSrcE,MemWriteE,JumpE,BranchE,JalrE,ALUControlE,ALUSrcE,RD1E,RD2E,PCE,Rs1E,Rs2E,RdE,ImmExtE,PCPlus4E,funct3E,forauipcE,selectauipcE}<=0;
		  end 
	 else begin
       {RegWriteE,ResultSrcE,MemWriteE,JumpE,BranchE,JalrE,ALUControlE,ALUSrcE,RD1E,RD2E,PCE,Rs1E,Rs2E,RdE,ImmExtE,PCPlus4E,funct3E,forauipcE,selectauipcE}<={RegWriteD,ResultSrcD,MemWriteD,JumpD,BranchD,JalrD,ALUControlD,ALUSrcD,RD1D,RD2D,PCD,Rs1D,Rs2D,RdD,ImmExtD,PCPlus4D,funct3D,forauipcD,selectauipcD};
    end
end

endmodule
