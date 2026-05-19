`timescale 1ns / 1ps

module tb_top();

    reg clk;
    reg mode_btn;
    reg [7:0] sw;
    wire [7:0] led;
    wire [3:0] dig;
    wire [7:0] seg;

    top uut (
        .clk(clk),
        .mode_btn(mode_btn),
        .sw(sw),
        .led(led),
        .dig(dig),
        .seg(seg)
    );

    // Clock generation
    always #10 clk = ~clk;

    initial begin
        clk = 0;
        mode_btn = 1;
        sw = 8'h00;

        // Test Unsigned Array (Mode 0)
        // A=3, B=5 -> P=15 (0F)
        #100;
        sw = {4'd3, 4'd5};
        #100;

        // Change mode to 1 (Signed)
        mode_btn = 0; // Press
        #25000000;    // Wait for debounce > 20ms
        mode_btn = 1; // Release
        #25000000;

        sw = {4'b1111, 4'b0001}; // -1 * 1 = -1 (Sign-Magnitude output: 1000_0001 = 81)
        #100;

        $finish;
    end

endmodule
