module behav_mult (
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] P_unsgnd,
    output [7:0] P_sgnd
);
    // 无符号乘法
    assign P_unsgnd = A * B;
    
    // 有符号乘法
    assign P_sgnd = $signed(A) * $signed(B);

endmodule
