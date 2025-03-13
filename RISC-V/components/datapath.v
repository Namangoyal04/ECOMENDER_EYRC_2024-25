
// datapath.v
module datapath (
    input         clk, reset,
    input [1:0]   ResultSrcD,
    input         ALUSrcD, RegWriteD,MemWriteD,
    input [1:0]   ImmSrcD,
    input [3:0]   ALUControlD,
    input         BranchD, JumpD, JalrD,
    output [31:0] PC,
    input  [31:0] InstrF,
	 output [31:0] InstrD,
	 output        MemWriteM,
    output [31:0] Mem_WrAddr, Mem_WrData,
    input  [31:0] ReadDataM,
    output [31:0] ResultW,
    output [31:0] PCW, ALUResultW, WriteDataW,
	 output [2:0]  funct3M
);

wire [31:0] PCNextF, PCJalrF, PCPlus4F;//, AuiPCF, lAuiPCF;
wire [31:0] ImmExtD;
wire[2:0] funct3D;
assign funct3D=InstrD[14:12];
wire JalrE;
wire[31:0] ALUResultE,PCTargetE;
wire PCSrcE;

// next PC logic
mux2 #(32)     pcmux(PCPlus4F, PCTargetE, PCSrcE, PCNextF);
mux2 #(32)     jalrmux (PCNextF, ALUResultE, JalrE, PCJalrF);

// stallF - should be wired from hazard unit
wire StallF; // remove it after adding hazard unit.
reset_ff #(32) pcreg(clk, reset, StallF, PCJalrF, PC);
adder          pcadd4(PC, 32'd4, PCPlus4F);

// Pipeline Register 1 -> Fetch | Decode

wire FlushD; // remove it after adding hazard unit
// FlushD - should be wired from hazard unit
wire StallD;
//wire[31:0] InstrD;
wire[31:0] PCD,PCPlus4D;
 pl_reg_fd plfd (clk, StallD, FlushD, InstrF, PC, PCPlus4F,
               InstrD, PCD, PCPlus4D);
					
					
// Pipeline Register 2 -> Decode | Execute
// register file logic
wire[31:0] RD1D,RD2D;
wire[4:0] Rs1D,Rs2D,RdD;
wire RegWriteW;
wire[4:0] RdW;
reg_file #(32)      rf (clk, RegWriteW, InstrD[19:15], InstrD[24:20], RdW, ResultW, RD1D, RD2D);
imm_extend     ext (InstrD[31:7], ImmSrcD, ImmExtD);
assign Rs1D = InstrD[19:15];
assign Rs2D = InstrD[24:20];
assign RdD  = InstrD[11:7];
wire[19:0] forauipcD;
assign forauipcD=InstrD[31:12];
wire selectauipcD=InstrD[5];
wire selectauipcE;

wire FlushE;
wire RegWriteE,MemWriteE,JumpE,BranchE,ALUSrcE;
wire[31:0] RD1E,RD2E,PCE,ImmExtE,PCPlus4E;
wire[1:0] ResultSrcE;
wire[3:0] ALUControlE;
wire[4:0] Rs1E,Rs2E,RdE;
wire[2:0] funct3E;
wire[19:0] forauipcE;
pl_reg_de de(clk,FlushE,RegWriteD,ResultSrcD,MemWriteD,JumpD,BranchD,JalrD,ALUControlD,ALUSrcD,RD1D,RD2D,PCD,Rs1D,Rs2D,RdD,ImmExtD,PCPlus4D,funct3D,forauipcD,selectauipcD,    
	          RegWriteE,ResultSrcE,MemWriteE,JumpE,BranchE,JalrE,ALUControlE,ALUSrcE,RD1E,RD2E,PCE,Rs1E,Rs2E,RdE,ImmExtE,PCPlus4E,funct3E,forauipcE,selectauipcE);



// Pipeline Register 3 -> Execute | Memory


// ALU logic
wire[31:0] SrcAE,SrcBEtemp,SrcBE;
wire[1:0] ForwardAE;
wire[1:0] ForwardBE;
wire ZeroE, TakeBranchE;
//wire[31:0] PCTargetE;
wire[31:0] ALUResultM;
mux3 #(32) srcamux(RD1E,ResultW,ALUResultM,ForwardAE,SrcAE);
mux3 #(32) srcbmux1(RD2E,ResultW,ALUResultM,ForwardBE,SrcBEtemp);
mux2 #(32) srcbmux2(SrcBEtemp,ImmExtE,ALUSrcE,SrcBE);
alu        a(SrcAE, SrcBE, ALUControlE, ALUResultE, ZeroE);
adder      pcaddbranch(PCE, ImmExtE, PCTargetE);
wire[31:0] WriteDataE;
assign WriteDataE=SrcBEtemp;
wire[31:0] AuipcE;
wire[31:0] lAuiPCE;
adder #(32)    auipcadder ({forauipcE,12'b0}, PCE, AuipcE);
mux2 #(32)     lauipcmux (AuipcE, {forauipcE,12'b0}, selectauipcE, lAuiPCE);

branching_unit bu (funct3E, ZeroE, ALUResultE[31], TakeBranchE);
assign PCSrcE = ((BranchE && TakeBranchE) || JumpE || JalrE) ? 1'b1 : 1'b0;

wire RegWriteM;
wire[1:0] ResultSrcM;
wire[31:0]WriteDataM,PCPlus4M;
wire[4:0] RdM;
wire[31:0] PCM;
wire[31:0] lAuiPCM;
pl_reg_em em(clk,RegWriteE,ResultSrcE,MemWriteE,ALUResultE,WriteDataE,RdE,PCPlus4E,funct3E,PCE,lAuiPCE,	
             RegWriteM,ResultSrcM,MemWriteM,ALUResultM,WriteDataM,RdM,PCPlus4M,funct3M,PCM,lAuiPCM);

assign Mem_WrData = WriteDataM;
assign Mem_WrAddr = ALUResultM;


// Pipeline Register 4 -> Memory | Writeback
//wire RegWriteW;
wire[1:0] ResultSrcW;
//wire[31:0] ALUResultW;
wire[31:0] ReadDataW;
//wire[4:0] RdW;
wire[31:0] PCPlus4W;
//wire[31:0] lAuiPCM;
wire[31:0] lAuiPCW;
pl_reg_mw mw(clk,RegWriteM,ResultSrcM,ALUResultM,ReadDataM,RdM,PCPlus4M,WriteDataM,PCM,lAuiPCM,    	
             RegWriteW,ResultSrcW,ALUResultW,ReadDataW,RdW,PCPlus4W,WriteDataW,PCW,lAuiPCW);

// Result Source
mux4 #(32)     resultmux(ALUResultW, ReadDataW, PCPlus4W,lAuiPCW, ResultSrcW, ResultW);

// hazard unit
hazard_unit hu(Rs1D,Rs2D,RdE,Rs2E,Rs1E,PCSrcE,ResultSrcE[0],RdM,RdW,RegWriteM,RegWriteW,
               StallF,StallD,FlushD,FlushE,ForwardAE,ForwardBE);


// eventually this statements will be removed while adding pipeline registers


endmodule
