module floating_point_mul (
    input [31:0] A,
    input [31:0] B,
    output [31:0] Product
);
    
    reg [23:0] mantissaA, mantissaB;
    reg [47:0] tempResult;
    reg [22:0] finalMantissa;
    reg [7:0] expA, expB;
    reg [8:0] tempExp;
    reg tempSign;



    always @(A, B) begin
        mantissaA = {1'b1, A[22:0]};
        mantissaB = {1'b1, B[22:0]};

        expA = A[30:23];
        expB = B[30:23];

        tempResult = 0;
        tempSign = A[31] ^ B[31];

        if (A[30:0] == 31'd0 || B[30:0] == 31'd0) begin
            finalMantissa = 23'd0;
            tempExp = 9'd0;
            tempSign = 1'b0;
        end else begin
            tempResult = mantissaA * mantissaB;

            tempExp = expB + expA - 8'b01111111 + tempResult[47];
            finalMantissa = (tempResult[47] == 1'b1) ? tempResult[46:24] + tempResult[23] : tempResult[45:23] + tempResult[22];
        end
    end
    
    assign Product[31] = tempSign;
    assign Product[30:23] = tempExp[7:0];
    assign Product[22:0] = finalMantissa;

endmodule
