odule EdgeDetector(
    input wire clk,
    input wire rstn,     // active-low reset
    input wire trigger,  // asynchronous or synchronous input
    output reg pulse     // single-cycle pulse on a rising edge
);

    // Two flip-flops to detect rising edge
    reg [1:0] ffs;

    // 1) Shift in the trigger signal
    always @(posedge clk or negedge rstn) begin
        if (!rstn) begin
            ffs <= 2'b00;
        end else begin
            ffs[0] <= trigger;
            ffs[1] <= ffs[0];
        end
    end

    // 2) Rising edge is when the older sample was 0, new sample is 1
    wire rising_edge = ~ffs[1] & ffs[0];

    // 3) Output a pulse for exactly one clock cycle
    always @(posedge clk or negedge rstn) begin
        if (!rstn)
            pulse <= 1'b0;
        else
            pulse <= rising_edge;
    end
endmodule