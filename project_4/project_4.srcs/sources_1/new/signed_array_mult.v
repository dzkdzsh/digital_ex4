module signed_array_mult (
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] P
);
    // 有符号阵列乘法器：
    // 通过提取操作数的绝对值送入无符号阵列乘法器，最后结合符号位得到有符号结果
    // 这种结构既利用了阵列乘法器的核心，又确保了补码运算的绝对正确

    wire sign_A = A[3];
    wire sign_B = B[3];
    wire sign_P = sign_A ^ sign_B;

    wire [3:0] abs_A = sign_A ? (~A + 1'b1) : A;
    wire [3:0] abs_B = sign_B ? (~B + 1'b1) : B;

    wire [7:0] unsgnd_P;
    
    unsigned_array_mult u_array (
        .X(abs_A),
        .Y(abs_B),
        .P(unsgnd_P)
    );

    // 恢复符号位：如果异号则取其补码
    assign P = sign_P ? (~unsgnd_P + 1'b1) : unsgnd_P;

endmodule
