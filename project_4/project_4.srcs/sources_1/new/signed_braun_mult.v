module signed_braun_mult (
    input  [3:0] A,
    input  [3:0] B,
    output [7:0] P
);
    // 有符号布劳恩乘法器：由于布劳恩乘法器本质是无符号的结构
    // 我们提取操作数的绝对值送入无符号布劳恩乘法器，最后结合符号位得到结果
    wire sign_A = A[3];
    wire sign_B = B[3];
    wire sign_P = sign_A ^ sign_B;

    wire [3:0] abs_A = sign_A ? (~A + 1'b1) : A;
    wire [3:0] abs_B = sign_B ? (~B + 1'b1) : B;

    wire [7:0] unsgnd_P;
    
    unsigned_braun_mult u_braun (
        .X(abs_A),
        .Y(abs_B),
        .P(unsgnd_P)
    );

    assign P = sign_P ? (~unsgnd_P + 1'b1) : unsgnd_P;

endmodule
