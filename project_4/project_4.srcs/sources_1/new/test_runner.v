module test_runner;
    reg [3:0] A, B;
    wire [7:0] p_ua, p_ub, p_sa, p_sb, p_bu, p_bs;
    
    unsigned_array_mult ua (.X(A), .Y(B), .P(p_ua));
    unsigned_braun_mult ub (.X(A), .Y(B), .P(p_ub));
    signed_array_mult   sa (.A(A), .B(B), .P(p_sa));
    signed_braun_mult   sb (.A(A), .B(B), .P(p_sb));
    behav_mult          bh (.A(A), .B(B), .P_unsgnd(p_bu), .P_sgnd(p_bs));

    integer i, j, err_cnt;

    initial begin
        err_cnt = 0;
        for(i=0; i<16; i=i+1) begin
            for(j=0; j<16; j=j+1) begin
                A = i; B = j;
                #1;
                if(p_ua !== p_bu) begin $display("UA error: A=%d B=%d exp=%d got=%d", A, B, p_bu, p_ua); err_cnt=err_cnt+1; end
                if(p_ub !== p_bu) begin $display("UB error: A=%d B=%d exp=%d got=%d", A, B, p_bu, p_ub); err_cnt=err_cnt+1; end
                if(p_sa !== p_bs) begin $display("SA error: A=%d B=%d exp=%d got=%d", $signed(A), $signed(B), $signed(p_bs), $signed(p_sa)); err_cnt=err_cnt+1; end
                if(p_sb !== p_bs) begin $display("SB error: A=%d B=%d exp=%d got=%d", $signed(A), $signed(B), $signed(p_bs), $signed(p_sb)); err_cnt=err_cnt+1; end
            end
        end
        if(err_cnt == 0) $display("ALL MATCH PERFECTLY!");
        else $display("Found %d errors!", err_cnt);
        $finish;
    end
endmodule
