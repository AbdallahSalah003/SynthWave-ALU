module carry_bypass_32bit (
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] Sum,
    output Cout,
    output Overflow
);

    wire [6:0] carries;

    carry_bypass_4bit bits4_0(A[3:0], B[3:0], Cin, Sum[3:0], carries[0]);
    carry_bypass_4bit bits4_1(A[7:4], B[7:4], carries[0], Sum[7:4], carries[1]);
    carry_bypass_4bit bits4_2(A[11:8], B[11:8], carries[1], Sum[11:8], carries[2]);
    carry_bypass_4bit bits4_3(A[15:12], B[15:12], carries[2], Sum[15:12], carries[3]);
    carry_bypass_4bit bits4_4(A[19:16], B[19:16], carries[3], Sum[19:16], carries[4]);
    carry_bypass_4bit bits4_5(A[23:20], B[23:20], carries[4], Sum[23:20], carries[5]);
    carry_bypass_4bit bits4_6(A[27:24], B[27:24], carries[5], Sum[27:24], carries[6]);
    carry_bypass_4bit bits4_7(A[31:28], B[31:28], carries[6], Sum[31:28], Cout);

    assign Overflow = ((~(A[31] ^ B[31])) & (Sum[31] ^ A[31]));


endmodule