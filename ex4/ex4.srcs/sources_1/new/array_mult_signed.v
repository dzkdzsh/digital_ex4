module array_mult_signed (
    input [3:0] A,
    input [3:0] B,
    output [7:0] P
);
    wire sign_A = A[3];
    wire sign_B = B[3];
    wire [3:0] abs_A = sign_A ? (~A + 1'b1) : A;
    wire [3:0] abs_B = sign_B ? (~B + 1'b1) : B;
    
    wire [7:0] mult_out;
    array_mult_unsigned u_mult (
        .A(abs_A),
        .B(abs_B),
        .P(mult_out)
    );
    
    wire result_sign = sign_A ^ sign_B;
    assign P = result_sign ? (~mult_out + 1'b1) : mult_out;
endmodule
