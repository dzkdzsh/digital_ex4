`timescale 1ns / 1ps

module tb_mult_top;

    reg [3:0] A;
    reg [3:0] B;
    
    wire [7:0] P_un_arr;
    wire [7:0] P_un_braun;
    wire [7:0] P_sg_arr;
    wire [7:0] P_sg_braun;
    wire [7:0] P_bh_unsgnd;
    wire [7:0] P_bh_sgnd;

    // 实例化被测模块
    unsigned_array_mult u1 (.X(A), .Y(B), .P(P_un_arr));
    unsigned_braun_mult u2 (.X(A), .Y(B), .P(P_un_braun));
    
    signed_array_mult s1 (.A(A), .B(B), .P(P_sg_arr));
    signed_braun_mult s2 (.A(A), .B(B), .P(P_sg_braun));

    behav_mult b1 (.A(A), .B(B), .P_unsgnd(P_bh_unsgnd), .P_sgnd(P_bh_sgnd));

    initial begin
        // 测试案例
        $display("Time |  A  |  B  || UnsgArr | UnsgBrn |  Bh_Un  || SignArr | SignBrn |  Bh_Sg");
        $display("----------------------------------------------------------------------------------");
        
        // 正数测试
        A = 4'd3; B = 4'd2; #10;
        $display("%40t | %d | %d ||   %3d   |   %3d   |   %3d   ||   %3d   |   %3d   |   %3d", 
                 $time, A, B, P_un_arr, P_un_braun, P_bh_unsgnd, $signed(P_sg_arr), $signed(P_sg_braun), $signed(P_bh_sgnd));

        A = 4'd7; B = 4'd5; #10;
        $display("%40t | %d | %d ||   %3d   |   %3d   |   %3d   ||   %3d   |   %3d   |   %3d", 
                 $time, A, B, P_un_arr, P_un_braun, P_bh_unsgnd, $signed(P_sg_arr), $signed(P_sg_braun), $signed(P_bh_sgnd));

        // 负数测试 (对于有符号乘法)
        A = -4'd3; B = 4'd2; #10;
        $display("%40t | %d | %d ||   %3d   |   %3d   |   %3d   ||   %3d   |   %3d   |   %3d", 
                 $time, $signed(A), $signed(B), P_un_arr, P_un_braun, P_bh_unsgnd, $signed(P_sg_arr), $signed(P_sg_braun), $signed(P_bh_sgnd));

        A = -4'd4; B = -4'd2; #10;
        $display("%40t | %d | %d ||   %3d   |   %3d   |   %3d   ||   %3d   |   %3d   |   %3d", 
                 $time, $signed(A), $signed(B), P_un_arr, P_un_braun, P_bh_unsgnd, $signed(P_sg_arr), $signed(P_sg_braun), $signed(P_bh_sgnd));
        
        A = 4'd7; B = -4'd1; #10;
        $display("%40t | %d | %d ||   %3d   |   %3d   |   %3d   ||   %3d   |   %3d   |   %3d", 
                 $time, $signed(A), $signed(B), P_un_arr, P_un_braun, P_bh_unsgnd, $signed(P_sg_arr), $signed(P_sg_braun), $signed(P_bh_sgnd));

        $stop;
    end

endmodule
