/*
# Team ID:          < 3987 >
# Theme:            < ECOMENDER >
# Author List:      < Himesh,Naman,Guru >
# Filename:         < uart_tx >
# File Description: < This is a file used for converting parallel data to serial data to transmit to HC-05  in a serial manner in uart protocol for transmission >
*/

/*
# Team ID:          < 3987 >
# Theme:            < ECOMENDER >
# Author List:      < Himesh, Naman, Guru >
# Filename:         < uart_tx >
# File Description: < This file is used for converting parallel data to serial data for transmission using UART protocol. The data is sent to the HC-05 module in a serial manner. >
*/

module uart_tx(
    input clk_3125,             // Input clock signal, operating at the required UART baud rate (3125 Hz).
    input PARITY_type,          // Input to select parity type: 0 for even parity, 1 for odd parity.
    input tx_START,             // Input signal to indicate the start of data transmission.
    input [0:7] data,           // 8-bit parallel data input to be transmitted serially.
    output reg tx,              // Serial output signal to transmit data.
    output reg tx_done          // Signal indicating completion of the data transmission.
);

// State definitions for the UART transmitter FSM
parameter IDLE = 3'b111,       // Idle state: UART is waiting for a start signal.
          START = 3'b000,      // Start state: Transmits the start bit (logic 0).
          TRANSMIT = 3'b001,   // Transmit state: Transmits the 8 data bits.
          PARITY = 3'b010,     // Parity state: Transmits the parity bit.
          STOP = 3'b011;       // Stop state: Transmits the stop bit (logic 1).

reg [5:0] counter;             // Counter for timing bit transmission.
reg [2:0] state;               // Current state of the FSM.
reg PARITY_bit;                // Calculated parity bit based on the selected parity type.
reg [2:0] idx;                 // Index to track the current bit being transmitted from the data.

// Initial block to set the initial states of signals and registers.
initial begin
    tx      = 1;               // Default TX line to high (idle state in UART).
    tx_done = 0;               // No transmission is complete at initialization.
    counter = 1;               // Initialize counter.
    state   = IDLE;            // Set the FSM to the IDLE state.
end

// Combinational logic to calculate the parity bit based on the PARITY_type.
// If PARITY_type is 1 (odd parity), parity bit is the inverse of the XOR of all data bits.
// If PARITY_type is 0 (even parity), parity bit is the XOR of all data bits.
always @(*) begin
    PARITY_bit = (PARITY_type) ? (~(^data)) : (^data);
end

// Sequential logic to implement the FSM and transmit data serially.
always @(posedge clk_3125) begin
    case (state)
        IDLE: begin
            tx = 1;            // Keep TX line high in IDLE state.
            tx_done = 0;       // Clear the transmission done signal.
            if (tx_START) begin
                state = START; // Transition to START state when tx_START signal is asserted.
                tx = 0;        // Send the start bit (logic 0).
            end
        end

        START: begin
            tx = 0;            // Transmit the start bit (logic 0).
            idx = 7;           // Initialize index to the MSB of the data.
            tx_done = 0;       // Clear the transmission done signal.
            if (counter != 26) 
                counter = counter + 1; // Increment the counter.
            else begin
                counter = 0;   // Reset counter after transmitting the start bit.
                state = TRANSMIT; // Transition to the TRANSMIT state.
            end
        end

        TRANSMIT: begin
            tx = data[idx];    // Transmit the current data bit.
            if (counter != 26) 
                counter = counter + 1; // Increment the counter.
            else if (idx == 0) begin
                state = PARITY; // If all data bits are transmitted, transition to the PARITY state.
                counter = 0;   // Reset the counter.
            end else begin
                counter = 0;   // Reset the counter.
                idx = idx - 1; // Move to the next bit (lower index).
            end
        end

        PARITY: begin
            tx = PARITY_bit;   // Transmit the calculated parity bit.
            if (counter != 26) 
                counter = counter + 1; // Increment the counter.
            else begin
                counter = 0;   // Reset the counter.
                state = STOP;  // Transition to the STOP state.
            end
        end

        STOP: begin
            tx = 1;            // Transmit the stop bit (logic 1).
            if (counter != 26) 
                counter = counter + 1; // Increment the counter.
            else begin
                counter = 1;   // Reset counter for the next transmission.
                if (tx_START)
                    state = START; // Restart transmission if tx_START is asserted.
                else
                    state = IDLE; // Otherwise, return to the IDLE state.
                tx_done = 1;   // Set the transmission done signal.
            end
        end
    endcase
end

endmodule

