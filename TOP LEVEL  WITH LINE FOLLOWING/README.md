# 🚗Line Following Robot with Node Detection

This project implements a **line-following robot** using Verilog HDL on FPGA, integrated with a RISC-V processor core for control. The robot detects black lines using IR sensors and follows a predefined path. It also identifies **nodes (junctions)**, **handles broken lines**, and stops after completing predefined laps.

---

## 🔧 Hardware Setup

- **FPGA**: De0 Nano
- **Line Sensor**: 3-way IR array (left, center, right)
- **Motors**: Dual DC motors with PWM speed control
- **Motor Driver**: L298N or equivalent
- **Power Supply**: 12V Battery
- **Clock Frequency**: 3.125 MHz

---

## 📦 Features

- Sensor-driven line detection (Left, Center, Right)
- PWM motor speed control (fast/slow adjustment)
- Node detection using 3-sensor input (`ld1`, `ld2`, `ld3`)
- Lap counting and finish flag after 2 full laps
- RISC-V integration (optional: for higher-level control/decision-making)
- **Line Following:**  
  Uses 3 IR sensors to track black lines and junctions (nodes). Supports partial turns and broken line recovery using a custom FSM.

- **Color Detection:**  
  Detects Red, Green, or Blue using frequency-based filtering with a TCS3200 color sensor. Outputs `color = 3'b100 (Red)`, `3'b010 (Green)`, or `3'b001 (Blue)`.

- **UART Transmission:**  
  Detected node and color data are encoded and sent over UART via a Bluetooth module (e.g., HC-05). Parity support included (even/odd).

- **RISC-V Integration:**  
  Easily controlled via RISC-V processor for higher-level automation.

---


## 🚦 Line Following Logic

| Sensor Input | Pattern (ld) | Behavior |
|--------------|--------------|----------|
| 100 | Left Only    | Turn Left |
| 001 | Right Only   | Turn Right |
| 010 | Center Only  | Go Straight |
| 111 | All Detect   | Node Detected |
| 000 | None Detect  | Broken Line Recovery |
| 011 | Center + Right | Partial Right |
| 110 | Center + Left  | Partial Left |
| 101 | Left + Right (Partial) | Straight |
  
- Uses thresholding to convert analog values to binary:  
  `ldX_v = ldX < th ? 0 : 1` (1 = black line, 0 = white)

---
## 🧪 LFA TEST
https://github.com/user-attachments/assets/b29da5b7-69ca-40d1-85ed-38a10080d15c


## 🧠 Node Detection & Lap Counting

- Nodes are detected when `ld == 3'b111`
- Implements a **2.5–4s delay** between successive node counts to avoid false triggers
- Bot completes **2 laps** and then stops
- Uses a counter to alternate **broken path recovery**: first right, then left

---

## ⏱ Timing Parameters

| Parameter | Value |
|----------|--------|
| `sec1`   | 2.5s delay (0x00773594) |
| `twosec` | 4.0s delay (0x00D693A4) |
| Clock    | 3.125 MHz |

---

## 🧩 Integration with RISC-V

> This module was integrated into a larger RISC-V-based system to control sensor reading and high-level commands. The core can set the `start` signal or interact with the robot in a supervisory mode.

---

