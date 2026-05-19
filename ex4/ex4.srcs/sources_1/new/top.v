module top (
    input clk,          // PL_GCLK, U18 (50 MHz)
    input mode_btn,     // N15, active low
    input [7:0] sw,     // J10 sw7~0
    output [7:0] led,   // J11 led8~1, active low
    output [3:0] dig,   // J11 dig4~1, active low
    output [7:0] seg    // J11 dp, g, f, e, d, c, b, a, active low
);
    // ----------------------------------------------------
    // Debounce the mode button
    // ----------------------------------------------------
    reg [19:0] cnt = 0;
    reg btn_reg_1 = 1, btn_reg_2 = 1;
    wire btn_press;
    
    always @(posedge clk) begin
        btn_reg_1 <= mode_btn;
        btn_reg_2 <= btn_reg_1;
    end
    
    always @(posedge clk) begin
        if (btn_reg_1 == 1'b0 && btn_reg_2 == 1'b1)
            cnt <= 20'd0;
        else if (cnt < 20'd1000000) // approx 20ms at 50MHz
            cnt <= cnt + 1'b1;
    end
    
    reg btn_state = 1;
    reg btn_state_prev = 1;
    always @(posedge clk) begin
        if (cnt == 20'd999999) begin
            btn_state <= btn_reg_2;
        end
        btn_state_prev <= btn_state;
    end
    
    assign btn_press = (btn_state_prev == 1'b1 && btn_state == 1'b0);

    // ----------------------------------------------------
    // Mode Selection (Toggle between Unsigned and Signed)
    // ----------------------------------------------------
    reg mode = 1'b0; // 0: Unsigned, 1: Signed
    always @(posedge clk) begin
        if (btn_press) begin
            mode <= ~mode;
        end
    end

    // ----------------------------------------------------
    // Multiplicands
    // ----------------------------------------------------
    wire [3:0] A = sw[7:4];
    wire [3:0] B = sw[3:0];

    wire [7:0] res_unsign;
    array_mult_unsigned mut_unsign(.A(A), .B(B), .P(res_unsign));

    // Signed arithmetic using sign-magnitude conversion
    wire sign_A = A[3];
    wire sign_B = B[3];
    wire [3:0] abs_A = sign_A ? (~A + 1'b1) : A;
    wire [3:0] abs_B = sign_B ? (~B + 1'b1) : B;
    
    wire [7:0] mag_mult;
    array_mult_unsigned mut_mag(.A(abs_A), .B(abs_B), .P(mag_mult));
    
    wire result_sign = (mag_mult == 8'd0) ? 1'b0 : (sign_A ^ sign_B);
    wire [7:0] res_sign = {result_sign, mag_mult[6:0]};

    reg [7:0] current_res;
    always @(*) begin
        case (mode)
            1'b0: current_res = res_unsign;
            1'b1: current_res = res_sign;
        endcase
    end

    // Output to LED (active low)
    assign led = ~current_res;

    // ----------------------------------------------------
    // 7-segment display logic (Active Low)
    // ----------------------------------------------------
    // Enable only first digit
    assign dig = 4'b1110; 
    
    reg [7:0] seg_reg;
    always @(*) begin
        case (mode)
            // dp, g, f, e, d, c, b, a (0 means ON)
            1'b0: seg_reg = 8'b11000000; // Display '0' for Unsigned
            1'b1: seg_reg = 8'b11111001; // Display '1' for Signed
        endcase
    end
    assign seg = seg_reg;

endmodule
