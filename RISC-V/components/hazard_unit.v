module hazard_unit(input[4:0] Rs1D,Rs2D,RdE,Rs2E,Rs1E,
						 input PCSrcE,input ResultSrcE0,
						 input[4:0] RdM,RdW,
						 input RegWriteM,RegWriteW,
                   output  StallF,StallD,FlushD,FlushE,
						 output[1:0] ForwardAE,ForwardBE);

        assign ForwardAE = (((Rs1E==RdM)&&RegWriteM)&&(~Rs1E))?2'b10:(((Rs1E==RdW) && RegWriteW)&& (Rs1E))?2'b01:2'b00;
        assign ForwardBE = (((Rs2E==RdM)&& RegWriteM)&&( ~Rs2E))?2'b10:(((Rs2E==RdW)&&RegWriteW)&&(Rs2E))?2'b01:2'b00;
        wire lwstall;
        assign lwstall   = ResultSrcE0 && ((Rs1D==RdE)||(Rs2D==RdE));
        assign StallF    = lwstall;
        assign StallD    = lwstall;
        assign FlushD    = PCSrcE;
        assign FlushE    = lwstall || PCSrcE;       


endmodule
