module seg_display (
    input clk,             // 系统时钟（通常为50MHz）
    input rst_n,           // 复位信号
    input [3:0] A_val,     // 乘数A的值 (4-bit, 0~15)
    input A_sign,          // 乘数A的符号 (1表示负)
    input [3:0] B_val,     // 乘数B的值 (4-bit, 0~15)
    input B_sign,          // 乘数B的符号
    input [7:0] P_val,     // 结果P的值 (无符号绝对值或数值 0~255)
    input P_sign,          // 结果P的符号
    input is_signed,       // 是否按照有符号模式解析显示
    
    output reg [7:0] seg_sel,  // 数码管位选 (dig1~dig8, 低电平有效)
    output reg [7:0] seg_data  // 数码管段选 (a~g, dp, 高电平亮，视数码管具体共阴/共阳类型定，此处假定为共阴高电平点亮)
);

    // 假设系统时钟50MHz，分频用于数码管动态扫描，大约1kHz扫描频率即可
    reg [15:0] scan_cnt;
    reg [2:0]  scan_sel;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            scan_cnt <= 0;
            scan_sel <= 0;
        end else begin
            if(scan_cnt == 16'd49999) begin // 1ms
                scan_cnt <= 0;
                scan_sel <= scan_sel + 1;
            end else begin
                scan_cnt <= scan_cnt + 1;
            end
        end
    end

    // 二进制转十进制逻辑 (BCD) 用于显示 8-bit P (最大255)
    wire [3:0] p_hun = P_val / 100;
    wire [3:0] p_ten = (P_val % 100) / 10;
    wire [3:0] p_one = P_val % 10;
    
    wire [3:0] a_bcd = A_val > 9 ? (A_val - 10) : A_val;
    wire [3:0] b_bcd = B_val > 9 ? (B_val - 10) : B_val;

    reg [3:0] current_disp;
    reg current_sign;
    reg current_is_blank;
    
    always @(*) begin
        current_is_blank = 0;
        current_sign = 0;
        current_disp = 0;
        seg_sel = 8'b1111_1111;
        
        case(scan_sel)
            3'd0: begin // dig1 : A 符号 / A 的十位 (最左侧)
                seg_sel = 8'b1111_1110; 
                if(is_signed) begin
                    if(A_sign) current_sign = 1; else current_is_blank = 1;
                end else begin
                    current_disp = A_val / 10;
                    if(A_val < 10) current_is_blank = 1;
                end
            end
            3'd1: begin // dig2 : A 的个位 / 值
                seg_sel = 8'b1111_1101; 
                current_disp = is_signed ? A_val : (A_val % 10);
            end
            3'd2: begin // dig3 : B 符号 / B 的十位
                seg_sel = 8'b1111_1011; 
                if(is_signed) begin
                    if(B_sign) current_sign = 1; else current_is_blank = 1;
                end else begin
                    current_disp = B_val / 10;
                    if(B_val < 10) current_is_blank = 1;
                end
            end
            3'd3: begin // dig4 : B 的个位 / 值
                seg_sel = 8'b1111_0111; 
                current_disp = is_signed ? B_val : (B_val % 10);
            end
            3'd4: begin // dig5 : P 符号
                seg_sel = 8'b1110_1111; 
                if(is_signed && P_sign) current_sign = 1; else current_is_blank = 1;
            end
            3'd5: begin // dig6 : P 百位
                seg_sel = 8'b1101_1111; 
                current_disp = p_hun;
                if(P_val < 100) current_is_blank = 1; 
            end
            3'd6: begin // dig7 : P 十位
                seg_sel = 8'b1011_1111; 
                current_disp = p_ten;
                if(P_val < 10) current_is_blank = 1; // 消隐前导零
            end
            3'd7: begin // dig8 : P 个位 (最右侧)
                seg_sel = 8'b0111_1111; 
                current_disp = p_one;
            end
        endcase
    end

    // 段码转换 (共阴极，高电平点亮：{dp,g,f,e,d,c,b,a})
    always @(*) begin
        if(current_is_blank) begin
            seg_data = 8'b0000_0000;
        end else if(current_sign) begin
            seg_data = 8'b0100_0000; // 仅显示中间一横(g)
        end else begin
            case(current_disp)
                4'd0: seg_data = 8'b0011_1111;
                4'd1: seg_data = 8'b0000_0110;
                4'd2: seg_data = 8'b0101_1011;
                4'd3: seg_data = 8'b0100_1111;
                4'd4: seg_data = 8'b0110_0110;
                4'd5: seg_data = 8'b0110_1101;
                4'd6: seg_data = 8'b0111_1101;
                4'd7: seg_data = 8'b0000_0111;
                4'd8: seg_data = 8'b0111_1111;
                4'd9: seg_data = 8'b0110_1111;
                default: seg_data = 8'b0000_0000;
            endcase
        end
    end

endmodule