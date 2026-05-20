`timescale 1ns / 1ps

module seg_display_div (
    input clk,
    input rst_n,
    input [7:0] num_val, // 被除数 (0-255)
    input [7:0] quo_val, // 商 (0-85)
    input [7:0] rem_val, // 余数 (0-2)
    output reg [7:0] seg_sel,
    output reg [7:0] seg_data
);

    reg [15:0] scan_cnt;
    reg [2:0]  scan_sel;

    // 1kHz 数码管动态扫描定时器
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

    // 取出各个数位
    wire [3:0] n_hun = num_val / 100;
    wire [3:0] n_ten = (num_val % 100) / 10;
    wire [3:0] n_one = num_val % 10;
    
    wire [3:0] q_ten = quo_val / 10;
    wire [3:0] q_one = quo_val % 10;
    
    wire [3:0] r_one = rem_val % 10;

    reg [3:0] current_disp;
    reg current_is_blank;
    reg current_dash;
    
    always @(*) begin
        current_is_blank = 0;
        current_dash = 0;
        current_disp = 0;
        seg_sel = 8'b1111_1111;
        
        case(scan_sel)
            3'd0: begin // dig1 : num 百位
                seg_sel = 8'b1111_1110; 
                current_disp = n_hun;
                if(num_val < 100) current_is_blank = 1; // 消隐前导零
            end
            3'd1: begin // dig2 : num 十位
                seg_sel = 8'b1111_1101; 
                current_disp = n_ten;
                if(num_val < 10) current_is_blank = 1;
            end
            3'd2: begin // dig3 : num 个位
                seg_sel = 8'b1111_1011; 
                current_disp = n_one;
            end
            3'd3: begin // dig4 : '-'
                seg_sel = 8'b1111_0111;
                current_dash = 1;
            end
            3'd4: begin // dig5 : quo 十位
                seg_sel = 8'b1110_1111;
                current_disp = q_ten;
                if(quo_val < 10) current_is_blank = 1;
            end
            3'd5: begin // dig6 : quo 个位
                seg_sel = 8'b1101_1111;
                current_disp = q_one;
            end
            3'd6: begin // dig7 : '-'
                seg_sel = 8'b1011_1111;
                current_dash = 1;
            end
            3'd7: begin // dig8 : rem 个位
                seg_sel = 8'b0111_1111;
                current_disp = r_one;
            end
        endcase
    end

    // 段码转换 (共阴极)
    always @(*) begin
        if(current_is_blank) begin
            seg_data = 8'b0000_0000;
        end else if(current_dash) begin
            seg_data = 8'b0100_0000; // 仅亮中横杠 'g'
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
