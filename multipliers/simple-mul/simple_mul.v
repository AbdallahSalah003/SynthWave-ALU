module simple_mul (
    input signed  [31:0] A,
    input signed [31:0] B,
    output signed  [63:0] Product
);
    assign Product = A * B;
endmodule