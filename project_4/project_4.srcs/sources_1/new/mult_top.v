module mult_top (
    input        clk,    // 系统时钟 50MHz
    input        rst_n,  // 复位 (可选，若无按键可直连高电平)
    input  [3:0] sw_A,   // 拨码开关 SW7~SW4 -> A
    input  [3:0] sw_B,   // 拨码开关 SW3~SW0 -> B
    output [7:0] seg_sel,  // 数码管位选 (dig8~dig1低电平有效)
    output [7:0] seg_data  // 数码管段选 (dp,g,f,e,d,c,b,a)
);

    wire [7:0] P_wire;

   signed_array_mult s_array (
        .A(sw_A),
        .B(sw_B),
        .P(P_wire)
    );
 
    /*

  unsigned_array_mult u_mult (
        .X(sw_A),
        .Y(sw_B),
        .P(P_wire)
    );
   

    unsigned_braun_mult u_braun (
        .X(sw_A),
        .Y(sw_B),
        .P(P_wire)
    );
    
 

    signed_braun_mult s_braun (
        .A(sw_A),
        .B(sw_B),
        .P(P_wire)
    );

    behav_mult behav (
        .A(sw_A),
        .B(sw_B),
        .P_unsgnd(P_wire),
        .P_sgnd()
    );
  
    */

    // ----- 数码管显示逻辑 -----
    // 注：若验证有符号乘法器，请将 `is_signed` 置为 1'b1 
    // 若验证无符号乘法器，请将 `is_signed` 置为 1'b0
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

endmodule
