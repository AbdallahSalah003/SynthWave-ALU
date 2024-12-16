module tb_floating_point_adder;
    reg [31:0] A, B;
    wire [31:0] Sum;
    wire Cout, Overflow;

    floating_point_adder FPA(
        .A(A),
        .B(B),
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
        
        begin
            if (sum == expected_sum && overflow == expected_overflow && cout == expected_cout) begin
                success_tcs = success_tcs + 1;
                $display("TestCase#%0d: success", test_case_number);
            end else begin
                failure_tcs = failure_tcs + 1;
                $display("TestCase#%0d: failed", test_case_number);
            end
            $display("input A=%h, B=%h, Sum=%h, Overflow=%b, Cout=%b | Exp_Sum=%h, Exp_Overflow=%b Exp_Cout=%b", 
                        A, B, sum, overflow, cout, expected_sum, expected_overflow, expected_cout);
        end
    endtask

    initial begin
        // Addition of two positive numbers 
        A = 32'b00111110100110011001100110011010; // 0.3
        B = 32'b01000011111110100010000000000000; // 500.25
        test_case_number = test_case_number + 1;
        #10;  
        check_result(A, B, 32'b01000011111110100100011001100110, 0, Sum, Overflow, Cout, 0); // 500.55

        // Addition of a positive and a negative number
        A = 32'b10111110100110011001100110011010; // -0.3
        B = 32'b01000011111110100010000000000000; // 500.25
        test_case_number = test_case_number + 1;
        #10;  
        check_result(A, B, 32'b01000011111110011111100110011010, 0, Sum, Overflow, Cout, 0); // 499.95

        // Addition of two negative numbers 
        A = 32'b11000000010011000010100011110110; // -3.19
        B = 32'b11000001000000111000010100011111; // -8.22
        test_case_number = test_case_number + 1;
        #10;  
        check_result(A, B, 32'b11000001001101101000111101011100, 0, Sum, Overflow, Cout, 0); // -11.41

        $display("Total Test Cases: %0d, Success: %0d, Failures: %0d", 
                success_tcs + failure_tcs, success_tcs, failure_tcs);
        $finish;
    end

endmodule
