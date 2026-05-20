module unsigned_array_mult (
    input  [3:0] X,
    input  [3:0] Y,
    output [7:0] P
);
    wire [15:0] pp;
    
    // Generate partial products
    assign pp[0]  = X[0] & Y[0];
    assign pp[1]  = X[1] & Y[0];
    assign pp[2]  = X[2] & Y[0];
    assign pp[3]  = X[3] & Y[0];
    
    assign pp[4]  = X[0] & Y[1];
    assign pp[5]  = X[1] & Y[1];
    assign pp[6]  = X[2] & Y[1];
    assign pp[7]  = X[3] & Y[1];
    
    assign pp[8]  = X[0] & Y[2];
    assign pp[9]  = X[1] & Y[2];
    assign pp[10] = X[2] & Y[2];
    assign pp[11] = X[3] & Y[2];
    
    assign pp[12] = X[0] & Y[3];
    assign pp[13] = X[1] & Y[3];
    assign pp[14] = X[2] & Y[3];
    assign pp[15] = X[3] & Y[3];

    // Array multiplier addition logic (Ripple Carry Adder for each stage)
    assign P[0] = pp[0];

    // Stage 1
    wire s1_0, c1_0; half_adder ha1_0 (.a(pp[1]), .b(pp[4]), .sum(s1_0), .carry(c1_0));
    wire s1_1, c1_1; full_adder fa1_1 (.a(pp[2]), .b(pp[5]), .cin(c1_0), .sum(s1_1), .cout(c1_1));
    wire s1_2, c1_2; full_adder fa1_2 (.a(pp[3]), .b(pp[6]), .cin(c1_1), .sum(s1_2), .cout(c1_2));
    wire s1_3, c1_3; half_adder ha1_3 (.a(pp[7]), .b(c1_2),  .sum(s1_3), .carry(c1_3));
    assign P[1] = s1_0;

    // Stage 2
    wire s2_0, c2_0; half_adder ha2_0 (.a(s1_1), .b(pp[8]), .sum(s2_0), .carry(c2_0));
    wire s2_1, c2_1; full_adder fa2_1 (.a(s1_2), .b(pp[9]), .cin(c2_0), .sum(s2_1), .cout(c2_1));
    wire s2_2, c2_2; full_adder fa2_2 (.a(s1_3), .b(pp[10]),.cin(c2_1), .sum(s2_2), .cout(c2_2));
    wire s2_3, c2_3; full_adder fa2_3 (.a(c1_3), .b(pp[11]),.cin(c2_2), .sum(s2_3), .cout(c2_3));
    assign P[2] = s2_0;

    // Stage 3
    wire s3_0, c3_0; half_adder ha3_0 (.a(s2_1), .b(pp[12]), .sum(s3_0), .carry(c3_0));
    wire s3_1, c3_1; full_adder fa3_1 (.a(s2_2), .b(pp[13]), .cin(c3_0), .sum(s3_1), .cout(c3_1));
    wire s3_2, c3_2; full_adder fa3_2 (.a(s2_3), .b(pp[14]), .cin(c3_1), .sum(s3_2), .cout(c3_2));
    wire s3_3, c3_3; full_adder fa3_3 (.a(c2_3), .b(pp[15]), .cin(c3_2), .sum(s3_3), .cout(c3_3));
    
    assign P[3] = s3_0;
    assign P[4] = s3_1;
    assign P[5] = s3_2;
    assign P[6] = s3_3;
    assign P[7] = c3_3;

endmodule
