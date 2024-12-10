module tb_SAdd_mul_32bit;
    reg [31:0] A, B; 
    wire [63:0] Product; 

    sequential_mul DUT (
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
        input [63:0] expected_product;
        input [63:0] product;

        begin
            if (product == expected_product) begin
                success_tcs = success_tcs + 1;
                $display("TestCase#%0d: success", test_case_number);
            end else begin
                failure_tcs = failure_tcs + 1;
                $display("TestCase#%0d: failed", test_case_number);
            end
            $display("Input A=%h, B=%h, Product=%h | Expected Product=%h", 
                    A, B, product, expected_product);
        end
    endtask

    initial begin
        // ultiplication of a positive and a negative number
        A = 20;       
        B = -3;       
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, -64'd60, Product); 

        //Multiplication of two positive numbers
        A = 77;       
        B = 88;       
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 64'd6776, Product);

        // Multiplication of two negative numbers
        A = -90;       
        B = -90;       
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 64'd8100, Product); 

        // Multiplication of a negative and a positive number
        A = -100;      
        B = 99;       
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, -64'd9900, Product); 

        // Multiplication by zero
        A = 0;      
        B = 98765; // 2^31 - 1       
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 64'd0, Product); 

        // Multiplication by one
        A = 1;      
        B = 98765; // 2^31 - 1      
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 64'd98765, Product); 

        // Random test case 1
        A = -200;       
        B = 4008;       
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, -64'd801600,  Product); 

        //andom test case 2
        A = -111;       
        B = -2222;       
        test_case_number = test_case_number + 1;
        #10;
        check_result(A, B, 64'd246642, Product); 

        $display("Total Test Cases: %0d, Success: %0d, Failures: %0d", 
                success_tcs + failure_tcs, success_tcs, failure_tcs);
        $finish;
    end
endmodule
