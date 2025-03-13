
// pipeline registers -> memory | WriteBack stage

module pl_reg_mw (
    input             clk,
    input             RegWriteM,
    input[1:0]        ResultSrcM,
    input[31:0]       ALUResultM,
    input[31:0]       ReadDataM,
    input[4:0]        RdM,
    input[31:0]       PCPlus4M,
	 input[31:0]       WriteDataM,
	 input[31:0]       PCM,
	 input[31:0]       lAuiPCM,
    output reg        RegWriteW,
    output reg[1:0]   ResultSrcW,
    output reg[31:0]  ALUResultW,
    output reg[31:0]  ReadDataW,
    output reg[4:0]   RdW,
    output reg[31:0]  PCPlus4W,
	 output reg[31:0]  WriteDataW,
    output reg[31:0]  PCW,
    output reg[31:0]  lAuiPCW	 
    );

initial begin
    {RegWriteW,ResultSrcW,ALUResultW,ReadDataW,RdW,PCPlus4W,WriteDataW,PCW,lAuiPCW}<=0;
end

always @(posedge clk) begin
    {RegWriteW,ResultSrcW,ALUResultW,ReadDataW,RdW,PCPlus4W,WriteDataW,PCW,lAuiPCW}<={RegWriteM,ResultSrcM,ALUResultM,ReadDataM,RdM,PCPlus4M,WriteDataM,PCM,lAuiPCM};      
end

endmodule
