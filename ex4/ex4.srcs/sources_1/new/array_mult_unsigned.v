module array_mult_unsigned (
    input [3:0] A, // Multiplicand
    input [3:0] B, // Multiplier
    output [7:0] P // Product
);
    wire [15:0] pp;
    // Generate Partial Products
    assign pp[0]  = A[0] & B[0]; assign pp[1]  = A[1] & B[0]; assign pp[2]  = A[2] & B[0]; assign pp[3]  = A[3] & B[0];
    assign pp[4]  = A[0] & B[1]; assign pp[5]  = A[1] & B[1]; assign pp[6]  = A[2] & B[1]; assign pp[7]  = A[3] & B[1];
    assign pp[8]  = A[0] & B[2]; assign pp[9]  = A[1] & B[2]; assign pp[10] = A[2] & B[2]; assign pp[11] = A[3] & B[2];
    assign pp[12] = A[0] & B[3]; assign pp[13] = A[1] & B[3]; assign pp[14] = A[2] & B[3]; assign pp[15] = A[3] & B[3];

    // Stage 1 (Ripple Carry)
    wire [3:0] s1, c1;
    assign P[0] = pp[0];
    half_adder ha1_0(pp[4], pp[1], s1[0], c1[0]);
    full_adder fa1_1(pp[5], pp[2], c1[0], s1[1], c1[1]);
    full_adder fa1_2(pp[6], pp[3], c1[1], s1[2], c1[2]);
    half_adder ha1_3(pp[7], c1[2], s1[3], c1[3]);

    // Stage 2
    wire [3:0] s2, c2;
    assign P[1] = s1[0];
    half_adder ha2_0(pp[8], s1[1], s2[0], c2[0]);
    full_adder fa2_1(pp[9], s1[2], c2[0], s2[1], c2[1]);
    full_adder fa2_2(pp[10], s1[3], c2[1], s2[2], c2[2]);
    full_adder fa2_3(pp[11], c1[3], c2[2], s2[3], c2[3]);

    // Stage 3
    wire [3:0] s3, c3;
    assign P[2] = s2[0];
    half_adder ha3_0(pp[12], s2[1], s3[0], c3[0]);
    full_adder fa3_1(pp[13], s2[2], c3[0], s3[1], c3[1]);
    full_adder fa3_2(pp[14], s2[3], c3[1], s3[2], c3[2]);
    full_adder fa3_3(pp[15], c2[3], c3[2], s3[3], c3[3]);

    assign P[3] = s3[0];
    assign P[4] = s3[1];
    assign P[5] = s3[2];
    assign P[6] = s3[3];
    assign P[7] = c3[3];

endmodule
