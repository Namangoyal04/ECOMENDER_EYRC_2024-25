
// riscv_cpu.v - single-cycle RISC-V CPU Processor

module riscv_cpu (
    input         clk, reset,
    output [31:0] PC,
    input  [31:0] InstrF,
    output        MemWriteM,
    output [31:0] Mem_WrAddrM, Mem_WrDataM,
    input  [31:0] ReadDataM,
    output [31:0] ResultW,
    output [ 2:0] funct3M,
    output [31:0] PCW, ALUResultW, WriteDataW
);

wire        ALUSrcD, RegWriteD, BranchD, JumpD, JalrD;
wire [1:0]  ResultSrcD, ImmSrcD;
wire [3:0]  ALUControlD;
wire[31:0]  InstrD;

controller  c   (InstrD[6:0], InstrD[14:12], InstrD[30],
                ResultSrcD, MemWriteD, ALUSrcD,
                RegWriteD, BranchD, JumpD, JalrD, ImmSrcD, ALUControlD);

datapath    dp  (clk, reset, ResultSrcD,
                ALUSrcD, RegWriteD,MemWriteD, ImmSrcD, ALUControlD, BranchD, JumpD, JalrD,
                PC, InstrF,InstrD,MemWriteM, Mem_WrAddrM, Mem_WrDataM, ReadDataM, ResultW, PCW, ALUResultW, WriteDataW,funct3M);


endmodule
