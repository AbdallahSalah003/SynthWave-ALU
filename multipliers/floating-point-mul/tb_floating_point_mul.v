module tb_multiplier;
    reg [31:0] A, B; 
    wire [31:0] Product; 

    floating_point_mul DUT (
        .A(A),
        .B(B),
        .Product(Product)
    );

    integer success_tcs = 0;
    integer failure_tcs = 0;
    integer test_case_number = 0;

    task check_result;
        input [31:0] A;
        input [31:0] B;
        input [31:0] expected_product;
        input [31:0] product;

        begin
            if (product == expected_product) begin
                success_tcs = success_tcs + 1;
                $display("TestCase#%0d: success", test_case_number);
            end else begin
                failure_tcs = failure_tcs + 1;
                $display("TestCase#%0d: failed", test_case_number);
            end
            $display("Input A=%b, B=%b, Product=%b | Expected Product=%b", 
                    A, B, product, expected_product);
        end
    endtask

    function [31:0] create_fp;
        input sign;
        input [7:0] exp;
        input [22:0] mantissa;
        begin
            create_fp = {sign, exp, mantissa};
        end
    endfunction

    initial begin
        // Test Case 1: Multiplication of two positive numbers
        A = create_fp(0, 8'b10000001, 23'b01010000000000000000000);    // 5.25 
        B = create_fp(0, 8'b10000000, 23'b00011001100110011001101);   // 2.2
        test_case_number = test_case_number + 1;     
        #10;                                        
        check_result(A, B, create_fp(0, 8'b10000010, 23'b01110001100110011001101), Product); // 11.55

        // Test Case 2: Multiplication of a positive and a negative number
        A = create_fp(1, 8'b01111101, 23'b00110011001100110011010);    // -0.3 = 0.010011 = 1.0011 *  2^-2
        B = create_fp(0, 8'b10000111, 23'b11110100010000000000000);   // 500.25 = 111110100.01 = 1.1111010001 * 2^8 
        test_case_number = test_case_number + 1;     
        #10;                                        //  8 -2 = 7, result bais exp(7 + 127)
        check_result(A, B, create_fp(1, 8'b10000110, 23'b00101100001001100110100), Product);  

        // Test Case 3: Multiplication with zero
        A = create_fp(1, 8'b01111101, 23'b00110011001100110011010);    // -0.3 = 0.010011 = 1.0011 *  2^-2
        B = create_fp(0, 8'b00000000, 23'b00000000000000000000000);   // 0 
        test_case_number = test_case_number + 1;     
        #10;                                        
        check_result(A, B, create_fp(0, 8'b00000000, 23'b00000000000000000000000), Product);

        // Test Case 4: Multiplication by one
        A = create_fp(1, 8'b01111101, 23'b00110011001100110011010);    // -0.3 = 0.010011 = 1.0011 *  2^-2
        B = create_fp(0, 8'b01111111, 23'b00000000000000000000000);   // 1
        test_case_number = test_case_number + 1;     
        #10;                                        
        check_result(A, B, create_fp(1, 8'b01111101, 23'b00110011001100110011010), Product);

        // Test Case 5: Multiplication of two negative numbers
        A = create_fp(1, 8'b10000001, 23'b01010000000000000000000);    // -5.25 
        B = create_fp(1, 8'b10000000, 23'b00011001100110011001101);   // -2.2
        test_case_number = test_case_number + 1;     
        #10;                                        
        check_result(A, B, create_fp(0, 8'b10000010, 23'b01110001100110011001101), Product); // 11.55

        $display("Total Test Cases: %0d, Success: %0d, Failures: %0d", 
                success_tcs + failure_tcs, success_tcs, failure_tcs);
        $finish;
    end
endmodule