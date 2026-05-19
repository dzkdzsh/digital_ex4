module braun_mult_unsigned (
    input [3:0] A, // Multiplicand
    input [3:0] B, // Multiplier
    output [7:0] P // Product
);
    wire [15:0] pp;
    // Partial Products
    assign pp[0]  = A[0] & B[0]; assign pp[1]  = A[1] & B[0]; assign pp[2]  = A[2] & B[0]; assign pp[3]  = A[3] & B[0];
    assign pp[4]  = A[0] & B[1]; assign pp[5]  = A[1] & B[1]; assign pp[6]  = A[2] & B[1]; assign pp[7]  = A[3] & B[1];
    assign pp[8]  = A[0] & B[2]; assign pp[9]  = A[1] & B[2]; assign pp[10] = A[2] & B[2]; assign pp[11] = A[3] & B[2];
    assign pp[12] = A[0] & B[3]; assign pp[13] = A[1] & B[3]; assign pp[14] = A[2] & B[3]; assign pp[15] = A[3] & B[3];

    // Stage 1 (Carry Save)
    wire [2:0] s1, c1;
    assign P[0] = pp[0];
    half_adder ha1_0(pp[1], pp[4], P[1], c1[0]);
    half_adder ha1_1(pp[2], pp[5], s1[1], c1[1]);
    half_adder ha1_2(pp[3], pp[6], s1[2], c1[2]);
    // pp[7] is passed to next stage

    // Stage 2 (Carry Save)
    wire [2:0] s2, c2;
    full_adder fa2_0(s1[1], pp[8], c1[0], P[2], c2[0]);
    full_adder fa2_1(s1[2], pp[9], c1[1], s2[1], c2[1]);
    full_adder fa2_2(pp[7], pp[10], c1[2], s2[2], c2[2]);
    // pp[11] passed

    // Stage 3 (Carry Save / Ripple Carry for final row)
    wire [2:0] s3, c3;
    full_adder fa3_0(s2[1], pp[12], c2[0], P[3], c3[0]);
    full_adder fa3_1(s2[2], pp[13], c2[1], s3[1], c3[1]);
    full_adder fa3_2(pp[11], pp[14], c2[2], s3[2], c3[2]);

    // Final Ripple Carry Addition for the last row
    wire c4_0, c4_1;
    half_adder ha_final_0(s3[1], c3[0], P[4], c4_0);
    full_adder fa_final_1(s3[2], c3[1], c4_0, P[5], c4_1);
    full_adder fa_final_2(pp[15], c3[2], c4_1, P[6], P[7]);

endmodule
