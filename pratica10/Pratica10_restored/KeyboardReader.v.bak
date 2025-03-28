module KeyboardReader(
    input  wire clk,          // system clock
    input  wire rstn,         // active-low reset
    // PS/2 lines
    input  wire ps2_clk,
    input  wire ps2_data,
    // Output signals for the Pong game
    output reg left_up,
    output reg left_down,
    output reg right_up,
    output reg right_down
);

    // -- internal signals for storing the current scan code
    reg [7:0] scan_code;
    reg       scan_done; // goes high for one clock when we’ve received a code

    // Example PS/2 scanning logic (very simplified):
    // In reality, you have a shift register that samples ps2_data on the falling edge of ps2_clk, 
    // checks parity, and sets scan_code when the full 8 bits plus parity/stop are read.
    // This is just a placeholder.

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            scan_code <= 8'h00;
            scan_done <= 1'b0;
        end else begin
            // Here, you'd handle the PS/2 bit reception.
            // For demonstration, assume we have a function that sets:
            //   scan_code = the last received make code
            //   scan_done = 1 whenever a new make code arrives
            // You’d then do something like:
            scan_done <= 1'b0;  // default
            // if (new_code_received) begin
            //     scan_code <= the_new_code;
            //     scan_done <= 1'b1;
            // end
        end
    end

    // Simple decode of W, S, I, K
    // For continuous movement: we set the signal high upon make code, 
    // and reset it low upon break code. 
    // The break code is typically 0xF0 followed by the make code for that key.

    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            left_up <= 1'b0;
            left_down <= 1'b0;
            right_up <= 1'b0;
            right_down <= 1'b0;
        end
        else if (scan_done) begin
            // If you see a break code 0xF0, the next code is the key being released.
            // If you see a make code, it's pressed.
            // For this example, we’ll only handle the "make" portion:
            case (scan_code)
                8'h1D: left_up    <= 1'b1;  // W pressed
                8'h1B: left_down  <= 1'b1;  // S pressed
                8'h43: right_up   <= 1'b1;  // I pressed
                8'h42: right_down <= 1'b1;  // K pressed
                // If you want to handle break codes (key release),
                // you'd see 0xF0 first, then the code. E.g.:
                //   if next code is 0x1D => left_up <= 0
                //   etc.
                default: ; // ignore other keys
            endcase
        end
    end

endmodule