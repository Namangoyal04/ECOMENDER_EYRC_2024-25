# e-Yantra Robotics Competition 2024-25 – EcoMender Bot

This repository documents our team's participation in the **e-Yantra Robotics Competition (eYRC 2024-25)** organized by **IIT Bombay**, under the **EcoMender Bot** theme.

---

##  Competition Overview

The EcoMender Bot theme simulates a robotic application in a chip design industry. The goal was to build an autonomous robot powered by an **FPGA** capable of reading sensors, processing data, and controlling actuators in real-time.

The bot’s brain was designed using **Verilog HDL** and deployed on an Altera Cyclone IV-E FPGA . 

---

##  Team Members

- Tejas Anil Chaudhari    
- Himesh Jha  
- Naman Goyal
- Guru Prasath

Institution: Indian Institute of Technology, Indore

---

## Key Implementations

- ✅ **EcoMender Bot** built from scratch using an FPGA
- ✅ **RISC-V CPU Design** (Single-cycle and Pipelined) in Verilog HDL
- ✅ **Component Interfacing** (sensors, actuators)
- ✅ **Serial Communication** between FPGA and other components

---
## Tasks Implemented
### Task1:
* **A.** Frequency Scaling & PWM Generation.
* **B.** Color detection using Frequency Scaling.
* **C.** RISCV CPU Design 

### Task2:
* **A.**  UART
* **B.** Path Planner Using C .

### Task3:
* **A.** Flex Printing and Arena Preparation
* **B.** Bot Building with design constraint of 12x12x20 cm.
* **C.** Pipelined RISCV CPU

### Task4:
* **A.** HC05 Configration
* **B.** Bot Run Implementation

#### Objectives of Task 4
* In this task, EcoMender Bot (EB) built in the previous task should traverse around Fabrication Unit (FU) by following the black line along with node, color detection and wireless communication using Bluetooth Module.

* For simplicity, this task can be divided into 3 sub-tasks and then all the sub-tasks can be merged to complete the Task 4. The sub-tasks are as below:

  * Black Line Following
  * Color Detection
  * UART Transmission
* During the traversal in the Fabrication Unit, EB should identify the Nodes and Sustainablity Indicators in the industry.
* For indicating the sustainability level, the EB should glow detected color on one of the three LEDs for this task till it completes one lap. At the same time, EB should also send the Sustainability Level Message (SLM) via UART on serial terminal app .
* EB needs to complete Two laps/rounds from the start position within three minutes and reach the start point again (i.e., Node 10 or Node 11) in the last lap/round.
* To indicate END of the run, EB should stop at the start point (Node 10 or Node 11) after two laps/rounds and then blink GREEN color light in all the three LEDs with 1 sec delay.

## Bot Run


https://github.com/user-attachments/assets/1c79e911-0a4c-43b4-abca-c8c461ccc306


## Learning Outcomes

- FPGA Design & Programming  
- Verilog HDL
- Hardware Implementation of a Bot
- Assembling of components and sensors
- RISC-V Architecture  
- Digital Design Principles

---

## 🥉 Certificate

Awarded **Level 3 Certificate** – indicating a fair understanding of the problem statement and a **partial working solution**.

Issued by:  
**ERTS Lab**, Department of CSE  
**Indian Institute of Technology Bombay**  
Under the National Mission on Education through ICT (MHRD, Govt. of India)

---

