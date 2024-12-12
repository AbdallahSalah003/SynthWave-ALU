module booth_mul(
    input [31:0] A, B,
    output [63:0] Product
);
    wire [31:0] nextA [0:32]; 
    wire [31:0] nextQ [0:32]; 
    wire [32:0] q_1;
    assign q_1[0] = 1'b0;
    assign nextA[0] = 32'b0;
    assign nextQ[0] = B;

    genvar i;
    generate
    for (i = 0; i < 32; i = i + 1) begin : booth_instances
        booth_operation stepi(nextA[i], nextQ[i], A, q_1[i], nextA[i+1], nextQ[i+1], q_1[i+1]) ;
    end
    endgenerate

    assign Product[63:32] = nextA[32];
    assign Product[31:0] = nextQ[32];

endmodule