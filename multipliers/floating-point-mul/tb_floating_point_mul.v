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
        // Test cases with IEEE-754 formatted inputs and expected results

        // Test Case 1: Multiplication of two positive numbers


        // Test Case 2: Multiplication of a positive and a negative number
        A = create_fp(1, 8'b01111101, 23'b00110011001100110011010);    // -0.3 = 0.010011 = 1.0011 *  2^-2
        B = create_fp(0, 8'b10000111, 23'b11110100010000000000000);   // 500.25 = 111110100.01 = 1.1111010001 * 2^8 
        test_case_number = test_case_number + 1;     
        #10;                                        //  8 -2 = 7, result bais exp(7 + 127)
        check_result(A, B, create_fp(1, 8'b10000110, 23'b00101100001001100110100), Product);  

        // // Test Case 3: Multiplication with zero


        // // Test Case 4: Multiplication by one


        // // Test Case 5: Multiplication of two negative numbers


        // Test Case 6: Small value multiplication

        // Test Case 7: Large value multiplication


        // Test Case 8: Denormalized number multiplication
        

        $display("Total Test Cases: %0d, Success: %0d, Failures: %0d", 
                success_tcs + failure_tcs, success_tcs, failure_tcs);
        $finish;
    end
endmodule




// `timescale 1 ns / 100 ps
// module FloatingPointMultiplier_tb;
//     reg signed [31:0] A, B;
//     wire signed [31:0] result;
//     integer success= 0;
//     integer failure= 0;
//     integer i;
//     reg clk = 0;
//     floating_integration u1 (
//         .clk(clk),
//         .input1(A),
//         .input2(B),
//         .output1(result)
//     );

//   always #1 clk = ~clk;


//     initial begin
       
//     // Test case 1: Multiplication of positive and negative number
//     A = 32'b00000000101100000000000000000000; 
//     B = 32'b10000001101000000000000000000000; 
//     #100; // Wait for the result
//     if ( result=== 32'b10000001101100000000000000000000) begin 
//       $display("TestCase#1: success");
//       success = success + 1;
//     end else begin
//       $display("TestCase#1: failed with input %d and %d and Output %d", A,B,result);
//       failure = failure + 1;
//     end

//     // Test case 2: Multiplication of positive and positive number
//     A = 32'b00000000101000000000000000000000; 
//     B = 32'b00000000101000000000000000000000;
//     #100; // Wait for the result
//     if (result=== 32'b00000000101000000000000000000000) begin 
//       $display("TestCase#2: success");
//       success = success + 1;
//     end else begin
//       $display("TestCase#2: failed with input %d and %d and Output %d", A,B,result);
//       failure = failure + 1;
//     end

//     // Test case 3: Multiplication of negative and negative number
//     A = 32'b10000000101100000000000000000000; 
//     B = 32'b10000001101000000000000000000000; 
//     #100; // Wait for the result
//     if (result=== 32'b00000001101100000000000000000000) begin 
//       $display("TestCase#3: success");
//       success = success + 1;
//     end else begin
//       $display("TestCase#3: failed with input %d and %d and Output %d", A,B,result);
//       failure = failure + 1;
//     end

//     // Test case 4: Multiplication of negative and positive number
//     A = 32'b10000000101100000000000000000000; 
//     B = 32'b00000001101000000000000000000000; 
//     #100; // Wait for the result
//     if (result=== 32'b10000001101100000000000000000000) begin 
//       $display("TestCase#4: success");
//       success = success + 1;
//     end else begin
//       $display("TestCase#4: failed with input %d and %d and Output %d", A,B,result);
//       failure = failure + 1;
//     end

//     // Test case 5: Multiplication by zero
//     A = 32'b00000000000000000000000000000000; 
//     B = 32'b00000001101000010001011100010100; 
//     #100; // Wait for the result
//     if (result=== 32'b00000001100000000000000000000000) begin 
//       $display("TestCase#5: success");
//       success = success + 1;
//     end else begin
//       $display("TestCase#5: failed with input %d and %d and Output %d", A,B,result);
//       failure = failure + 1;
//     end

//     // Test case 6: Multiplication by 1
//     A = 32'b00000000110000000000000000000000; 
//     B = 32'b00000001101000010001011100010100; 
//     #100; // Wait for the result
//     if (result=== 32'b00000010001000010001011100010100) begin 
//       $display("TestCase#6: success");
//       success = success + 1;
//     end else begin
//       $display("TestCase#6: failed with input %d and %d and Output %d", A,B,result);
//       failure = failure + 1;
//     end

//     // Test case 7: Random test case 1
//     A = 32'b10000011111000000000000000000000; 
//     B = 32'b00000001001000000000000000000000; 
//     #100; // Wait for the result
//     if (result=== 32'b10000100101100000000000000000000) begin 
//       $display("TestCase#7: success");
//       success = success + 1;
//     end else begin
//       $display("TestCase#7: failed with input %d and %d and Output %d", A,B,result);
//       failure = failure + 1;
//     end

//     // Test case 8: Random test case 2
//     A = 32'b10000011001000000000000000000000; 
//     B = 32'b10000000001111000000010000010000; 
//     #100; // Wait for the result
//     if (result=== 32'b00000010101111000000010000010000) begin 
//       $display("TestCase#8: success");
//       success = success + 1;
//     end else begin
//       $display("TestCase#8: failed with input %d and %d and Output %d", A,B,result);
//       failure = failure + 1;
//     end

//     // Final report
//     $display("Total number of success test cases: %d", success);
//     $display("Total number of failure test cases: %d", failure);
//   end

// endmodule