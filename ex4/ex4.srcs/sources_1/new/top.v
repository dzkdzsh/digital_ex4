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
    // Mode Selection
    // ----------------------------------------------------
    reg [2:0] mode = 3'd0;
    always @(posedge clk) begin
        if (btn_press) begin
            if (mode >= 3'd4)
                mode <= 3'd0;
            else
                mode <= mode + 1'b1;
        end
    end

    // ----------------------------------------------------
    // Multiplicands
    // ----------------------------------------------------
    wire [3:0] A = sw[7:4];
    wire [3:0] B = sw[3:0];

    wire [7:0] res0, res1, res2, res3, res4;

    array_mult_unsigned mut0(.A(A), .B(B), .P(res0));
    braun_mult_unsigned mut1(.A(A), .B(B), .P(res1));
    array_mult_signed   mut2(.A(A), .B(B), .P(res2));
    braun_mult_signed   mut3(.A(A), .B(B), .P(res3));
    behavioral_mult     mut4(.A(A), .B(B), .P(res4));

    reg [7:0] current_res;
    always @(*) begin
        case (mode)
            3'd0: current_res = res0;
            3'd1: current_res = res1;
            3'd2: current_res = res2;
            3'd3: current_res = res3;
            3'd4: current_res = res4;
            default: current_res = 8'd0;
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
            3'd0: seg_reg = 8'b11000000; // 0
            3'd1: seg_reg = 8'b11111001; // 1
            3'd2: seg_reg = 8'b10100100; // 2
            3'd3: seg_reg = 8'b10110000; // 3
            3'd4: seg_reg = 8'b10011001; // 4
            default: seg_reg = 8'b11000000;
        endcase
    end
    assign seg = seg_reg;

endmodule
