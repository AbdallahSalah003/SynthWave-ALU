module carry_bypass_4bit(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire PSel = (A[0]^B[0])&(A[1]^B[1])&(A[2]^B[2])&(A[3]^B[3]); // propagation bits anded together to select the carry
    wire [3:0] carries;

    full_adder_1bit bit0(A[0], B[0], Cin, Sum[0], carries[0]);
    full_adder_1bit bit1(A[1], B[1], carries[0], Sum[1], carries[1]);
    full_adder_1bit bit2(A[2], B[2], carries[1], Sum[2], carries[2]);
    full_adder_1bit bit3(A[3], B[3], carries[2], Sum[3], carries[3]);

    MUX_2 CoutMux(carries[3], Cin, PSel, Cout);

endmodule