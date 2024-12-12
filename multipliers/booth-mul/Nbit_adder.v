module NBitAdder #(parameter N = 5) (
    input [N-1:0] A,   
    input [N-1:0] B,  
    input Cin,
    output [N-1:0] Sum,
    output Cout      
);

    wire [N-1:0] carry; 

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : GEN_FA
            fa fa1 (A[i], B[i], (i == 0) ? Cin : carry[i-1], Sum[i], carry[i]);
        end
    endgenerate
    assign Cout = carry[N-1];

endmodule