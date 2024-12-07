module tb_ripple_carry_adder;
    reg [31:0] A, B;
    reg Cin;
    wire [31:0] Sum;
    wire Cout, Overflow;

    ripple_carry_adder RCA (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout),
        .Overflow(Overflow)
    );

    integer success_tcs = 0;
    integer failure_tcs = 0;
    integer test_case_number = 0;

    task check_result;
        input [31:0] A;
        input [31:0] B;
        input [31:0] expected_sum;
        input expected_overflow;
        input [31:0] sum;
        input overflow;
        input cout;
        input expected_cout;
        input cin;
        
        begin
            if (sum == expected_sum && overflow == expected_overflow && cout == expected_cout) begin
                success_tcs = success_tcs + 1;
                $display("TestCase#%0d: success", test_case_number);
            end else begin
                failure_tcs = failure_tcs + 1;
                $display("TestCase#%0d: failed", test_case_number);
            end
            $display("input A=%h, B=%h, Sum=%h, Overflow=%b, Cin=%b, Cout=%b | Exp_Sum=%h, Exp_Overflow=%b Exp_Cout=%b", 
                        A, B, sum, overflow, cin, cout, expected_sum, expected_overflow, expected_cout);
        end
    endtask

    initial begin
        // Overflow of positive numbers 
        A = 32'h7FFFFFFF;  
        B = 32'h7FFFFFFF;  
        Cin = 0;
        test_case_number = test_case_number + 1;
        #10;  
        check_result(A, B, 32'hFFFFFFFE, 1, Sum, Overflow, Cout, 0, Cin);

        //Overflow of negative numbers 
        A = 32'h80000000;   // -2^31, signed negative number
        B = 32'h80000000;  
        Cin = 0;
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 32'h00000000, 1, Sum, Overflow, Cout, 1, Cin);

        // Addition of a positive and a negative number
        A = 32'h7FFFFFFF;  
        B = 32'h80000000;  
        Cin = 0;
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 32'hFFFFFFFF, 0, Sum, Overflow, Cout, 0, Cin);

        // Addition of two positive numbers
        A = 32'h12345678;
        B = 32'h87654321;
        Cin = 0;
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 32'h99999999, 0, Sum, Overflow, Cout, 0, Cin);

        // Addition of two negative numbers 
        A = 32'hFFFFFFFE;  // -2 in decimal
        B = 32'hFFFFFFFD;  // -3 in decimal
        Cin = 0;
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 32'hFFFFFFFB, 0, Sum, Overflow, Cout, 1, Cin);

        // Random Test Case 1
        A = 32'h7A5B2C1D;
        B = 32'h2F1D3C5B;
        Cin = 0;
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 32'hA9786878, 1, Sum, Overflow, Cout, 0, Cin);

        //Random Test Case 2
        A = 32'h12345678;
        B = 32'h87654321;
        Cin = 1;
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 32'h9999999a, 0, Sum, Overflow, Cout, 0, Cin);

        //Random Test Case 3
        A = 32'hABCDE123;
        B = 32'h54321DEF;
        Cin = 1;
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 32'hFFFFFF13, 0, Sum, Overflow, Cout, 0, Cin);

        $display("Total Test Cases: %0d, Success: %0d, Failures: %0d", 
                success_tcs + failure_tcs, success_tcs, failure_tcs);
        $finish;
    end

endmodule
