module ripple_carry_adder (
    input [31:0] A,       
    input [31:0] B,       
    input Cin,            
    output [31:0] Sum,    
    output Cout,          
    output Overflow       
);
    wire [31:0] carry;

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : full_adder
            full_adder_1bit FA (
                .A(A[i]), 
                .B(B[i]), 
                .Cin(i == 0 ? Cin : carry[i-1]), 
                .Sum(Sum[i]), 
                .Cout(carry[i])
            );
        end
    endgenerate

    assign Cout = carry[31];

    assign Overflow = ((~(A[31] ^ B[31])) & (Sum[31] ^ A[31]));

endmodule