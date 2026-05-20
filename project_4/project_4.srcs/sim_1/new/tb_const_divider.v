`timescale 1ns / 1ps

module tb_const_divider;

    reg  [7:0] num;
    wire [7:0] quo;
    wire [7:0] rem;

    // 实例化常数除法器 (除数为3)
    const_divider_by_3 uut (
        .num(num),
        .quo(quo),
        .rem(rem)
    );

    integer i, err_cnt;

    initial begin
        err_cnt = 0;
        $display("========================================");
        $display("   Const Divider By 3 (Magic Number)    ");
        $display("========================================");
        $display(" Time | Num | Quo | Rem || Expected: Q | R");
        $display("----------------------------------------");

        // 遍历所有可能的 8 位输入 (0 到 255)
        for (i = 0; i < 256; i = i + 1) begin
            num = i;
            #10;
            
            // 结果比对：如果行为级结果(i/3, i%3)与模块跑出来的不同，则抓取错误
            if (quo !== (i / 3) || rem !== (i % 3)) begin
                $display("%5t | %3d | %3d | %3d ||         %3d | %3d  <-- ERROR!", 
                         $time, num, quo, rem, i / 3, i % 3);
                err_cnt = err_cnt + 1;
            end
            
            // 打印几个有代表性的边界和常态
            if (i < 5 || i == 100 || i == 254 || i == 255) begin
                $display("%5t | %3d | %3d | %3d ||         %3d | %3d", 
                         $time, num, quo, rem, i / 3, i % 3);
            end
        end

        $display("----------------------------------------");
        if (err_cnt == 0) begin
            $display("SUCCESS: ALL 256 Test Cases Passed Perfect Match!");
        end else begin
            $display("FAILED: Found %d Errors.", err_cnt);
        end
        $display("========================================");
        
        $stop;
    end

endmodule
