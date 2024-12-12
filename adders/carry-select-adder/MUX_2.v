module MUX_2 #(parameter N = 1) (
    input wire [N-1:0] A,
    input wire [N-1:0] B, 
    input wire Sel,
    output wire [N-1:0] F
);
    assign F = (Sel == 0) ? A : B;
endmodule