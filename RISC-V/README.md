# RV32I RISC-V Pipelined Processor with Complete Hazard Management

This repository presents a Verilog-based implementation of a pipelined RV32I RISC-V processor. The design follows a classic 5-stage pipeline architecture and integrates comprehensive hazard detection and resolution techniques. It includes all essential components such as the ALU, control unit, register file, instruction and data memory, and a dedicated hazard management unit.

---

##  Features

- **5-Stage Pipeline Architecture**
  - **IF** – Instruction Fetch  
  - **ID** – Instruction Decode  
  - **EX** – Execute  
  - **MEM** – Memory Access  
  - **WB** – Write-back  

- **Hazard Management**
  - **Data Hazards** – Resolved via forwarding and pipeline stalling  
  - **Control Hazards** – Mitigated using branch prediction and stalling  
  - **Structural Hazards** – Prevented through careful hardware resource allocation  

- **Forwarding Unit**
  - Enables read-after-write (RAW) hazard resolution by forwarding results from later pipeline stages to earlier ones.

- **Stalling Unit**
  - Introduces no-operation (NOP) instructions to safely manage data/control hazards when forwarding isn’t possible.

- **Hazard Unit**
  - Detects and resolves pipeline conflicts ensuring correct instruction execution.

---

##  Processor Architecture

The design is based on a traditional RISC-V 5-stage pipeline. Below is a high-level overview of the processor's core components:

![image](https://github.com/user-attachments/assets/2b849652-f27c-4788-a05d-e5179da828c4)

---

##  Core Components

### 1. Control Unit
Generates control signals such as `RegWrite`, `MemWrite`, `Branch`, `ALUControl`, etc., based on the decoded instruction. Determines the type of operation—arithmetic, logic, memory, or branching.

### 2. ALU (Arithmetic Logic Unit)
Performs core computations including addition, subtraction, bitwise AND/OR, and sets the zero flag for conditional operations.

### 3. Data Memory
Supports load and store instructions by enabling memory read/write operations during the MEM stage.

### 4. Instruction Memory
Stores the instruction set for the program and feeds instructions into the pipeline during the IF stage.

### 5. Register File
Maintains general-purpose registers and supports two reads and one write per clock cycle, used in ID and WB stages.

### 6. Hazard Unit
Identifies potential pipeline hazards and activates the necessary forwarding or stalling logic to maintain correct data flow and execution order.


