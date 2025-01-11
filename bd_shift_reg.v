`timescale 1ns / 1ps

module BD_SHIFT_REG(
    output [3:0] q,       // Shift register outputs
    output [3:0] qbar,    // Complementary outputs
    input dr, dl,         // Data in for right (dr) and left (dl)
    input clk, rst,       // Clock and reset signals
    input mode            // Shift mode: 1 = right, 0 = left
);

    wire not_mode;         // Inverted mode signal
    wire [7:0] aw;         // Intermediate AND gates output
    wire [3:0] wo;         // Inputs to D flip-flops

    // Logic for q[0]
    not(not_mode, mode);   // Generate inverted mode
    and(aw[0], q[1], mode);  // For right shift: Get q[1]
    and(aw[1], not_mode, dl); // For left shift: Use dl
    or(wo[0], aw[0], aw[1]);  // Combine inputs to form wo[0]

    d_ff ff1(q[0], qbar[0], wo[0], clk, rst); // D flip-flop for q[0]

    // Logic for q[1]
    and(aw[2], q[2], mode);  // For right shift: Get q[2]
    and(aw[3], not_mode, q[0]); // For left shift: Use q[0]
    or(wo[1], aw[2], aw[3]);  // Combine inputs to form wo[1]

    d_ff ff2(q[1], qbar[1], wo[1], clk, rst); // D flip-flop for q[1]

    // Logic for q[2]
    and(aw[4], q[3], mode);  // For right shift: Get q[3]
    and(aw[5], not_mode, q[1]); // For left shift: Use q[1]
    or(wo[2], aw[4], aw[5]);  // Combine inputs to form wo[2]

    d_ff ff3(q[2], qbar[2], wo[2], clk, rst); // D flip-flop for q[2]

    // Logic for q[3]
    and(aw[6], dr, mode);   // For right shift: Use dr
    and(aw[7], not_mode, q[2]); // For left shift: Use q[2]
    or(wo[3], aw[6], aw[7]);  // Combine inputs to form wo[3]

    d_ff ff4(q[3], qbar[3], wo[3], clk, rst); // D flip-flop for q[3]

endmodule

// D flip-flop module
module d_ff(
    output reg q, qb,      // Flip-flop outputs
    input d, clk, rst      // Data input, clock, and reset
);

always @(posedge clk) begin
    if (rst) begin
        q <= 0;            // Reset q to 0
        qb <= 1;           // Complement qbar to 1
    end else begin
        q <= d;            // Capture data input
        qb <= ~d;          // Complement q
    end
end

endmodule
