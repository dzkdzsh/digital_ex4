module mult_top (
    input        clk,    // 系统时钟 50MHz
    input        rst_n,  // 复位 (可选，若无按键可直连高电平)
    input  [3:0] sw_A,   // 拨码开关 SW7~SW4 -> A
    input  [3:0] sw_B,   // 拨码开关 SW3~SW0 -> B
    output [7:0] seg_sel,  // 数码管位选 (dig8~dig1低电平有效)
    output [7:0] seg_data  // 数码管段选 (dp,g,f,e,d,c,b,a)
);

    wire [7:0] P_wire;

    // ==========================================
    // 原乘法器调用及显示逻辑 (已注释，需要时可解开)
    // ==========================================
    /*
    signed_array_mult s_array (
        .A(sw_A),
        .B(sw_B),
        .P(P_wire)
    );

    wire is_signed = 1'b1; 
    
    wire a_sign = is_signed ? sw_A[3] : 1'b0;
    wire [3:0] a_val = is_signed ? (a_sign ? (~sw_A + 1'b1) : sw_A) : sw_A;
    
    wire b_sign = is_signed ? sw_B[3] : 1'b0;
    wire [3:0] b_val = is_signed ? (b_sign ? (~sw_B + 1'b1) : sw_B) : sw_B;

    wire p_sign = is_signed ? P_wire[7] : 1'b0;
    wire [7:0] p_val = is_signed ? (p_sign ? (~P_wire + 1'b1) : P_wire) : P_wire;

    seg_display u_seg_display (
        .clk(clk),
        .rst_n(rst_n),
        .A_val(a_val),
        .A_sign(a_sign),
        .B_val(b_val),
        .B_sign(b_sign),
        .P_val(p_val),
        .P_sign(p_sign),
        .is_signed(is_signed),
        .seg_sel(seg_sel),
        .seg_data(seg_data)
    );
    */

    // ==========================================
    // 选做：常数除法器调用 (除以3) 接口映射
    // ==========================================
    wire [7:0] num_in = {sw_A, sw_B};  // 8位拨码开关组合为除数输入
    wire [7:0] quo_wire;
    wire [7:0] rem_wire;

    const_divider_by_3 u_div (
        .num(num_in),
        .quo(quo_wire),
        .rem(rem_wire)
    );

    // 调用除法器专用数码管显示模块
    seg_display_div u_seg_display_div (
        .clk(clk),
        .rst_n(rst_n),
        .num_val(num_in),
        .quo_val(quo_wire),
        .rem_val(rem_wire),
        .seg_sel(seg_sel),
        .seg_data(seg_data)
    );

endmodule
