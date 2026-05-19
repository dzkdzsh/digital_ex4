module unsigned_braun_mult (
    input  [3:0] X,
    input  [3:0] Y,
    output [7:0] P
);
    wire [15:0] pp;
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

    assign P[0] = pp[0];

    // Row 1 (Adding Y[0] and Y[1] partial products)
    wire s1_0, c1_0; half_adder r1_0 (.a(pp[1]), .b(pp[4]), .sum(P[1]), .carry(c1_0));
    wire s1_1, c1_1; full_adder r1_1 (.a(pp[2]), .b(pp[5]), .cin(0), .sum(s1_1), .cout(c1_1));
    wire s1_2, c1_2; full_adder r1_2 (.a(pp[3]), .b(pp[6]), .cin(0), .sum(s1_2), .cout(c1_2));
    
    // Row 2 (Adding Y[2] partial products)
    wire s2_0, c2_0; full_adder r2_0 (.a(s1_1), .b(pp[8]), .cin(c1_0), .sum(P[2]), .cout(c2_0));
    wire s2_1, c2_1; full_adder r2_1 (.a(s1_2), .b(pp[9]), .cin(c1_1), .sum(s2_1), .cout(c2_1));
    wire s2_2, c2_2; full_adder r2_2 (.a(pp[7]), .b(pp[10]), .cin(c1_2), .sum(s2_2), .cout(c2_2));
    
    // Row 3 (Adding Y[3] partial products)
    wire s3_0, c3_0; full_adder r3_0 (.a(s2_1), .b(pp[12]), .cin(c2_0), .sum(P[3]), .cout(c3_0));
    wire s3_1, c3_1; full_adder r3_1 (.a(s2_2), .b(pp[13]), .cin(c2_1), .sum(s3_1), .cout(c3_1));
    wire s3_2, c3_2; full_adder r3_2 (.a(pp[11]), .b(pp[14]), .cin(c2_2), .sum(s3_2), .cout(c3_2));
    
    // Final row (Ripple carry adder)
    wire s4_0, c4_0; half_adder r4_0 (.a(s3_1), .b(c3_0), .sum(P[4]), .carry(c4_0));
    wire s4_1, c4_1; full_adder r4_1 (.a(s3_2), .b(c3_1), .cin(c4_0), .sum(P[5]), .cout(c4_1));
    wire s4_2, c4_2; full_adder r4_2 (.a(pp[15]), .b(c3_2), .cin(c4_1), .sum(P[6]), .cout(c4_2));
    
    assign P[7] = c4_2;

endmodule
