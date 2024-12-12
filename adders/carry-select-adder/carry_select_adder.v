module carry_select_adder(
    input [31:0] A,
    input [31:0] B,
    input Cin,
    output [31:0] Sum,
    output Cout,
    output Overflow
    );

    wire [3:0] CoutSelector;
    wire [6:0] Sum7_Carry0;
    wire [6:0] Sum7_Carry1;
    wire [8:0] Sum9_Carry0;
    wire [8:0] Sum9_Carry1;
    wire [10:0] Sum11_Carry0;
    wire [10:0] Sum11_Carry1;
    wire [3:0]Cout_Carry0;
    wire [3:0]Cout_Carry1;

    NBitAdder SumFirst5(A[4:0],B[4:0],Cin,Sum[4:0],CoutSelector[0]);

    NBitAdder #(7) Adder7_Carry0(A[11:5],B[11:5],1'b0,Sum7_Carry0,Cout_Carry0[0]);
    NBitAdder #(7) Adder7_Carry1(A[11:5],B[11:5],1'b1,Sum7_Carry1,Cout_Carry1[0]);
    MUX_2 #(7) mux0(Sum7_Carry0,Sum7_Carry1,CoutSelector[0], Sum[11:5]);
    MUX_2 CarryOutMux7(Cout_Carry0[0], Cout_Carry1[0], CoutSelector[0], CoutSelector[1]);

    NBitAdder #(9) Adder9_Carry0(A[20:12],B[20:12],1'b0,Sum9_Carry0,Cout_Carry0[1]);
    NBitAdder #(9) Adder9_Carry1(A[20:12],B[20:12],1'b1,Sum9_Carry1,Cout_Carry1[1]);
    MUX_2 #(9) mux1(Sum9_Carry0,Sum9_Carry1,CoutSelector[1], Sum[20:12]);
    MUX_2 CarryOutMux9(Cout_Carry0[1], Cout_Carry1[1], CoutSelector[1], CoutSelector[2]);

    NBitAdder #(11) Adder11_Carry0(A[31:21],B[31:21],1'b0,Sum11_Carry0,Cout_Carry0[2]);
    NBitAdder #(11) Adder11_Carry1(A[31:21],B[31:21],1'b1,Sum11_Carry1,Cout_Carry1[2]);
    MUX_2 #(11) mux2(Sum11_Carry0,Sum11_Carry1,CoutSelector[2], Sum[31:21]);
    MUX_2 CarryOutMux11(Cout_Carry0[2], Cout_Carry1[2], CoutSelector[2], CoutSelector[3]);

    assign Cout = CoutSelector[3];
    assign Overflow =(~(A[31] ^ B[31]) & (A[31] ^ Sum[31]));


endmodule